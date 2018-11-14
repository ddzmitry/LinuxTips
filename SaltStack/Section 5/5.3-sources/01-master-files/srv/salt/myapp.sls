{% from "apache/map.sls" import apache with context %}

include:
  - apache

myapp:
  git.latest:
    - name: https://github.com/saltstack/pepper.git
    - rev: master
    - force_reset: True
    - target: /var/www/myapp
    - watch_in:
      - service: start_apache

drain_apache:
  module.run:
    - name: service.stop
    - m_name: {{ apache.srv }}
    - prereq:
      - git: myapp

notify_of_fail:
  event.send:
    - name: myco/myapp/fail_deploy
    - onfail:
      - git: myapp
