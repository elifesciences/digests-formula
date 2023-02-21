#!/bin/bash
. /opt/smoke.sh/smoke.sh

# lsh@2023-02-20: bug causes first attempt to fail (???):
# - https://github.com/asm89/smoke.sh/issues/11
((SMOKE_TESTS_RUN++))

# lsh@2023-02-20: issue #8017, prod-digests job is failing smoke tests too quickly. function copied from:
# - https://github.com/fernandoacorreia/azure-docker-registry/blob/14c45b7f3daae23ae28259eda0f5e7d4872ea881/tools/scripts/create-registry-server#L16-L31
function retry {
    local n=1
    local max=5
    local delay=5
    while true; do
        "$@" && break || {
            if [[ $n -lt $max ]]; then
                ((n++))
                echo "Command failed. Attempt $n/$max:"
                sleep $delay;
            else
                fail "The command has failed after $n attempts."
            fi
        }
    done
}

# lsh@2020-04: timeout should increase as the time to apply migrations increases
timeout=60 # seconds. default 30
docker-wait-healthy digests_wsgi_1 $timeout
retry smoke_url_ok localhost/ping
retry smoke_url_ok localhost/digests
smoke_report
