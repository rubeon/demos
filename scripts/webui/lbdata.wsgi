def application(environ, start_response):
    start_response('200 Ok', [('Content-type','application/json')])

    import os
    import pyrax
    import sys
    import time
    import json
    sys.path.append("/home/sri/demos/scripts/webui")
    import config
    output = []
    output.append(time.clock()*1000)

    try:
        pyrax.set_setting("identity_type", "rackspace")
        pyrax.set_credentials(config.cloud_user,config.cloud_api_key,region=config.cloud_region)
    except pyrax.exc.AuthenticationFailed:
        output.append(-1)

    clb = pyrax.cloud_loadbalancers
    if clb is None:
        output.append(-2)
    else:
        attempts = 5
        while True:
            if attempts == 0:
                output.append(-3)
                break
            try:
                for lb in clb.list():
                    if lb.name == config.cloud_lb_name:
                        mylb = clb.get(lb.id)
                        output.append(len(mylb.nodes))
                        break
            except (pyrax.exceptions.OverLimit,pyrax.exceptions.ClientException) as e:
                time.sleep(15)
                continue
                attempts = attempts - 1
            break
    return (json.dumps(output))

