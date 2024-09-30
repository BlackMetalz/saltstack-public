# Guide:
# This means that minions with names matching kienlt-redis-sentinel-dev-* will have the redis-sentinel.dev pillar data, 
# and those matching kienlt-redis-sentinel-prod-* will have the redis-sentinel.prod pillar data.
base:
  'kienlt-redis-sentinel-dev-*':
    - redis-sentinel.dev
  'kienlt-redis-sentinel-prod-*':
    - redis-sentinel.prod