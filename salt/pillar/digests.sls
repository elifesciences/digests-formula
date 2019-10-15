digests:
    secret: fake_secret_do_not_use_in_prod
    db:
        name: digests
        username: foouser # case sensitive. use all lowercase
        password: barpass
        host: 127.0.0.1
        port: 5432
    logging:
        level: DEBUG
    sns:
        name: bus-digests
        subscriber: null
        region: us-east-1
        # TODO: add optional goaws endpoint_url

elife:
    aws:
        access_key_id: AKIAFAKE
        secret_access_key: fake

    goaws:
        host: goaws
        topics:
            - digests--dev

    docker_postgresql:
        image_tag: 11
