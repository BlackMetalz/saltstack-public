# Guide for usage:
base:
# This means that any minion with a name matching the pattern kienlt-redis-sentinel-* will have the redis-sentinel state applied to it
  'kienlt-redis-sentinel-*':
    - redis-sentinel