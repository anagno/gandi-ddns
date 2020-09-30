# [anagno/gandi-ddns](https://github.com/anagno/gandi-ddns)

This is a simple container for updating a single zone recond using the Gandi`s LiveDNS.

Live dns is available on www.gandi.net

Obtaining your API Key: http://doc.livedns.gandi.net/#step-1-get-your-api-key


## Usage

Here are some example snippets to help you get started creating a container.


To start the container type:

```
docker run -e DOMAIN=example.com -e SUBDOMAIN=subdomain -e APIKEY=YOURAPIKEY anagno/gandi-ddns
```

It is compatible with docker-compose v3 and can be run on a docker swarm cluster:

```
---
version: '3.4'

services:

  gandi:
    image: anagno/gandi-ddns:latest
    environment:
      DOMAIN: "example.com"
      SUBDOMAIN: "subdomain"
      APIKEY_FILE: /run/secrets/gandi_api_key
    secrets:
      - gandi_api_key

    deploy:
      mode: replicated
      replicas: 1
      resources:
        limits:
         cpus: '0.2'
         memory: 20M
        reservations:
         cpus: '0.1'
         memory: 10M

secrets:
  gandi_api_key:
    external: true

```


# Configuration via environment variables

The available configuration variables are:

| Parameter | Function |
| :----: | --- |
| `-e DOMAIN=example.com`  | the main domain name register in Gandi.net |
| `-e SUBDOMAIN=subdomain` | the subdomain for which you want to update the ip |
| `-e APIKEY=YOURAPIKEY`   | your API key retrieved from Gandi.net |

As an alternative to passing sensitive information via environmental variables, _FILE may be appended to the listed variables,
causing the entrypoint.sh script to load the values for those values from files presented in the container. This is particular
usefull for loading passwords using the [Docker secrets](https://docs.docker.com/engine/swarm/secrets/) mechanism.


# Building the image 

Just type:

```
docker build -t anagno/gandi .
```
and you are ready.
