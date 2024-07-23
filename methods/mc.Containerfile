FROM continuumio/miniconda3

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev

# Copy the keys into the container
COPY x25519_kyber768_key.pem /etc/ssl/private/
COPY x25519_kyber768_pubkey.pem /etc/ssl/certs/

# Set proper permissions
RUN chmod 600 /etc/ssl/private/x25519_kyber768_key.pem && \
    chmod 644 /etc/ssl/certs/x25519_kyber768_pubkey.pem

# Set up your Conda environment
RUN conda create -n myenv python=3.11
RUN echo "source activate myenv" > ~/.bashrc
ENV PATH /opt/conda/envs/myenv/bin:$PATH

# Install your AI training dependencies
RUN pip install tensorflow pytorch transformers

# Configure OpenSSL to use the new keys
RUN echo "openssl_conf = openssl_init" >> /etc/ssl/openssl.cnf && \
    echo "" >> /etc/ssl/openssl.cnf && \
    echo "[openssl_init]" >> /etc/ssl/openssl.cnf && \
    echo "ssl_conf = ssl_sect" >> /etc/ssl/openssl.cnf && \
    echo "" >> /etc/ssl/openssl.cnf && \
    echo "[ssl_sect]" >> /etc/ssl/openssl.cnf && \
    echo "system_default = system_default_sect" >> /etc/ssl/openssl.cnf && \
    echo "" >> /etc/ssl/openssl.cnf && \
    echo "[system_default_sect]" >> /etc/ssl/openssl.cnf && \
    echo "CipherString = DEFAULT:@SECLEVEL=2" >> /etc/ssl/openssl.cnf && \
    echo "Ciphersuites = TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256" >> /etc/ssl/openssl.cnf && \
    echo "Groups = X25519:kyber768" >> /etc/ssl/openssl.cnf

# Your AI training script
COPY train.py /app/train.py

WORKDIR /app

CMD ["python", "train.py"]

