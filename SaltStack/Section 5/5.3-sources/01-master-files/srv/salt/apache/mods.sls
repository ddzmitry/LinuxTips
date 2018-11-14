include:
  - apache

{% for conf in ['status', 'info'] %}

mod_{{ conf }}:
  file.managed:
    - name: /etc/apache2/conf-available/mod_{{ conf }}.conf
    - contents: |
        <Location "/{{ conf }}">
            SetHandler server-{{ conf }}

        </Location>
    - watch_in:
      - service: start_apache

  {% if salt.grains.get('os_family') == 'Debian' %}
  cmd.run:
    - name: a2enmod {{ conf }} && a2enconf mod_{{ conf }}
    - onchanges:
      - file: mod_{{ conf }}
    - watch_in:
      - service: start_apache
  {% endif %}

{% endfor %}
