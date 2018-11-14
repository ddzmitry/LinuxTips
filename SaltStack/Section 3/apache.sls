install_apache:
  pkg.installed:
    - name: apache2

start_apache:
  service.running:
    - name: apache2
    - enable: True
