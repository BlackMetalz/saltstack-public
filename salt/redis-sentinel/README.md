# For deploy redis server/sentinel in same server with multi instances

### Install requirements first:
```
salt kienlt-redis-test-* state.apply redis-sentinel.install
```

### For all instances defined in pillar
```
salt kienlt-redis-test-* state.apply redis-sentinel.config_all
```

### For only 1 redis instance in pillar defined by port
```
salt kienlt-redis-test-* state.apply redis-sentinel.config_single pillar='{"redis": {"port": 6800}}'
```
- Don't forget to run: `salt kienlt-redis-test-* state.apply redis-sentinel.cmk_monitor` for auto add monitor memory and sentinel promote


### For all in one.
```
salt kienlt-redis-test-* state.apply redis-sentinel.all
```