#!/usr/bin/env bash
psql -U postgres -c "CREATE USER $DB_USER PASSWORD '$DB_PASS'"
psql -U postgres -c "CREATE DATABASE $DB_NAME OWNER $DB_USER'"

touch ./logs/gunicorn.log
touch ./logs/gunicorn-access.log
#tail -n 0 -f ./logs/gunicorn*.log &
tail: gunicorn projectx.wsgi:application \
    --name projectx_django \
    --bind 0.0.0.0:8000 \
    --workers 5 \
    --log-level=info \
    --log-file=./logs/gunicorn.log \
    --access-logfile=./logs/gunicorn-access.log \
"$@"
export DJANGO_SETTINGS_MODULE=projectx.settings