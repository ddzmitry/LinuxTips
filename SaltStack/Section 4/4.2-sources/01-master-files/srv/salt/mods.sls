{% for conf in ['status', 'info'] %}

mod_{{ conf }}:
  file.managed:
    - name: /etc/apache2/conf-available/mod_{{ conf }}.conf
    - contents: |
        <Location "/{{ conf }}">
            SetHandler server-{{ conf }}
        </Location>

  {% if salt.grains.get('os_family') == 'Debian' %}
  cmd.run:
    - name: a2enmod {{ conf }} && a2enconf mod_{{ conf }}
    - creates: /etc/apache2/conf-enabled/mod_{{ conf }}.conf
  {% endif %}

{% endfor %}
