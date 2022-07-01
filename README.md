# Configuration of Mieux Voter server


Machine is running on Ubuntu 22.04.

## Installation

```bash
sudo apt install make
mkdir src
git clone https://github.com/MieuxVoter/dotfiles
cd dotfiles
make docker

# Optional (config files)
make install
make ripgrep
make neovim
sudo apt install libfuse-dev
```

## Launching SWAG server

SWAG = Docker + nginx + let's encrypt + fail2ban + plenty of configuration files.

Copy `swag/.env` into your own environment file (e.g. `.env.local`). Then, create files in `$SWAG_CONFIG_DIR` corresponding to fill missing fields in `swag/docker-compose.yaml` starting with `/run/docker-swag/`.

```bash
cd swag
docker compose --env-file /path/to/your/.env up -d 
```

## Mautic

Copy the `mautic/.env` file anywhere else (it could into your `/etc/` or `.env.local`). 

Install Docker, and launch the container:

```bash
cd mautic
docker compose --env-file /path/to/your/env up -d 
```

Then, copy the config file to your nginx proxy-confs folder:

```bash
cp $PWD/mautic.subdomain.conf $SWAG_CONFIG_DIR/nginx/nginx/proxy-confs/
```

Restart the SWAG container:

```bash
cd swag
docker compose --env-file /path/to/swag/env/file restart
```

## Authelia

Copy the `authelia/.env` file anywhere else (it could into your `/etc/` or `.env.local`). 

Install Docker, and launch the container:

```bash
cd authelia
docker compose --env-file /path/to/your/env up -d 
```

Then, move the config file of your nginx proxy-confs folder:

```bash
cd $SWAG_CONFIG_DIR/nginx/nginx/proxy-confs/
cp authelia.subdomain.conf.sample authelia.subdomain.conf
```

Restart the SWAG container:

```bash
cd swag
docker compose --env-file /path/to/swag/env/file restart
```
