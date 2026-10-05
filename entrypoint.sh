#!/bin/bash
# Lancer netcat en arrière-plan
nc -lvnp 4444 &

# Garder le conteneur vivant
while true; do
  sleep 3600
done
