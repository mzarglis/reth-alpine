# Stage 1: Build reth
FROM alpine:latest as builder

# Install build dependencies
RUN apk add --no-cache \
    git \
    make \
    gcc \
    musl-dev \
    linux-headers \
    pkgconfig \
    openssl-dev \
    clang-dev \
    cmake \
    curl

# Install latest stable Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Set target for x86-64
RUN rustup target add x86_64-unknown-linux-musl

# Clone the latest version of reth
RUN git clone https://github.com/paradigmxyz/reth.git && \
    cd reth && \
    git fetch --tags && \
    latestTag=$(git describe --tags `git rev-list --tags --max-count=1`) && \
    git checkout $latestTag

WORKDIR /reth

# Build reth with x86-64 specific optimizations
ENV RUSTFLAGS="-C target-cpu=x86-64 -C target-feature=+sse,+sse2,+sse3,+ssse3,+sse4.1,+sse4.2,+avx,+avx2"
RUN cargo build --profile maxperf --target x86_64-unknown-linux-musl

# Stage 2: Create the runtime image
FROM alpine:latest

# Install runtime dependencies
RUN apk add --no-cache \
    libgcc \
    openssl \
    ca-certificates

# Copy the built executable
COPY --from=builder /reth/target/x86_64-unknown-linux-musl/maxperf/reth /usr/local/bin/

# Create data directory
RUN mkdir -p /data
VOLUME ["/data"]

# Expose default ports
EXPOSE 8545 8546 30303 30303/udp

ENTRYPOINT ["reth"]
CMD ["node"]
