# Stage 1: Build reth
FROM rust:1.72-alpine3.18 as builder

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
    cmake

# Clone the latest version of reth
RUN git clone https://github.com/paradigmxyz/reth.git && \
    cd reth && \
    git fetch --tags && \
    latestTag=$(git describe --tags `git rev-list --tags --max-count=1`) && \
    git checkout $latestTag

WORKDIR /reth

# Build reth with specified flags
ENV RUSTFLAGS="-C target-cpu=native"
RUN cargo build --profile maxperf

# Stage 2: Create the runtime image
FROM alpine:3.18

# Install runtime dependencies
RUN apk add --no-cache \
    libgcc \
    openssl \
    ca-certificates

# Copy the built executable
COPY --from=builder /reth/target/maxperf/reth /usr/local/bin/

# Create data directory
RUN mkdir -p /data
VOLUME ["/data"]

# Expose default ports
EXPOSE 8545 8546 30303 30303/udp

ENTRYPOINT ["reth"]
CMD ["node"]
