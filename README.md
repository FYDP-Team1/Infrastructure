# Deployment for Simple Meal

## Prerequisites

- A Docker host system
- A domain
- A Cloudflare account with a Cloudflare Tunnel configured
- This [Watchtower Update](https://github.com/marketplace/actions/watchtower-update) GitHub action included in the main code repository
- (Optional) A [Discord Webhook](https://containrrr.dev/shoutrrr/v0.8/services/discord/) for notifications - can be removed by deleting the `WATCHTOWER_NOTIFICATION_URL` environment variable from docker-compose.yml

## Configuring

Fill in the environment variables in the following files and place them in the root of this repository.

### .env

```properties
APPDATA=  # The path to where you want to store the data from the docker containers
WATCHTOWER_HTTP_API_TOKEN=  # Generate a random string for the Watchtower Action
WATCHTOWER_DISCORD_WEBHOOK_TOKEN=
WATCHTOWER_DISCORD_WEBHOOK_ID=  # Generated based on instructions above
```

### samplemeal.env

```properties
REACT_APP_IS_DEBUG='FALSE'

REACT_APP_API_URL='https://<YOUR-DOMAIN-HERE>'
REACT_APP_API_PORT=3001

POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_HOST=simplemeal-db
```

## Deploying

1. Clone this repository to the host system
2. Run `docker-compose up -d`
3. Run `docker-compose -f simplemeal-compose.yml up -d`