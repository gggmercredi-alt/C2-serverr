FROM ubuntu:22.04
RUN apt-get update && apt-get install -y netcat-openbsd curl
EXPOSE 4444
RUN mkdir -p /app
WORKDIR /app
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
CMD ["/app/entrypoint.sh"]
