FROM alpine:3.8

LABEL maintainer="Vasileios Anagnostopoulos <info@anagno.me>"
LABEL description="A simple image to update your dynamic ip using the gandi API"

RUN apk add --no-cache curl jq bash
COPY gandi-ddns.bash /etc/periodic/15min/gandi-ddns
RUN chmod -R a+x /etc/periodic/15min/gandi-ddns
CMD [ "crond", "-l", "8", "-f" ]


# References:
# * https://wiki.alpinelinux.org/wiki/Alpine_Linux:FAQ#Using_a_cron_job_to_keep_the_time_in_sync
# * https://gist.github.com/AntonFriberg/692eb1a95d61aa001dbb4ab5ce00d291
