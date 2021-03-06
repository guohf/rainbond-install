{% set PAUSEIMG = salt['pillar.get']('proxy:pause:image') -%}
{% set PAUSEVER = salt['pillar.get']('proxy:pause:version') -%}
{% set PUBDOMAIN = salt['pillar.get']('public-image-domain') -%}
{% set PRIDOMAIN = salt['pillar.get']('private-image-domain') -%}


k8s-custom-conf:
  file.managed:
    - source: salt://install/files/k8s/custom.conf
    - name: {{ pillar['rbd-path'] }}/etc/kubernetes/custom.conf
    - makedirs: True
    - template: jinja

kube-ssl-rsync:
  file.recurse:
    - source: salt://install/files/k8s/ssl
    - name: {{ pillar['rbd-path'] }}/etc/kubernetes/ssl

kube-cfg-rsync:
  file.recurse:
    - source: salt://install/files/k8s/kubecfg
    - name: {{ pillar['rbd-path'] }}/etc/kubernetes/kubecfg 


kubelet-cni:
  file.recurse:
    - source: salt://install/files/k8s/cni
    - name: {{ pillar['rbd-path'] }}/etc/cni/
    - template: jinja
    - makedirs: True

kubelet-cni-bin:
  file.recurse:
    - source: salt://install/files/misc/cni/bin
    - name: {{ pillar['rbd-path'] }}/bin
    - file_mode: '0755'
    - user: root
    - group: root
    - makedirs: True

/usr/local/bin/kubelet:
  file.managed:
    - source: salt://install/files/misc/bin/kubelet
    - mode: 755

pull-pause-img:
  cmd.run:
    - name: docker pull {{PRIDOMAIN}}/{{ PAUSEIMG }}:{{ PAUSEVER }}
    - unless: docker inspect {{PRIDOMAIN}}/{{ PAUSEIMG }}:{{ PAUSEVER }}