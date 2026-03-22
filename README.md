# Peacock‑Docker

[![GitHub Workflow Status](https://github.com/gsquarediv/peacock-docker/actions/workflows/docker-publish.yml/badge.svg?branch=master)](https://github.com/gsquarediv/peacock-docker/actions/workflows/docker-publish.yml)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

Container image of the [**Peacock**](https://github.com/thepeacockproject/Peacock) server replacement for *HITMAN: World of Assassination*.

> [!NOTE]  
> This repository **does not** contain the Peacock source code and is not affiliated with Peacock in any way.  This repository is a simple wrapper that only packages the official release from the upstream repository ([`thepeacockproject/Peacock`](https://github.com/thepeacockproject/Peacock)) into a production‑ready container image.

---

## 🚀 Quick start

```bash
# Pull the latest image
docker pull ghcr.io/gsquarediv/peacock-docker:latest

# Run it – expose port 3000 and persist data
docker run \
  -d \
  -p 3000:3000 \
  -v userdata:/peacock/userdata \
  -v contractSessions:/peacock/contractSessions \
  -v contracts:/peacock/contracts \
  -v plugins:/peacock/plugins \
  -v options:/peacock/options \
  ghcr.io/gsquarediv/peacock-docker:latest
```

> ⚡ **Tip** – If you prefer Docker‑Compose:

```bash
docker compose up -d
```

---

## 📦 Features

| Feature | Description |
|---------|-------------|
| **Zero‑touch installation** | Pull a pre‑built image – no Node.js or Yarn setup needed. |
| **Offline capable** | Starting with v8.7.0, all offline assets are baked in to the image.  There's no need to run `chunk0.js tools` to download the image pack. |
| **Multi‑architecture** | Built for `x86_64` & `ARM64`. |
| **Automatic releases** | GitHub Actions checks for upstream Peacock releases nightly and publishes a new container image as needed. |
| **Data persistence** | User data & contract sessions are stored in Docker named volumes. |
| **Self‑contained** | All dependencies (Node.js and Peacock binaries) are baked in. |
| **AGPL‑3.0** | The image respects the upstream license. |

---

## 📚 How it works

1. **Containerfile:** Installs `curl`, `unzip`, `node`, downloads the latest Peacock release, unpacks it, and exposes the required port.
2. **docker-compose.yml:** Exposes five named volumes (`userdata`, `contractSessions`, `contracts`, `plugins`, & `options`) so data survives container removal.
3. **GitHub Actions:**
   * `docker-publish.yml` checks the latest Peacock tag.
   * If a new tag appears, a new Docker image is built & pushed to **GitHub Container Registry (ghcr.io)**.
   * The image is signed with **cosign** for provenance.

---

## 📄 License

This project is distributed under the **AGPL‑3.0** license.
See the [LICENSE](LICENSE) file for details.

> ⚠️ The image contains the Peacock binary, which is itself licensed under AGPL‑3.0.

---

## 👤 Acknowledgements

* **The Peacock Project** – <https://github.com/thepeacockproject>
