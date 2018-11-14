install_apache:
  pkg.installed:
    {% if salt.grains.get('os_family') == 'Debian' %}
    - name: apache2
    {% elif salt.grains.get('os_family') == 'RedHat' %}
    - name: httpd
    {% endif %}

start_apache:
  service.running:
    {% if salt.grains.get('os_family') == 'Debian' %}
    - name: apache2
    {% elif salt.grains.get('os_family') == 'RedHat' %}
    - name: httpd
    {% endif %}
    - enable: True

welcome_page:
  file.managed:
    - name: /var/www/html/index.html
    - contents: |
        <!doctype html>
        <body>
            <h1>Hello, world?</h1>
        </body>
