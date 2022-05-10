import os
import redis

redishost = os.environ.get("REDISHOST", "localhost")
redisport = os.environ.get("REDISPORT", "6379")
redispassword = os.environ.get("REDISPASSWORD", "password")
#r = redis.StrictRedis(host='redis-14897.c280.us-central1-2.gce.cloud.redislabs.com', port=14897, password='SceKGdmO9JwoDuUmEBv6QEWV6do5ADp2', db=0)
r =  redis.StrictRedis(host=redishost, port=redisport, password=redispassword, db=0)
r.set('rolex','daytona-gold')

