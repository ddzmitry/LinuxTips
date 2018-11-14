#!py

def run():
    return {
        'install_apache': {
            'pkg.installed': [
                {'name': 'apache2'},
            ],
        },
        'start_apache': {
            'service.running': [
                {'name': 'apache2'},
                {'enable': True},
            ],
        },
        'welcome_page': {
            'file.managed': [
                {'name': '/var/www/html/index.html'},
                {'contents': '<!doctype html>\n<body>\n    <h1>Hello, world?</h1>\n</body>'},
            ],
        },
    }
