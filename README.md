

# ghcr.io/kimbodo/ppm-git:2025‑04

Custom Posit Package Manager (PPM) image with **Git**, **Python 3**, and the
required build helpers so PPM can automatically clone and build Python wheels
from Git repositories.

---

## What this image adds

| Layer | Packages / settings | Reason |
|-------|---------------------|--------|
| **System** | `git`, `python3`, `python3-venv`, `python3-pip` | Enables PPM **git‑python** builder and wheel building. |
| **Python tools** | `build`, `virtualenv` (installed with `pip`) | Current best‑practice tools for isolated wheel builds. |
| **Env var** | `PACKAGEMANAGER_PYTHON_VERSION=/usr/bin/python3` | Makes the Python interpreter explicit to PPM. |

All other behaviour comes from the upstream
[`rstudio/rstudio-package-manager:ubuntu2204`](https://hub.docker.com/r/rstudio/rstudio-package-manager/)
base image.

---

## Pulling the image

```bash
docker pull ghcr.io/kimbodo/ppm-git:2025-04
```

---

## Using the image in Kubernetes / Helm

```yaml
# values-override.yaml
image:
  repository: ghcr.io/kimbodo/ppm-git
  tag: "2025-04"   # or a newer tag you push later
  pullPolicy: IfNotPresent

config:
  Server:
    PythonVersion: /usr/bin/python3   # keep in sync with ENV
```

Then upgrade or install:

```bash
helm upgrade --install rstudio-package-manager rstudio/rstudio-pm   -f values-override.yaml
```

*Important:* keep your existing `license`, `sharedStorage`, and Postgres values
unchanged—only override the `image` and (optionally) the `PythonVersion`
setting.

---

## Inside the container

```bash
# open a shell
kubectl exec -it deploy/rstudio-package-manager -- /bin/bash

# verify Python support
rspm --version     # should list git-python builder

# typical workflow
rspm create source   --type=git-python --name=my-src
rspm create git-builder --source=my-src --name=my-lib \
     --url=https://github.com/myorg/my-lib.git --branch=main --wait
rspm create repo --name=internal-python --type=python
rspm subscribe --repo=internal-python --source=my-src
```

The wheels are now served from

```
https://<your-ingress-host>/py/internal-python/simple/
```

and can be installed with:

```bash
pip install --index-url https://<your-ingress-host>/py/internal-python/simple/ my-lib
```

---

## Building your own tag

1. Clone this repo (or copy the supplied Dockerfile).
2. Optionally update package versions.
3. Build & push:

```bash
docker build -t ghcr.io/<your-org>/ppm-git:$(date +%Y%m%d) .
docker push ghcr.io/<your-org>/ppm-git:$(date +%Y%m%d)
```

---

## License

This Dockerfile is released under the MIT License. The base image and any tools
installed retain their original licenses.

---