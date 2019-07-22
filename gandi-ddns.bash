#!/bin/bash
set -o pipefail
# 
# Original script taken from: 
# https://github.com/Gandi/api-examples/blob/master/bash/livedns/mywanip.sh
# The original included also for IPV6, but I remove them for the moment
# 
# Dependencies: sudo apt-get install jq
#
# Updates a zone record using Gandi's LiveDNS.


# https://github.com/docker-library/postgres/blob/cf9b6cdd64f8a81b1abf9e487886f47e4971abe2/11/docker-entrypoint.sh
# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

file_env 'DOMAIN'

if [[ -z "$DOMAIN" ]]; then
    echo "[ERROR] Mandatory variable DOMAIN not defined."
    exit 1
fi

file_env 'SUBDOMAIN'

if [[ -z "$SUBDOMAIN" ]]; then
    echo "[ERROR] Mandatory variable SUBDOMAIN not defined."
    exit 1
fi

file_env 'APIKEY'

if [[ -z "$APIKEY" ]]; then
    echo "[ERROR] Mandatory variable APIKEY not defined."
    exit 1
fi

API="https://dns.api.gandi.net/api/v5/"
IP_SERVICE="http://me.gandi.net"

IP4=$(curl -s4 $IP_SERVICE)

if [[ -z "$IP4" ]]; then
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [ERROR] Retrieval of IP failed. Can not get your IP from $IP_SERVICE"
    exit 1
fi

if [[ ! -z "$IP4" ]]; then

    DNS_IP4=$(\
        curl -s4\
            -H"X-Api-Key: $APIKEY" \
            -H"Content-Type: application/json" \
            "$API/domains/$DOMAIN/records/$SUBDOMAIN" |
        jq -r '.[].rrset_values[0]')

    if [ "$IP4" != "$DNS_IP4" ]; then
        DATA='{"rrset_values": ["'$IP4'"]}'
        
        curl -s4 -o /dev/null -XPUT -d "$DATA" \
            -H"X-Api-Key: $APIKEY" \
            -H"Content-Type: application/json" \
            "$API/domains/$DOMAIN/records/$SUBDOMAIN/A"

        echo "$(date "+[%Y-%m-%d %H:%M:%S]") [INFO] Updated $SUBDOMAIN.$DOMAIN to $IP4 (previous value $DNS_IP4)."

    else
        echo "$(date "+[%Y-%m-%d %H:%M:%S]") [INFO] Current DNS A record for $SUBDOMAIN.$DOMAIN matches WAN IP ($IP4)."
	fi
fi

