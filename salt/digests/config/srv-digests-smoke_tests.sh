#!/bin/bash
. /opt/smoke.sh/smoke.sh

# lsh@2020-04: timeout should increase as the time to apply migrations increases
timeout=60 # seconds. default 30
docker-wait-healthy digests_wsgi_1 $timeout
smoke_url_ok localhost/ping
smoke_url_ok localhost/digests
cat /srv/digests/var/logs/uwsgi.log
smoke_report
