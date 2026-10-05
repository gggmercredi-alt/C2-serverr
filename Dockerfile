FROM ubuntu:22.04

RUN apt-get update && apt-get install -y netcat-openbsd socat

WORKDIR /app

# Créer script de démarrage
RUN cat > /app/start.sh << 'EOF'
#!/bin/bash
# Lancer netcat sur localhost:4444
nc -lvnp 4444 &
NC_PID=$!

# Lancer socat: écoute HTTP 10000, tunnel vers TCP localhost:4444
socat -v TCP-LISTEN:10000,reuseaddr,fork TCP:127.0.0.1:4444

wait $NC_PID
EOF

RUN chmod +x /app/start.sh

EXPOSE 10000 4444

CMD ["/app/start.sh"]
