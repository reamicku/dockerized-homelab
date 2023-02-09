# Homelab

## Introduction

This is my homelab. Heavily work in progress.

## Requirements

- Domain
- Docker
- User has rootless access to docker

## Setup

1. Create environment file.

   Modify values in `.env` file.

   ```bash
   cp .env.example .env
   chmod 600 .env
   ```

1. Run the initial setup file.

   ```bash
   ./init.sh
   ```

1. Generate basic http authentication credentials.

   Modify `username` and `mystrongpassword` to your liking.

   ```bash
    echo $(htpasswd -nb username mystrongpassword) > shared/.htpasswd
   ```

1. Change directory to `services/traefik2`.

   ```bash
   cd services/traefik2
   ```

1. Start up temporary compose `le-staging.yml`.

   After executing the command, LetsEncrypt staging certificates will start to be pulled.

   ```bash
   docker compose -f le-staging.yml up -d
   ```

1. Confirm that LetsEncrypt staging certificates have been pulled.

   ```bash
   grep -e "uri" -e "main" acme/acme.json
   ```

   You can watch for them via:

   ```bash
   watch grep -e "uri" -e "main" acme/acme.json
   ```

   Browse to https://traefik.domain.tld and check the served certificate.

   If certificates are present, then continue with next step.

   If certificates are not present, then check for errors in `logs/traefik.log` file.

1. Shutdown temporary `le-staging.yml` compose.
   ```bash
   docker compose down
   ```
1. Remove all content from `acme.json` file.

   ```bash
   > acme/acme.json
   ```

   Ensure that there is no content:

   ```bash
   cat acme/acme.json
   ```

1. Start up temporary compose `le-production-pull.yml`.

   After executing the command, LetsEncrypt **production certificates** will start to be pulled.

   Please use this only when you are certain that traefik has pulled staging certificates in the previous steps.

   ```bash
   docker compose -f le-production-pull.yml up -d
   ```

1. Confirm that letsencrypt production certificates have been pulled.

   ```bash
   grep -e "uri" -e "main" acme/acme.json
   ```

   You can watch for them via:

   ```bash
   watch grep -e "uri" -e "main" acme/acme.json
   ```

   If certificates are present, then continue with next step.

1. Shutdown temporary `le-production-pull.yml` compose.

   ```bash
   docker compose down
   ```

1. Change directory back to the repository's root directory.

   ```bash
   cd ../..
   ```

1. Start the production `traefik2` proxy.

   ```bash
   ./start traefik2
   ```

## Usage

Use following scripts manage services:

| Command     | Arguments             | Description                             |
| ----------- | --------------------- | --------------------------------------- |
| `./list`    | -                     | List available services                 |
| `./restart` | Service name \| `all` | Restarts a given service / all services |
| `./start`   | Service name \| `all` | Starts a given service / all services   |
| `./stop`    | Service name \| `all` | Stops a given service / all services    |

## Applications

| App       | Description                    | Service name | URL                    |
| --------- | ------------------------------ | ------------ | ---------------------- |
| Traefik 2 | Proxy for all services.        | `traefik2`   | `dashboard.domain.tld` |
| Portainer | Container management dashboard | `portainer`  | `portainer.domain.tld` |
