call_execution_function:
  salt.function:
    - tgt: '*'
    - name: cmd.run
    - arg:
      - date

call_state_functions_one:
  salt.state:
    - tgt: 'jerry'
    - sls:
      - apache.welcome

call_state_functions_two:
  salt.state:
    - tgt: 'stuart'
    - sls:
      - apache.welcome
    - require:
      - salt: call_state_functions_one
