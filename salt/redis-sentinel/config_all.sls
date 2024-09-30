{% set conf = salt['pillar.get']('redis-sentinel') %}
{% set minion_id = salt['grains.get']('id') %}

{% for instance in conf['instances'] %}
{# This is section for config redis-server and it's related #}
{% if minion_id in conf['nodes'] %}
{# Ok Lets set some variable #}
{% set redisName = instance.redisPort ~ '-redis-' ~ instance.serviceName %} {# Example: 6801-redis-data-livechat #}
{% set redisConfigName = redisName ~ '.conf' %} {# Example: 6801-redis-data-livechat.conf #}
{% set redisConfigPath = conf.configDir ~ '/' ~ instance.redisPort ~ '-redis-' ~ instance.serviceName ~ '.conf' %}
{% set dbfilename =  instance.redisPort ~ '-redis-' ~ instance.serviceName ~ '.rdb' %}
{% set redisLog = '/var/log/redis/redis-server-' ~ instance.redisPort ~ '.log' %}

Update redis.conf for port {{ instance.redisPort }}:
  file.managed:
    - name: {{ redisConfigPath }}
    - source: salt://redis-sentinel/templates/redis.conf.j2
    - user: redis
    - group: redis
    - mode: 0644
    - template: jinja
    - context:
      conf: {{ conf }}
      instance: {{ instance }}
      dbfilename: {{ dbfilename }}
      redisLog: {{ redisLog }}

Update redis service for port {{ instance.redisPort }}:
  file.managed:
    - name: /lib/systemd/system/redis-server-{{ instance.redisPort }}.service
    - source: salt://redis-sentinel/templates/redis-server.service.j2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - context:
      conf: {{ conf }}
      instance: {{ instance }}
      redisConfigPath: {{ redisConfigPath }}

Reload, enable port {{ instance.redisPort }}:
  cmd.run:
    - names:
      - systemctl daemon-reload
    - onchanges:
      - file: /lib/systemd/system/redis-server-{{ instance.redisPort }}.service


Enable and Start service redis-server-{{ instance.redisPort }}:
  service.running:
    - name: redis-server-{{ instance.redisPort }}.service
    - enable: True

wait for redis-server-{{ instance.redisPort }}:
  cmd.run:
    - name: until nc -z localhost {{ instance.redisPort }}; do sleep 1; done
    - timeout: 30

{# Redis Exporter #}
download_redis_exporter {{ instance.redisPort }}:
  file.managed:
    - name: /tmp/redis_exporter-v{{ instance.exporterVersion }}.linux-amd64.tar.gz
    - source: https://github.com/oliver006/redis_exporter/releases/download/v{{ instance.exporterVersion }}/redis_exporter-v{{ instance.exporterVersion }}.linux-amd64.tar.gz
    - makedirs: True
    - skip_verify: True

extract_redis_exporter {{ instance.redisPort }}:
  archive.extracted:
    - name: /tmp/
    - source: /tmp/redis_exporter-v{{ instance.exporterVersion }}.linux-amd64.tar.gz
    - archive_format: tar
    - tar_options: z
    - creates: /tmp/redis_exporter-v{{ instance.exporterVersion }}.linux-amd64/redis_exporter

move_redis_exporter_binary {{ instance.redisPort }}:
  cmd.run:
    - name: mv /tmp/redis_exporter-v{{ instance.exporterVersion }}.linux-amd64/redis_exporter /usr/local/bin/redis_exporter
    - creates: /usr/local/bin/redis_exporter

Config exporter for redis port {{ instance.redisPort }}:
  file.managed:
    - name: /etc/systemd/system/redis-exporter-{{ instance.redisPort }}.service
    - source: salt://redis-sentinel/templates/redis_exporter.service.j2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - context:
      instance: {{ instance }}

Reload, enable redis-exporter service for port {{ instance.exporterPort }}:
  cmd.run:
    - names:
      - systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/redis-exporter-{{ instance.redisPort }}.service

Enable and Start service redis-exporter-{{ instance.redisPort }}:
  service.running:
    - name: redis-exporter-{{ instance.redisPort }}.service
    - enable: True

wait for redis-exporter-{{ instance.exporterPort }}:
  cmd.run:
    - name: until nc -z localhost {{ instance.exporterPort }}; do sleep 1; done
    - timeout: 10

{% endif %}
{# End of section for redis-server and it's related #}

{# This is section for config redis-sentinel and it's related #}
{% set sentinelName = instance.sentinelPort ~ '-sentinel-' ~ instance.serviceName %}
{% set sentinelConfigName = sentinelName ~ '.conf' %}
{% set sentinelConfigPath = conf.configDir ~ '/' ~ instance.sentinelPort ~ '-sentinel-' ~ instance.serviceName ~ '.conf'  %}
{% set sentinelLog = '/var/log/redis/' ~  sentinelName ~ '.log' %}


Update Sentinel confif {{ sentinelConfigPath }}:
  file.managed:
    - name: {{ sentinelConfigPath }}
    - source: salt://redis-sentinel/templates/sentinel.conf.j2
    - user: redis
    - group: redis
    - mode: 0644
    - template: jinja
    - context:
      instance: {{ instance }}
      conf: {{ conf }}
      sentinelName: {{ sentinelName }}
      sentinelLog: {{ sentinelLog }}


Render redis sentinel template service for {{ sentinelName }}:
  file.managed:
    - name: /lib/systemd/system/redis-sentinel-{{ instance.sentinelPort }}.service
    - source: salt://redis-sentinel/templates/redis-sentinel.service.j2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - context:
      instance: {{ instance }}
      conf: {{ conf }}
      sentinelName: {{ sentinelName }}
      sentinelConfigPath: {{ sentinelConfigPath }}

Reload, enable redis-sentinel service for port {{ instance.sentinelPort }}:
  cmd.run:
    - names:
      - systemctl daemon-reload
    - onchanges:
      - file: /lib/systemd/system/redis-sentinel-{{ instance.sentinelPort }}.service


Enable and Start Redis Sentinel for port {{ instance.sentinelPort }}:
  service.running:
    - name: redis-sentinel-{{ instance.sentinelPort }}
    - enable: True


wait for port of redis-sentinel-{{ instance.sentinelPort }}:
  cmd.run:
    - name: until nc -z localhost {{ instance.sentinelPort }}; do sleep 1; done
    - timeout: 10
{# End of section for config redis-sentinel and it's related #}
{% endfor %}
