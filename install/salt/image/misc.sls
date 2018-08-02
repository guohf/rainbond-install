{% if "manage" in grains['id'] %}
{% if grains['id'] == 'manage01' %}
{% set sslpath = "/srv/salt/install/files/ssl/region.goodrain.me" %}
region-ssl-ca:
  cmd.run:
    - name: grcert create --is-ca --ca-name={{ sslpath }}/ca.pem --ca-key-name={{ sslpath }}/ca.key.pem
    - unless: ls -l {{ sslpath }}/ca.pem

region-server-ssl:
  cmd.run:
    - name: grcert create --is-ca --ca-name={{ sslpath }}/ca.pem --ca-key-name={{ sslpath }}/ca.key.pem --crt-name={{ sslpath }}/server.pem --crt-key-name={{ sslpath }}/server.key.pem --address=pillar['vip']
    - unless: ls -l {{ sslpath }}/server.pem

region-client-ssl:
  cmd.run:
    - name: grcert create --is-ca --ca-name={{ sslpath }}/ca.pem --ca-key-name={{ sslpath }}/ca.key.pem --crt-name={{ sslpath }}/client.pem --crt-key-name={{ sslpath }}/client.key.pem
    - unless: ls -l {{ sslpath }}/client.pem
{% endif %}

rsync-region-ssl:
  file.recurse:
    - source: salt://install/files/ssl/region.goodain.me
    - name: {{ pillar['rbd-path'] }}/etc/rbd-api/region.goodrain.me/ssl
    - makedirs: True

config-grctl-yaml:
  file.managed:
    - source: salt://install/files/grctl/config.yaml
    - name: /root/.rbd/grctl.yaml
    - makedirs: True
    - template: jinja
{% endif %}