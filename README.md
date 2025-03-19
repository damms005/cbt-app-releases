# CBT App Releases

Public distribution point for the [CBT app](https://github.com/damms005/cbt_dev). This repo does not contain source code — it only hosts release assets and setup scripts.

## How releases get here

1. A version is tagged in the main [cbt_dev](https://github.com/damms005/cbt_dev) repo (via `./publish.sh`)
2. The tag push triggers a GitHub Action (`.github/workflows/release.yml`) in cbt_dev
3. The GA builds the client + server, packages them into `deployment.zip`, and uploads it as a GitHub Release asset here

The latest `deployment.zip` is always available at the [releases page](https://github.com/damms005/cbt-app-releases/releases).

## How deployments work

The [CBT Deployer](https://github.com/damms005/cbt-docker-app-deployer-releases/releases/latest) — an Electron desktop app — downloads `deployment.zip` from this repo and provisions all Docker containers automatically. End users don't interact with Docker directly.

## Auto-setup (Linux)

For headless Linux servers, the included script installs the deployer app and all system dependencies:

```bash
wget -qO- https://raw.githubusercontent.com/damms005/cbt-app-releases/refs/heads/main/auto-setup-cbt-deployer.sh | bash
```

<img width="1208" alt="image" src="https://github.com/user-attachments/assets/ee2bd972-4766-4b5e-b7e3-28296830d6d5">
