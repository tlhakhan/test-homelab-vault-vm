FROM debian:bullseye

RUN apt-get update && apt-get install -y curl jq

RUN mkdir -p /vault/keys
WORKDIR /vault
COPY key_shares.json vault_init.sh .
CMD ["/vault/vault_init.sh"]
