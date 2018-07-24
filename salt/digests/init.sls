digests-folder:
    file.directory:
        - name: /srv/digests
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}

digests-logs:
    file.directory:
        - name: /srv/digests/var/logs/
        - user: {{ pillar.elife.webserver.username }}
        - group: {{ pillar.elife.webserver.username }}
        - makedirs: True
        - dir_mode: 775
        - require:
            - digests-folder

digests-app-config:
    file.managed:
        - name: /srv/digests/app.cfg
        - source: salt://digests/config/srv-digests-app.cfg
        - template: jinja
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}
        - require: 
            - digests-folder
            - digests-logs

digests-uwsgi-config:
    file.managed:
        - name: /srv/digests/uwsgi.ini
        - source: salt://digests/config/srv-digests-uwsgi.ini
        - template: jinja
        - require:
            - digests-folder

digests-nginx-vhost:
    file.managed:
        - name: /etc/nginx/sites-enabled/digests.conf
        - source: salt://digests/config/etc-nginx-sites-enabled-digests.conf
        - template: jinja
        - require:
            - nginx-config
        - listen_in:
            - service: nginx-server-service

digests-syslog-ng:
    file.managed:
        - name: /etc/syslog-ng/conf.d/digests.conf
        - source: salt://digests/config/etc-syslog-ng-conf.d-digests.conf
        - template: jinja
        - require:
            - pkg: syslog-ng
            - digests-logs
        - listen_in:
            - service: syslog-ng

digests-logrotate:
    file.managed:
        - name: /etc/logrotate.d/digests
        - source: salt://digests/config/etc-logrotate.d-digests
        - template: jinja
        - require:
            - digests-logs

digests-docker-compose-folder:
    file.directory:
        - name: /home/{{ pillar.elife.deploy_user.username }}/digests/
        - user: {{ pillar.elife.deploy_user.username }}
        - require:
            - deploy-user

# variable for docker-compose
digests-docker-compose-.env:
    file.managed:
        - name: /home/{{ pillar.elife.deploy_user.username }}/digests/.env
        - source: salt://digests/config/home-deployuser-digests-.env
        - makedirs: True
        - template: jinja
        - require:
            - digests-docker-compose-folder

# variables for the containers
digests-containers-env:
    file.managed:
        - name: /home/{{ pillar.elife.deploy_user.username }}/digests/containers.env
        - source: salt://digests/config/home-deployuser-digests-containers.env
        - template: jinja
        - require:
            - digests-docker-compose-folder

digests-docker-compose-yml:
    file.managed:
        - name: /home/{{ pillar.elife.deploy_user.username }}/digests/docker-compose.yml
        - source: salt://digests/config/home-deployuser-digests-docker-compose.yml
        - template: jinja
        - require:
            - digests-docker-compose-folder

digests-docker-containers:
    cmd.run:
        - name: /usr/local/bin/docker-compose pull && /usr/local/bin/docker-compose up --force-recreate -d
        - user: {{ pillar.elife.deploy_user.username }}
        - cwd: /home/{{ pillar.elife.deploy_user.username }}/digests
        - require:
            - digests-docker-compose-.env
            - digests-containers-env
            - digests-docker-compose-yml

integration-smoke-tests:
    file.managed:
        - name: /srv/digests/smoke_tests.sh
        - source: salt://digests/config/srv-digests-smoke_tests.sh
        - template: jinja
        - user: {{ pillar.elife.deploy_user.username }}
        - mode: 755
        - require: 
            - digests-folder
