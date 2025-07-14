# Dockerfile: ghcr.io/kimbodo/ppm-git:2025-04
FROM rstudio/rstudio-package-manager:ubuntu2204

USER root
# 1. Git so PPM can clone, Python so it can build wheels
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        git python3 python3-venv python3-pip && \
    # 2. PPM-required build helpers
    pip3 install --no-cache-dir build virtualenv && \
    # 3. Clean up
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Optional – make it explicit for PPM
ENV PACKAGEMANAGER_PYTHON_VERSION=/usr/bin/python3

USER rstudio-pm