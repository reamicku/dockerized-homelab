# Homelab

## Introduction

This is my homelab. Heavily work in progress.

## Requirements

- Docker
- User has rootless access to docker

## Setup

1. Copy `.env.example` to `.env` and modify variables.
    ```bash
    cp .env.example .env
    ```

2. Change permissions for `.env` file
    ```bash
    chmod 600 .env
    ```

3. Run the initial setup file.
    ```bash
    ./initial-setup.sh
    ```

4. Generate basic http authentication credentials.
    ```bash
     echo $(htpasswd -nb username mystrongpassword) > shared/.htpasswd
    ```

5. Start up `traefik`.
    ```bash
    cd services/traefik2
    docker compose up -d
    ```

## Usage

Use following commands to control services:

Command | Explaination
-|-
`docker compose up -d` | Starts a given service
`docker compose down`  | Stops a given service

Or use following scripts to do the same:

Command | Argument | Explaination
-|-|-
`./start-service.sh`   | Service name | Starts a given service
`./stop-service.sh`    | Service name | Stops a given service
`./restart-service.sh` | Service name | Restarts a given service

## Post setup

### Move to letsencrypt production certificates

1. Change working directory to `services/traefik2`.
    ```bash
    cd services/traefik2
    ```

2. Stop `traefik2` compose if up.
    ```bash
    docker compose down
    ```

3. Edit `services/traefik2/acme/acme.json` file and remove all contents, so the file is empty.
    ```bash
    nano acme/acme.json
    ```

4. Edit `docker-compose.yml` and comment out line below with `#`.
    ```yml
    - "traefik.http.routers.traefik-rtr.tls.certresolver=dns-cloudflare"
    ```
    to
    ```yml
    # - "traefik.http.routers.traefik-rtr.tls.certresolver=dns-cloudflare"
    ```

5. Start up `traefik2` compose
    ```bash
    docker compose up -d
    ```

6. Confirm that letsencrypt production certificates have been pulled.
    ```bash
    grep "uri" acme/acme.json
    ```

    Example output: 

    ```yml
          "uri": "https://acme-v02.api.letsencrypt.org/acme/acct/123456789"
    ```
7. Edit `docker-compose.yml` and comment out the line below.

    ```yml
    # - "traefik.http.routers.traefik-rtr.tls.certresolver=dns-cloudflare"
    ```
    to
    ```yml
    - "traefik.http.routers.traefik-rtr.tls.certresolver=dns-cloudflare"
    ```

8. Restart `traefik2` compose
    ```bash
    docker compose down
    docker compose up -d
    ```

9. Check that served certificates are valid.

## Notes

After pulling new repo and new applications are added, we need to create symbolic link for environment variable for each new service.

```bash
./initial-setup.sh
```