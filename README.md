# Reth Alpine Docker Image

This repository contains a Docker image build for [Reth](https://github.com/paradigmxyz/reth), an Ethereum execution client implementation in Rust. The image is based on Alpine Linux for minimal size while maintaining full functionality.

## Features

- Multi-stage Docker build for minimal image size
- Based on Alpine Linux
- Automatically builds with the latest Reth release
- Optimized build with native CPU instructions
- Published to GitHub Container Registry
- Multi-architecture support (amd64, arm64)

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
- RUSTFLAGS="-C target-cpu=native" for CPU-specific optimizations
- maxperf profile for maximum performance

## Automated Builds

The image is automatically rebuilt:
- On every push to main branch
- Weekly to incorporate the latest Reth release
- Can be manually triggered through GitHub Actions

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
