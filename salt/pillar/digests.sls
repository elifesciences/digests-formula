digests:
    secret: fake_secret_do_not_use_in_prod
    logging:
        level: DEBUG
    sns:
        name: bus-digests
        subscriber: null
        region: us-east-1
        # TODO: add optional goaws endpoint_url

elife:
    db:
        app:
            name: digests
            # non-super-user used to connect to db for regular operation
            username: foouser # case sensitive. use all lowercase
            password: barpass

    aws:
        access_key_id: AKIAFAKE
        secret_access_key: fake

    goaws:
        host: goaws
        topics:
            - digests--dev

    docker_postgresql:
        image_tag: 11
