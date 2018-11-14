{% set lookup = {
    'jerry': "Jerry's World",
    'stuart': "Stuart's World",
} %}
{% set name = lookup[grains.id] %}

name: {{ name | json() }}
