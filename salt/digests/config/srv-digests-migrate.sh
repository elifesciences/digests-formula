#!/usr/bin/env bash
set -ex

source venv/bin/activate

#until echo > /dev/tcp/$POSTGRES_HOST/5432; do sleep 1; done
until python app/manage.py inspectdb; do sleep 1; done

python app/manage.py migrate

echo "migrate.sh done"
