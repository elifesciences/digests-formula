digests:
    secret: fake_secret_do_not_use_in_prod
    logging:
        level: DEBUG
    sns:
        name: bus-digests
        subscriber: null
        region: us-east-1

elife:
    webserver:
        app: caddy
    db:
        app:
            name: digests
            username: foouser # case sensitive. use all lowercase
            password: barpass

    aws:
        access_key_id: AKIAFAKE
        secret_access_key: fake

    goaws:
        host: goaws
        topics:
            - digests--dev
