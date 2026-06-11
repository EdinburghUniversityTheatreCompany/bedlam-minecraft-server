FROM alpine:latest
SHELL ["sh", "-c"]

RUN apk update && apk add openssh-server-pam rcon-cli
RUN mkdir /opt/ssh
WORKDIR /opt/ssh

VOLUME /home/minecraft
RUN addgroup -g 966 minecraft && adduser -D -u 1966 -G minecraft minecraft

EXPOSE 22

ENV RCON_PASS="password"
ENV RCON_PORT="25575"
ENV RCON_HOST="minecraft"
ENV SSH_PASS="${RCON_PASS}"
ENTRYPOINT echo "minecraft:${SSH_PASS}" | chpasswd && yes n | ssh-keygen -f ~/.ssh/id_ed25519 -N ""; \
  $(which sshd.pam) -D -h ~/.ssh/id_ed25519 -o "UsePAM yes" -o "Subsystem rcon $(which rcon-cli) --host=${RCON_HOST} --port=${RCON_PORT} --password=${RCON_PASS}"
