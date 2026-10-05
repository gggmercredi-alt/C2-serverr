FROM ubuntu:22.04
RUN apt-get update && apt-get install -y netcat-openbsd
EXPOSE 4444
CMD ["nc", "-lvnp", "4444"]
