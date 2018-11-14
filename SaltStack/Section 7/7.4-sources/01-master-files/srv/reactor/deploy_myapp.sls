{% if data.get('post', {}).get('shared_secret') == '1234' %}

deploy_myapp:
  cmd.state.sls:
    - tgt: {{ data.id }}
    - kwarg:
        mods: myapp
        pillar:
          version: {{ data.data.version }}

{% endif %}
