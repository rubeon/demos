def application(environ, start_response):
    start_response('200 Ok', [('Content-type','text/plain')])

    import os
    import pyrax
    import sys
    sys.path.append("/home/sri/demos/scripts/webui")
    import config
    output = "-1"

    try:
        pyrax.set_setting("identity_type", "rackspace")
        pyrax.set_credentials(config.cloud_user,config.cloud_api_key,region=config.cloud_region)
    except pyrax.exc.AuthenticationFailed:
        output="-2"

    clb = pyrax.cloud_loadbalancers
    if clb is None:
        output = "-3"
    else:
        attempts = 5
        while True:
            if attempts == 0:
                output = "-4"
                break
            try:
                for lb in clb.list():
                    if lb.name == "one.example.com":
                        mylb = clb.get(lb.id)
                        output = str(len(mylb.nodes))
                        break
            except (pyrax.exceptions.OverLimit,pyrax.exceptions.ClientException) as e:
                time.sleep(15)
                continue
                attempts = attempts - 1
            break
    return (output)

