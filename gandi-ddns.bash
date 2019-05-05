#!/bin/bash
# 
# Original script taken from: 
# https://github.com/Gandi/api-examples/blob/master/bash/livedns/mywanip.sh
# The original included also for IPV6, but I remove them for the moment
# 
# Dependencies: sudo apt-get install jq
#
# Updates a zone record using Gandi's LiveDNS.


if [[ -z "$DOMAIN" ]]; then
    echo "[ERROR] Mandatory variable DOMAIN not defined."
    exit 1
fi

if [[ -z "$SUBDOMAIN" ]]; then
    echo "[ERROR] Mandatory variable SUBDOMAIN not defined."
    exit 1
fi

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

