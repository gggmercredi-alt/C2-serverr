FROM ubuntu:22.04

RUN apt-get update && apt-get install -y netcat-openbsd socat python3

WORKDIR /app

# Script de démarrage corrigé
RUN cat > /app/start.sh << 'EOF'
#!/bin/bash

# Lancer netcat en background
echo "Starting netcat..."
nc -lvnp 4444 &
NC_PID=$!

# Attendre que netcat soit prêt (2 secondes)
sleep 2

echo "Starting socat tunnel..."
# Lancer socat: écoute port 10000, tunnel vers 127.0.0.1:4444
socat TCP-LISTEN:10000,reuseaddr,fork TCP:127.0.0.1:4444

wait $NC_PID
EOF

RUN chmod +x /app/start.sh

EXPOSE 10000 4444

CMD ["/app/start.sh"]
