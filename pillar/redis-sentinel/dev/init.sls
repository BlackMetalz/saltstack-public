{# redisName: "{{ port }}-redis-{{ config.serviceName }}" #}
{# redisConfigName: "{{ port }}-redis-{{ config.serviceName }}.conf" #}
{# redisConfigPath: "{{ configDir }}/{{ port }}-redis-{{ config.serviceName }}.conf" #}
{# dbfilename: "{{ port }}-redis-{{ config.serviceName }}.rdb" #}
{# sentinelName: "{{ config.sentinelPort }}-sentinel-{{ config.serviceName }}" #}
{# sentinelConfigName: "{{ config.sentinelPort }}-sentinel-{{ config.serviceName }}.conf" #}
{# sentinelConfigPath: "{{ configDir }}/{{ config.sentinelPort }}-sentinel-{{ config.serviceName }}.conf" #}
{# sentinelLog: /var/log/redis/{{ config.sentinelPort }}-sentinel-{{ config.serviceName }}.log #}

redis-sentinel:
  # General config
  configDir: "/data/redis-config"
  dataDir: "/data/redis-data"
  redisVersion: "6:6.2.14-1rl1~jammy1" # Fixed for Ubuntu 22.04
  # Sentinel config
  failoverTimeout: 30000
  down_after_milliseconds: 5000
  # Define which node will config redis-server ( 2 in 3 total nodes)
  nodes:
  - kienlt-redis-sentinel-dev-c1-1-10
  - kienlt-redis-sentinel-dev-c1-1-20
  # Specific port config here, each port will be named as port_portNumber
  sentinels:
  - kienlt-redis-sentinel-dev-c1-1-10
  - kienlt-redis-sentinel-dev-c1-1-20
  - kienlt-redis-sentinel-dev-c1-1-30
  instances:
    - redisPort: 6800
      redis_password: 'pass_here'
      serviceName: 'service-name-1'
      masterHost: '10.0.1.10'
      masterUser: 'masterUser'
      maxMemory: '2gb'
      maxMemoryPolicy: 'allkeys-lru'
      sentinelPort: 8800
      exporterVersion: '1.62.0'
      exporterPort: 9800
      # Define which is master in pillar for the first time
      {% if grains['id'] == 'kienlt-redis-sentinel-dev-c1-1-20' %}
      isSlave: True
      role: slave
      {% else %}
      role: master
      {% endif %}

    - redisPort: 6801
      redis_password: 'pass_here'
      serviceName: 'service-name-2'
      masterHost: '10.0.1.10'
      masterUser: 'masterUser'
      maxMemory: '2gb'
      maxMemoryPolicy: 'allkeys-lru'
      sentinelPort: 8801
      exporterVersion: '1.62.0'
      exporterPort: 9801
      # Define which is master in pillar for the first time
      {% if grains['id'] == 'kienlt-redis-sentinel-dev-c1-1-20' %}
      role: master
      {% else %}
      isSlave: True
      role: slave
      {% endif %}

    - redisPort: 6802
      redis_password: 'pass_here'
      serviceName: 'service-name-3'
      masterHost: '10.0.1.10'
      masterUser: 'masterUser'
      maxMemory: '1gb'
      maxMemoryPolicy: 'allkeys-lru'
      sentinelPort: 8802
      exporterVersion: '1.62.0'
      exporterPort: 9802
      # Define which is master in pillar for the first time
      {% if grains['id'] == 'kienlt-redis-sentinel-dev-c1-1-20' %}
      role: master
      {% else %}
      isSlave: True
      role: slave
      {% endif %}

    - redisPort: 6803
      redis_password: 'pass_here'
      serviceName: 'service-name-4'
      masterHost: '10.0.1.10'
      masterUser: 'masterUser'
      maxMemory: '1gb'
      maxMemoryPolicy: 'allkeys-lru'
      sentinelPort: 8803
      exporterVersion: '1.62.0'
      exporterPort: 9803
      # Define which is master in pillar for the first time
      {% if grains['id'] == 'kienlt-redis-sentinel-dev-c1-1-20' %}
      role: master
      {% else %}
      isSlave: True
      role: slave
      {% endif %}

    - redisPort: 6804
      redis_password: 'pass_here'
      serviceName: 'service-name-5'
      masterHost: '10.0.1.10'
      masterUser: 'masterUser'
      maxMemory: '1gb'
      maxMemoryPolicy: 'allkeys-lru'
      sentinelPort: 8804
      exporterVersion: '1.62.0'
      exporterPort: 9804
      # Define which is master in pillar for the first time
      {% if grains['id'] == 'kienlt-redis-sentinel-dev-c1-1-20' %}
      role: master
      {% else %}
      isSlave: True
      role: slave
      {% endif %}

    - redisPort: 6805
      redis_password: 'pass_here'
      serviceName: 'service-name-6'
      masterHost: '10.0.1.10'
      masterUser: 'masterUser'
      maxMemory: '1gb'
      maxMemoryPolicy: 'allkeys-lru'
      sentinelPort: 8805
      exporterVersion: '1.62.0'
      exporterPort: 9805
      # Define which is master in pillar for the first time
      {% if grains['id'] == 'kienlt-redis-sentinel-dev-c1-1-20' %}
      role: master
      {% else %}
      isSlave: True
      role: slave
      {% endif %}

    - redisPort: 6806
      redis_password: 'pass_here'
      serviceName: 'service-name-7'
      masterHost: '10.0.1.10'
      masterUser: 'masterUser'
      maxMemory: '2gb'
      maxMemoryPolicy: 'allkeys-lru'
      sentinelPort: 8806
      exporterVersion: '1.62.0'
      exporterPort: 9806
      # Define which is master in pillar for the first time
      {% if grains['id'] == 'kienlt-redis-sentinel-dev-c1-1-20' %}
      role: master
      {% else %}
      isSlave: True
      role: slave
      {% endif %}

    - redisPort: 6807
      redis_password: 'pass_here'
      serviceName: 'service-name-8'
      masterHost: '10.0.1.10'
      masterUser: 'masterUser'
      maxMemory: '2gb'
      maxMemoryPolicy: 'allkeys-lru'
      sentinelPort: 8807
      exporterVersion: '1.62.0'
      exporterPort: 9807
      # Define which is master in pillar for the first time
      {% if grains['id'] == 'kienlt-redis-sentinel-dev-c1-1-20' %}
      role: master
      {% else %}
      isSlave: True
      role: slave
      {% endif %}