# [anagno/gandi-ddns](https://github.com/anagno/gandi-ddns)

This is a simple container for updating a single zone recond using the Gandi`s LiveDNS.

Live dns is available on www.gandi.net

Obtaining your API Key: http://doc.livedns.gandi.net/#step-1-get-your-api-key


## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=gandi-ddns \
  -e DOMAIN=example.com \
  -e SUBDOMAIN=subdomain \
  -e APIKEY=YOURAPIKEY
  anagno/gandi-ddns
```

### docker-compose

Compatible with docker-compose v3 schemas.

```
---
version: '3.4'
services:
  ddns:
    image: anagno/gandi-ddns:0.2
    environment:
      DOMAIN: "example.com"
      SUBDOMAIN: "subdomain"
      APIKEY: "YOURAPIKEY"
```


## Parameters

| Parameter | Function |
| :----: | --- |
| `-e DOMAIN=example.com`  | the main domain name register in Gandi.net |
| `-e SUBDOMAIN=subdomain` | the subdomain for which you want to update the ip |
| `-e APIKEY=YOURAPIKEY`   | your API key retrieved from Gandi.net |
