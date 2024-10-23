# Reth Alpine Docker Image

This repository contains a Docker image build for [Reth](https://github.com/paradigmxyz/reth), an Ethereum execution client implementation in Rust. The image is based on Alpine Linux for minimal size while maintaining full functionality.

## Features

- Multi-stage Docker build for minimal image size
- Based on Alpine Linux
- Automatically builds with the latest Reth release
- Optimized build specifically for x86-64 CPUs with advanced instruction sets (SSE, AVX, etc.)
- Published to GitHub Container Registry

## Usage

Pull the image:
```bash
docker pull ghcr.io/OWNER/reth-alpine:latest
```

Run Reth node:
```bash
docker run -d \
  --name reth \
  -v /path/to/data:/data \
  -p 8545:8545 \
  -p 8546:8546 \
  -p 30303:30303 \
  -p 30303:30303/udp \
  ghcr.io/OWNER/reth-alpine:latest
```

## Build Configuration

The image is built with the following optimizations:
- Targeted for x86-64 architecture
- Optimized for modern Intel/AMD CPUs with SSE, SSE2, SSE3, SSSE3, SSE4.1, SSE4.2, AVX, and AVX2 instruction sets
- Uses maxperf profile for maximum performance
- Static linking against musl libc for better portability

## Automated Builds

The image is automatically rebuilt:
- On every push to main branch
- Weekly to incorporate the latest Reth release
- Can be manually triggered through GitHub Actions

## System Requirements

This image is optimized for and requires:
- x86-64 CPU
- Support for SSE, SSE2, SSE3, SSSE3, SSE4.1, SSE4.2, AVX, and AVX2 instruction sets
- Modern Intel or AMD processor

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
