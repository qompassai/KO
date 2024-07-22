FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    ninja-build \
    wget \
    zlib1g-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

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

# Clone and build liboqs
RUN git clone --branch main https://github.com/open-quantum-safe/liboqs.git && \
    cd liboqs && \
    mkdir build && cd build && \
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=ON .. && \
    ninja && ninja install && \
    cd ../.. && \
    rm -rf liboqs

# Clone and build OpenSSL with OQS support
RUN git clone --branch OQS-OpenSSL_1_1_1-stable https://github.com/open-quantum-safe/openssl.git && \
    cd openssl && \
    ./Configure shared linux-x86_64 -lm --prefix=/usr/local/ssl --openssldir=/usr/local/ssl \
    --with-oqs-dir=/usr/local && \
    sed -i 's/^CFLAGS=/CFLAGS=-I\/usr\/local\/include /' Makefile && \
    sed -i 's/^LDFLAGS=/LDFLAGS=-L\/usr\/local\/lib /' Makefile && \
    make -j && \
    make install_sw && \
    cd .. && \
    rm -rf openssl

# Set OpenSSL environment variables
ENV OPENSSL_ROOT_DIR=/usr/local/ssl
ENV OPENSSL_DIR=/usr/local/ssl
ENV LD_LIBRARY_PATH=/usr/local/ssl/lib:/usr/local/lib:$LD_LIBRARY_PATH
ENV PATH=/usr/local/ssl/bin:$PATH
ENV PKG_CONFIG_PATH=/usr/local/ssl/lib/pkgconfig:$PKG_CONFIG_PATH

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
