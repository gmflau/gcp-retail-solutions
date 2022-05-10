import os
import redis

redishost = os.environ.get("REDISHOST", "localhost")
redisport = os.environ.get("REDISPORT", "6379")
redispassword = os.environ.get("REDISPASSWORD", "password")
r =  redis.StrictRedis(host=redishost, port=redisport, password=redispassword, db=0)
r.set('rolex','daytona-gold')

