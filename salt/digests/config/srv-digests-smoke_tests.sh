#!/bin/bash
. /opt/smoke.sh/smoke.sh

docker-wait-healthy digests_wsgi_1
smoke_url_ok localhost/ping
smoke_url_ok localhost/digests
smoke_report
