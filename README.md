# Configuration of my self-hosted server


Machine is running on Ubuntu 20.04.

## Installation

```bash
sudo apt install make
mkdir src
git clone https://github.com/guhur/dotfiles
cd dotfiles
make docker

# Optional (config files)
make install
make ripgrep
make neovim
sudo apt install libfuse-dev
```

## Traefik

Copy the `traefik/.env` file anywhere else (it could into your `/etc/` or `traefik/.env.local`). 

Install Docker, and launch the container:

```bash
cd traefik
docker compose --env-file /path/to/your/env up -d 
```


## Mautic

Copy the `mautic/.env` file anywhere else (it could into your `/etc/` or `.env.local`). 

Install Docker, and launch the container:

```bash
cd mautic
docker compose --env-file /path/to/your/env up -d 
```

## Plex

https://howto.wared.fr/plex-docker-traefik-ubuntu/

```bash
sudo adduser plex
sudo adduser plex docker
sudo su plex
cd

```

## Nextcloud

Copy the `nextcloud/.env` file anywhere else (it could into your `/etc/` or `.env.local`). 

Launch the container:

```bash
cd nextcloud
docker compose --env-file /path/to/your/env up -d 
```

# Collabora (Nextcloud)

Copy the `collabora/.env` file anywhere else (it could into your `/etc/` or `.env.local`). 

Launch the container:

```bash
cd collabora
docker compose --env-file /path/to/your/env up -d 
```
Then, on your Nextcloud apps, disable "Built-in CODE" and enable "Nextcloud Office". Then, in your settings, on the "Nextcloud Office" pan, put the collabora FQDN.

#### ℹ️  Debug
 
In `collobora/docker-compose.yml`, add:

```
    ports:
      - "9980:9980"
```

Restart the container and visit: `http://<your-local-ip>:9980`. You should obtain a "OK" message.

# Pontoon

Make sure you loaded submodules:

```bash
git submodule update --init --recursive
```

Copy the `pontoon/pontoon/docker/config/server.env.template` file as `pontoon/ pontoon/.env`. Edit its values. 
Similarly, copy `pontoon/.env` as `pontoon/.env.local` and edit it. Add the same postgress password.

Launch the container:

```bash
cd pontoon
docker compose --env-file pontoon/.env up -d 
```
Then, on your Nextcloud apps, disable "Built-in CODE" and enable "Nextcloud Office". Then, in your settings, on the "Nextcloud Office" pan, put the collabora FQDN.

