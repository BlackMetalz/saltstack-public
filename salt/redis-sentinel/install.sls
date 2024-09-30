{% set conf = salt['pillar.get']('redis-sentinel') %}

# Ensure vm.overcommit_memory is set to 1
set_vm_overcommit_memory:
  sysctl.present:
    - name: vm.overcommit_memory
    - value: 1

# Persist vm.overcommit_memory setting
persist_vm_overcommit_memory:
  file.append:
    - name: /etc/sysctl.conf
    - text:
      - vm.overcommit_memory = 1
      
# Ensure redis group exists
ensure_redis_group:
  group.present:
    - name: redis

# Ensure redis user exists
ensure_redis_user:
  user.present:
    - name: redis
    - gid: redis
    - createhome: False

# Create data directory
create_data_dir:
  file.directory:
    - name: {{ conf.dataDir }}
    - user: redis
    - group: redis
    - mode: 0755

# Create config directory
create_config_dir:
  file.directory:
    - name: {{ conf.configDir }}
    - user: redis
    - group: redis
    - mode: 0755

# Add redis signing key
add_redis_signing_key:
  cmd.run:
    - name: wget -qO - https://packages.redis.io/gpg | gpg --batch --yes --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
    - unless: test -f /usr/share/keyrings/redis-archive-keyring.gpg

# Add redis repo
add_redis_repo:
  pkgrepo.managed:
    - name: deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/redis.list
    - key_url: https://packages.redis.io/gpg

# Install specific version of redis-server, redis-sentinel, and redis-tools
install_redis_packages:
  pkg.installed:
    - pkgs:
      - redis-server={{ conf.redisVersion }}
      - redis-tools={{ conf.redisVersion }}
      - redis-sentinel={{ conf.redisVersion }}
    - refresh: True

# Install python3-pip for script notify
install_python3_pip:
  pkg.installed:
    - name: python3-pip
    - refresh: True

# Hold redis-server package
hold_redis_server:
  cmd.run:
    - name: apt-mark hold redis-server
    - unless: apt-mark showhold | grep -E '^redis-server$'
    - stateful: False

# Hold redis-tools package
hold_redis_tools:
  cmd.run:
    - name: apt-mark hold redis-tools
    - unless: apt-mark showhold | grep -E '^redis-tools$'
    - stateful: False

# Hold redis-sentinel package
hold_redis_sentinel:
  cmd.run:
    - name: apt-mark hold redis-sentinel
    - unless: apt-mark showhold | grep -E '^redis-sentinel$'
    - stateful: False

# Stop, disable service redis-server default
stop_disable_redis_server:
  service.dead:
    - name: redis-server
    - enable: False

# Stop, disable service redis-sentinel default
stop_disable_redis_sentinel:
  service.dead:
    - name: redis-sentinel
    - enable: False
