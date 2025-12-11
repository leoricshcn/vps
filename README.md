# vps

Initial setup.

## Install curl on Debian

```bash
sudo apt update && sudo apt install -y curl
```

## Install mosh

```bash
sudo apt install -y mosh
```

## Install key on a new VPS

```bash
curl -fsSL https://raw.githubusercontent.com/leoricshcn/vps/main/install_key.sh -o install_key.sh && bash install_key.sh
```

## Run install233 on a new VPS

```bash
curl -fsSL https://raw.githubusercontent.com/leoricshcn/vps/main/install233.sh -o install233.sh && bash install233.sh
```

## Install a private key

```bash
curl -fsSL https://raw.githubusercontent.com/leoricshcn/vps/main/install_pk.sh -o install_pk.sh && bash install_pk.sh ./id_ed25519 id_ed25519
```
## Install openai codex cli

```bash
npm i -g @openai/codex
```
copy ~/.codex/auth.json to headless server

```bash
scp .\auth.json root@<vpsaddress>:/root
```

or create a port mapping
```bash
ssh -N -L 127.0.0.1:1455:127.0.0.1:1455 root@<vps>
```
For wsl login, run 

```bash
hostname -I
```
to get ip address of wsl eg. 10.0.0.7

use powershell (not windows powershell) admin to map localhost 1455 port to wsl 1455 port

```ps
netsh interface portproxy add v4tov4 listenport=1455 listenaddress=0.0.0.0 connectport=1455 connectaddress=10.0.0.7
netsh interface portproxy show all
```

## Install Nginx reverse proxy

```bash
curl -fsSL https://raw.githubusercontent.com/leoricshcn/vps/main/install_nginx_reverse_proxy.sh -o install_nginx_reverse_proxy.sh && bash install_nginx_reverse_proxy.sh
```

Set the `DOMAIN`, `TARGET`, or `LISTEN_PORT` environment variables before running if you need non-default values, otherwise the script will prompt for the domain and use `http://127.0.0.1:3000` on port `80`.

## Install Portainer

```bash
curl -fsSL https://raw.githubusercontent.com/leoricshcn/vps/main/install_portainer.sh -o install_portainer.sh && sudo bash install_portainer.sh
```

The script installs Docker (if missing) and runs the Portainer CE container on ports `9443` (HTTPS UI) and `8000` (edge agent) by default. Override `PORTAINER_HTTPS_PORT`, `PORTAINER_EDGE_PORT`, `PORTAINER_CONTAINER_NAME`, or `PORTAINER_IMAGE` to customize the deployment.
