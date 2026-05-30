FROM eclipse-temurin:25-jre-resolute

ENV MC_V="26.1.2"
ARG FABRIC_V="0.19.2"
ARG INSTALLER_V="1.1.1"
ARG EULA="false"
ARG FERIUM_REV="9d6f16a"
ENV MINMEM="256M"
ENV MAXMEM="1G"
SHELL ["sh", "-c"]

EXPOSE 25565
VOLUME /data

RUN set -eux; \
	apt-get update; \
	apt-get install -y curl gosu rustup git gcc; \
	rm -rf /var/lib/apt/lists/*
RUN rustup toolchain install stable
RUN mkdir /opt/build/
WORKDIR /opt/build
COPY patches/ patches
RUN set -eux; \
  git clone https://github.com/gorilla-devs/ferium; \
  cd ferium; \
  git checkout $FERIUM_REV; \
  git apply ../patches/0001-fix-rustls-cryptoprovider.patch; \
  cargo install --path . --no-default-features; \
  mv /root/.cargo/bin/ferium /usr/bin; \
  cd ..; \
  rm -r ferium; \
  rm -r /root/.cargo;
RUN set -eux; \
	rm -r /root/.rustup; \
	apt-get purge rustup git gcc -y; \
	apt-get autoremove -y

RUN mkdir /opt/app/
WORKDIR /opt/app
ADD https://meta.fabricmc.net/v2/versions/loader/${MC_V}/${FABRIC_V}/${INSTALLER_V}/server/jar fabric-installer.jar
RUN mkdir minecraft
WORKDIR minecraft
RUN java -jar ../fabric-installer.jar nogui server -dir . -downloadMinecraft

COPY --chmod=755 scripts/build ../scripts/build
RUN ../scripts/build/build.sh

RUN echo "serverJar=.fabric/server/${MC_V}-server.jar" > fabric-server-launcher.properties
ENV SERVER_JARPATH=".fabric/server/fabric-loader-server-${FABRIC_V}-minecraft-${MC_V}.jar"
RUN echo "eula=${EULA}" > eula.txt
COPY --chmod=755 scripts/run ../scripts/run
ENTRYPOINT ../scripts/run/bootstrap.sh ../scripts/run/start.sh
