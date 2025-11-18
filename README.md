# vps

Initial setup.

## Install curl on Debian

```bash
sudo apt update && sudo apt install -y curl
```

## Install key on a new VPS

```bash
curl -fsSL https://raw.githubusercontent.com/leoricshcn/vps/main/install_key.sh -o install_key.sh && bash install_key.sh
```

## Run install233 on a new VPS

```bash
curl -fsSL https://raw.githubusercontent.com/leoricshcn/vps/main/install233.sh -o install233.sh && bash install233.sh
```

## Install Nginx reverse proxy

```bash
curl -fsSL https://raw.githubusercontent.com/leoricshcn/vps/main/install_nginx_reverse_proxy.sh -o install_nginx_reverse_proxy.sh && bash install_nginx_reverse_proxy.sh
```

Set the `DOMAIN`, `TARGET`, or `LISTEN_PORT` environment variables before running if you need non-default values, otherwise the script will prompt for the domain and use `http://127.0.0.1:3000` on port `80`.
