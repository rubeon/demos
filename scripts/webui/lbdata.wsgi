def application(environ, start_response):
    start_response('200 Ok', [('Content-type','text/plain')])

    output = 0

    import os
    import pyrax

    cloud_user = os.environ['OS_USERNAME']
    cloud_api_key = os.environ['OS_PASSWORD']
    cloud_region = os.environ['OS_REGION_NAME'].upper()
    cloud_tenant = os.environ['OS_TENANT_NAME']

    pyrax.set_setting("identity_type", "rackspace")
    pyrax.set_setting("region", cloud_region)
    try:
        pyrax.set_credentials(cloud_user,
                          cloud_api_key,
                          region=cloud_region)
    except exc.AuthenticationFailed:
        output=0

    clb = pyrax.cloud_loadbalancers
    if clb is None:
        output = 0
    else:
        attempts = 5
        while True:
            if attempts == 0:
                output = 0
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
