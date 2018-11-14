include:
  - apache

apache_stats:
  file.managed:
    - name: /etc/apache2/conf-enabled/modstats.conf
    - source: salt://modstats.conf.tmpl
    - require:
      - pkg: install_apache
    - require_in:
      - service: start_apache
