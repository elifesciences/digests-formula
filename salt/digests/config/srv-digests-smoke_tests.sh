#!/bin/bash
. /opt/smoke.sh/smoke.sh

docker-wait-healthy digests_wsgi_1

docker logs $(docker ps | grep wsgi | cut -d " " -f1)

smoke_url_ok localhost/ping
smoke_url_ok localhost/digests
smoke_report
