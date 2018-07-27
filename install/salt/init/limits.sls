/etc/security/limits.conf:
  file.append:
    - text:
      - "root soft nofile 102400"
      - "root hard nofile 102400"
      - "* soft nofile 102400"
      - "* hard nofile 102400"
      - "* soft memlock unlimited"
      - "* hard memlock unlimited"
      - "* soft nproc 2048"
      - "* hard nproc 4096"

vm.max_map_count:
  sysctl.present:
    - value: 262144

vm.swappiness:
  sysctl.present:
    - value: 10

vm.vfs_cache_pressure:
  sysctl.present:
    - value: 50

vm.overcommit_memory:
  sysctl.present:
    - value: 1

sunrpc.tcp_slot_table_entries:
  sysctl.present:
    - value: 128



net.ipv4.ip_forward:
  sysctl.present:
    - value: 1