### Salt master example config
```
worker_threads: 10
file_roots:
  base:
    - /srv/saltstack/salt/
pillar_roots:
  base:
    - /srv/saltstack/pillar
```

### How to use state
- in `README.md` of any salt state.