# Homelab

- [Homelab](#homelab)
  - [Introduction](#introduction)
  - [Requirements](#requirements)
  - [Initial setup](#initial-setup)
    - [Staging certificates](#staging-certificates)
    - [Production (verified) certificates](#production-verified-certificates)
    - [Secrets](#secrets)
    - [Security](#security)
    - [Post-setup](#post-setup)
  - [Usage](#usage)
- [Applications](#applications)
  - [Portainer](#portainer)
    - [Information](#information)
    - [Setup](#setup)
  - [Nextcloud](#nextcloud)
    - [Information](#information-1)
    - [Setup](#setup-1)

## Introduction

This is my homelab. Heavily work in progress.

## Requirements

- Domain
- Docker
- User has rootless access to docker

## Initial setup

1. Create environment file.

   Copy the example enviroment file and set more restrictive permissions.

   ```bash
   cp .env.example .env && chmod 600 .env
   ```

   Modify values in `.env` file.

1. Run the initial setup file.

   ```bash
   ./init
   ```

1. Generate basic http authentication credentials.

   Modify `username` and `mystrongpassword` to your liking.

   ```bash
    echo $(htpasswd -nb username mystrongpassword) > shared/.htpasswd
   ```

### Staging certificates

If you are setting this up for the first time, you might want to first try it out with staging certificates to not accidentally overflow the LetsEncrypt servers.

If you want to skip to production deployment, then proceed to the [Production certificates](#production-verified-certificates) section. Otherwise start from here.

1. Change directory to `services/traefik2`.

   ```bash
   cd services/traefik2
   ```

1. Start up temporary compose `le-staging.yaml`.

   After executing the command, LetsEncrypt staging certificates will start to be pulled.

   ```bash
   docker compose -f le-staging.yaml up -d
   ```

1. Confirm that LetsEncrypt staging certificates have been pulled.next

   If certificates are not present, then check for errors in `logs/traefik.log` file.

1. Shutdown temporary `le-staging.yaml` compose.

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

1. Start up temporary compose `le-production-pull.yaml`.

   After executing the command, LetsEncrypt **production certificates** will start to be pulled.

   Please use this only when you are certain that traefik has pulled staging certificates in the previous steps.

   ```bash
   docker compose -f le-production-pull.yaml up -d
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

1. Shutdown temporary `le-production-pull.yaml` compose.

   ```bash
   docker compose down
   ```

1. Change directory back to the repository's root directory.

   ```bash
   cd ../..
   ```

### Production (verified) certificates

1. Start the production `traefik2` proxy.

   ```bash
   ./start traefik2
   ```

   Traefik Dashboard makes it easy to see if a given service is being properly proxied.

   The service should be available at https://traefik.domain.tld. Login with the credentials you specified in point 3. of [Initial setup](#initial-setup).

### Secrets

Setup basic database secrets. There are used to initialize databases used in this project.

These commands generate a secure password, which is a string containing 32 random characters.

```bash
openssl rand -hex 32 | awk 'BEGIN{ORS="";} {print}' > secrets/db_password
openssl rand -hex 32 | awk 'BEGIN{ORS="";} {print}' > secrets/db_root_password
```

### Security

To improve security, we will make so the files in this directory are only accessible to the group. This makes the files not globally visible.

Execute in the root directory of this project.

```bash
setfacl -d -m g::r -m o::--- .
```

### Post-setup

The basic, barebones setup is ready. Now you can proceed to start deploying other applications.

Follow to [Applications](#applications) section for further instructions.

## Usage

Use following scripts manage services:

| Command     | Arguments             | Description              |
| ----------- | --------------------- | ------------------------ |
| `./status`  | -                     | List active services     |
| `./list`    | -                     | List available services  |
| `./restart` | Service name \| `all` | Restarts a given service |
| `./start`   | Service name \| `all` | Starts a given service   |
| `./stop`    | Service name \| `all` | Stops a given service    |

# Applications

| App       | Service name | URL                    |
| --------- | ------------ | ---------------------- |
| Traefik 2 | `traefik2`   | `traefik.domain.tld`   |
| Portainer | `portainer`  | `portainer.domain.tld` |
| Nextcloud | `portainer`  | `portainer.domain.tld` |

If you plan to use any of the applications listed below, you need to follow their respective setup steps.

These commands might get integrated into the initialization script in the future.

## Portainer

### Information

https://www.portainer.io/

Deploy, configure, troubleshoot and secure containers in minutes on Kubernetes, Docker, Swarm and Nomad in any data center, cloud, network edge or IIOT device.

Access through `https://portainer.domain.tld`

### Setup

Start the application:

```bash
./start portainer
```

Open browser window and connect to the application via the URL.

Setup a new administrator user.

## Nextcloud

### Information

https://nextcloud.com

Nextcloud Hub is the industry-leading, fully open-source, on-premises content collaboration platform. Teams access, share and edit their documents, chat and participate in video calls and manage their mail and calendar and projects across mobile, desktop and web interfaces.

Access through `https://next.domain.tld`

### Setup

Generate secrets for nextcloud's database connection.

```bash
mkdir -p secrets/nextcloud
echo -n nextcloud > secrets/nextcloud/db_name
echo -n nextcloud > secrets/nextcloud/db_user
```

Start the application:

```bash
./start nextcloud
```

Open browser window and connect to the application via the URL.

Setup a new administrator user.
