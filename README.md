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

2. Run the initial setup file.
    ```bash
    ./initial-setup.sh
    ```

3. Generate basic http authentication credentials.
    Modify `username` and `mystrongpassword`.
    ```bash
     echo $(htpasswd -nb username mystrongpassword) > shared/.htpasswd
    ```

4. Change directory to `services/traefik2`.
    ```bash
    cd services/traefik2
    ```

5. Start up temporary compose `le-staging.yml`.
    After executing the command, LetsEncrypt staging certificates will start to be pulled.
    ```bash
    docker compose -f le-staging.yml up -d
    ```

6. Confirm that LetsEncrypt staging certificates have been pulled.
    ```bash
    grep "uri" acme/acme.json
    grep "main" acme/acme.json
    ```
    Browse to https://traefik.domain.tld and check the served certificate.

    If certificates are present, then continue with next step.
    If certificates are not present, then check for errors in `logs/traefik.log` file.

7. Shutdown temporary `le-staging.yml` compose.
    ```bash
    docker compose down
    ```
8. Remove all content from `acme.json` file.
    ```bash
    > acme/acme.json
    ```

9. Start up temporary compose `le-production-pull.yml`.
    After executing the command, LetsEncrypt *production certificates* will start to be pulled.
    Please use this only when you are certain that traefik has pulled staging certificates in the previous steps.
    ```bash
    docker compose -f le-production-pull.yml up -d
    ```

10. Confirm that letsencrypt production certificates have been pulled.
    ```bash
    grep "uri" acme/acme.json
    grep "main" acme/acme.json
    ```
    If certificates are present, then continue with next step.

11. Shutdown temporary `le-production-pull.yml` compose.
    ```bash
    docker compose down
    ```

12. Start the default production compose file `docker-compose.yml`.
    ```bash
    docker compose up -d
    ```
    You can also use the convenience scripts in the root directory of this repository.

13. Change directory back to the repository's root directory.
    ```bash
    cd ../..
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
`./start.sh`   | Service name \| `all` | Starts a given service
`./stop.sh`    | Service name \| `all` | Stops a given service
`./restart.sh` | Service name \| `all` | Restarts a given service

## Troubleshooting

### Q: New update brings new applications. What are the steps to ensure that they will work correctly?

After pulling new repo and new applications are added, we need to create symbolic link for environment variable for each new service. Use the script below to set this up.

```bash
./initial-setup.sh
```