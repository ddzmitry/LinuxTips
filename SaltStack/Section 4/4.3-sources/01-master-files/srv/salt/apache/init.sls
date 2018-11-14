# Manage Apache.

{% from "apache/map.sls" import apache with context %}

install_apache:
  pkg.installed:
    - name: {{ apache.pkg }}

start_apache:
  service.running:
    - name: {{ apache.pkg }}

    # Explicitly enable to start on boot because we need to manage CentOS as well.
    - enable: True
