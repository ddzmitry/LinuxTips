{% set apache = salt.grains.filter_by({
    'Debian': {
       'pkg': 'apache2',
       'srv': 'apache2',
    },
    'RedHat': {
       'pkg': 'httpd',
       'srv': 'httpd',
    },
}) %}
