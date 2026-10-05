FROM ubuntu:22.04

# Installer netcat et python3
RUN apt-get update && apt-get install -y netcat-openbsd python3

WORKDIR /app

# Créer un petit serveur HTTP (port 10000 pour Render health check)
RUN cat > /app/http_server.py << 'EOF'
import http.server
import socketserver

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'OK')

    def log_message(self, format, *args):
        pass  # Silence les logs

with socketserver.TCPServer(("", 10000), Handler) as httpd:
    httpd.serve_forever()
EOF

# Créer le script de démarrage
RUN cat > /app/start.sh << 'EOF'
#!/bin/bash
python3 /app/http_server.py &
nc -lvnp 4444
EOF

RUN chmod +x /app/start.sh

EXPOSE 10000 4444

CMD ["/app/start.sh"]
