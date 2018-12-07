#!py

{'install_apache': {'pkg.installed': [{'name': 'httpd'}]},
 'start_apache': {'service.running': [{'name': 'httpd'}, {'enable': True}]},
 'welcome_page': {'file.managed': [{'name': '/var/www/html/index.html'},
                                   {'contents': '<!doctype html>\n<body> <h1>Yo</h1> </body>'}]}}