{# Template used all in salt://redis-sentinel/templates/monitor/... #}
{% set conf = salt['pillar.get']('redis-sentinel') %}
{% set minion_id = salt['grains.get']('id') %}

{# This is section for config redis monitor and it's related #}
{% if minion_id in conf['sentinels'] %}
Add mk_redis plugin:
  file.managed:
    - name: /usr/lib/check_mk_agent/plugins/mk_redis
    - source: salt://redis-sentinel/files/mk_redis
    - user: root
    - mode: 0755

Generate redis monitor config:
  file.managed:
    - name: /etc/check_mk/mk_redis.cfg
    - source: salt://redis-sentinel/templates/monitor/mk_redis.cfg.j2
    - template: jinja
    - context:
      redis_sentinel: {{ conf }}
{% endif %}


{% if minion_id in conf['nodes'] %}

install_redis_packages:
  pkg.installed:
    - pkgs:
      - monitoring-plugins-basic

Install checklog plugin:
  file.managed:
    - name: /usr/lib/nagios/plugins/check_log3.pl
    - source: salt://redis-sentinel/files/check_log3.pl
    - user: root
    - mode: 0755

install redis pip for monitor script:
  pip.installed:
    - name: redis
    - bin_env: /usr/bin/pip3

Genarate auth file:
  file.managed:
    - name: /opt/redis-auth.json
    - source: salt://redis-sentinel/templates/monitor/redis_auth.j2
    - user: root
    - mode: 0600 # For security xD
    - template: jinja
    - context:
      ins_conf: {{ conf.instances }}

Copy script check:
  file.managed:
    - name: /opt/redis-check.py
    - source: salt://redis-sentinel/files/redis_check.py
    - user: root
    - mode: 0755

Create entry mrpe:
  file.managed:
    - name: /etc/check_mk/mrpe.cfg
    - makedirs: True
    - source: salt://redis-sentinel/templates/monitor/mrpe.cfg.j2
    - template: jinja
    - context:
      ins_conf: {{ conf.instances }}
{# End of section for redis monitor and it's related #}
{% endif %}
