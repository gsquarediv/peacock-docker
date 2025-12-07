# Peacock‑Docker

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/gsquarediv/peacock-docker/docker-publish.yml?style=for-the-badge)
![License](https://img.shields.io/github/license/gsquarediv/peacock-docker?style=for-the-badge)

Container image of the [**Peacock**](https://github.com/thepeacockproject/Peacock) server replacement for *HITMAN: World of Assassination*.

> [!NOTE]  
> This repository **does not** contain the Peacock source code and is not affiliated with Peacock in any way.  This repository is a simple wrapper that only packages the official release from the upstream repository (`thepeacockproject/Peacock`) into a production‑ready container image.

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
  ghcr.io/gsquarediv/peacock-docker:latest
```

> ⚡ **Tip** – If you prefer Docker‑Compose:

```yaml
# docker-compose.yml
services:
  peacock:
    image: ghcr.io/gsquarediv/peacock-docker:latest
    volumes:
      - userdata:/peacock/userdata
      - contractSessions:/peacock/contractSessions
    ports:
      - 3000:3000
volumes:
  userdata:
  contractSessions:
```

```bash
docker compose up -d
```

---

## 📦 Features

| Feature | Description |
|---------|-------------|
| **Zero‑touch installation** | Pull a pre‑built image – no Node.js or Yarn setup needed. |
| **Multi‑architecture** | Built for `x86_64` & `ARM64`. |
| **Automatic releases** | GitHub Actions checks for upstream Peacock releases nightly and publishes a new container image as needed. |
| **Data persistence** | User data & contract sessions are stored in Docker named volumes. |
| **Self‑contained** | All dependencies (Node, NVM, Peacock binary) are baked in. |
| **AGPL‑3.0** | The image respects the upstream license. |

---

## 📚 How it works

1. **Containerfile** – Installs `curl`, `unzip`, `node` via NVM, downloads the latest Peacock release, unpacks it, and exposes the required port.
2. **docker-compose.yml** – Exposes two named volumes (`userdata` & `contractSessions`) so data survives container restarts.
3. **GitHub Actions** –
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
* **Node Version Manager** - <https://github.com/nvm-sh/nvm>
