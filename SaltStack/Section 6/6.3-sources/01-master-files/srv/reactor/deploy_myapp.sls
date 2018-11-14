deploy_myapp:
  cmd.state.sls:
    - tgt: {{ data.id }}
    - kwarg:
        mods: myapp
        pillar:
          version: {{ data.data.version }}
