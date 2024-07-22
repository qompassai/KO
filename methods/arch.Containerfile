FROM archlinux:latest

# Install system dependencies
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel cmake git ninja wget zlib cuda

# Install Miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

# Add conda to path
ENV PATH=$CONDA_DIR/bin:$PATH

# Update conda and create environment
RUN conda update -n base -c defaults conda && \
    conda create -n ai_env python=3.10 -y && \
    conda clean -afy

ENV PATH /opt/conda/envs/ai_env/bin:$PATH

# Activate conda environment and install PyTorch
RUN echo "source activate ai_env" > ~/.bashrc && \
    conda run -n ai_env conda install -y pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia && \
    conda clean -afy

# Build OpenSSL from source
RUN wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz && \
    tar -xzvf openssl-1.1.1k.tar.gz && \
    cd openssl-1.1.1k && \
    ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib \
    -I/usr/include \
    -L/usr/lib \
    -lz && \
    make -j && \
    make install && \
    cd .. && \
    rm -rf openssl-1.1.1k openssl-1.1.1k.tar.gz

# Set OpenSSL environment variables
ENV OPENSSL_ROOT_DIR=/usr/local/ssl
ENV OPENSSL_DIR=/usr/local/ssl
ENV LD_LIBRARY_PATH=$OPENSSL_DIR/lib:$LD_LIBRARY_PATH
ENV PATH=$OPENSSL_DIR/bin:$PATH
ENV PKG_CONFIG_PATH=$OPENSSL_DIR/lib/pkgconfig:$PKG_CONFIG_PATH

# Clone and build liboqs
RUN git clone --branch main https://github.com/open-quantum-safe/liboqs.git && \
    cd liboqs && \
    mkdir build && cd build && \
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr/local/oqs -DOPENSSL_ROOT_DIR=$OPENSSL_ROOT_DIR -DBUILD_SHARED_LIBS=ON .. && \
    ninja && ninja install && \
    cd ../.. && \
    rm -rf liboqs

# Clone and build OpenSSL with OQS support
RUN git clone --branch OQS-OpenSSL_1_1_1-stable https://github.com/open-quantum-safe/openssl.git && \
    cd openssl && \
    ./Configure shared linux-x86_64 -lm --prefix=/usr/local/ssl --openssldir=/usr/local/ssl \
    --with-oqs-dir=/usr/local/oqs \
    -I/usr/include \
    -L/usr/lib \
    zlib && \
    sed -i 's/^CFLAGS=/CFLAGS=-I\/usr\/local\/oqs\/include -I\/usr\/include /' Makefile && \
    sed -i 's/^LDFLAGS=/LDFLAGS=-L\/usr\/local\/oqs\/lib -L\/usr\/lib /' Makefile && \
    make -j && \
    make install_sw && \
    cd .. && \
    rm -rf openssl

# Configure OpenSSL
RUN echo "openssl_conf = openssl_init" >> /usr/local/ssl/openssl.cnf && \
    echo "" >> /usr/local/ssl/openssl.cnf && \
    echo "[openssl_init]" >> /usr/local/ssl/openssl.cnf && \
    echo "providers = provider_sect" >> /usr/local/ssl/openssl.cnf && \
    echo "" >> /usr/local/ssl/openssl.cnf && \
    echo "[provider_sect]" >> /usr/local/ssl/openssl.cnf && \
    echo "default = default_sect" >> /usr/local/ssl/openssl.cnf && \
    echo "oqsprovider = oqs_sect" >> /usr/local/ssl/openssl.cnf && \
    echo "" >> /usr/local/ssl/openssl.cnf && \
    echo "[oqs_sect]" >> /usr/local/ssl/openssl.cnf && \
    echo "activate = 1" >> /usr/local/ssl/openssl.cnf && \
    echo "" >> /usr/local/ssl/openssl.cnf && \
    echo "[default_sect]" >> /usr/local/ssl/openssl.cnf && \
    echo "activate = 1" >> /usr/local/ssl/openssl.cnf && \
    echo "" >> /usr/local/ssl/openssl.cnf && \
    echo "[ssl_sect]" >> /usr/local/ssl/openssl.cnf && \
    echo "Groups = X25519:kyber1024" >> /usr/local/ssl/openssl.cnf

# Verify the installation
RUN conda run -n ai_env python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
RUN /usr/local/ssl/bin/openssl list -providers

SHELL ["/bin/bash", "-c"]
CMD ["source activate ai_env && /bin/bash"]
