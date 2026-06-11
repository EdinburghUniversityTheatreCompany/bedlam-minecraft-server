FROM rust:1.96-alpine AS build
SHELL ["sh", "-c"]

RUN mkdir /opt/build/
WORKDIR /opt/build
COPY patches/ patches
ARG FERIUM_REV="9d6f16a"
RUN set -eux; \
	apk update && apk add git;
RUN set -eux; \
  git clone https://github.com/gorilla-devs/ferium; \
  cd ferium; \
  git checkout $FERIUM_REV; \
  git apply ../patches/0001-fix-rustls-cryptoprovider.patch; \
  cargo install --path . --no-default-features

FROM eclipse-temurin:25-jre-resolute
SHELL ["sh", "-c"]
COPY --from=build /usr/local/cargo/bin/ferium /usr/bin/

RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu; \
	rm -rf /var/lib/apt/lists/*
RUN mkdir /opt/app/
WORKDIR /opt/app
ARG MC_V="26.1.2"
ARG FABRIC_V="0.19.2"
ARG FABRIC_INSTALLER_V="1.1.1"
ADD https://maven.fabricmc.net/net/fabricmc/fabric-installer/${FABRIC_INSTALLER_V}/fabric-installer-${FABRIC_INSTALLER_V}.jar \
  fabric-installer.jar
RUN mkdir minecraft
RUN java -jar fabric-installer.jar server -dir minecraft -downloadMinecraft -mcversion "${MC_V}" -loader "${FABRIC_V}"
WORKDIR minecraft

COPY --chmod=755 scripts/build ./scripts/build
RUN ./scripts/build/build.sh

ENV MC_SERVER_JAR="server.jar"
RUN echo "serverJar=${MC_SERVER_JAR}" > fabric-server-launcher.properties
ENV FABRIC_SERVER_JAR="fabric-server-launch.jar"

VOLUME /data

ENV MINMEM="256M"
ENV MAXMEM="1G"
ENV EULA="false"
COPY --chmod=755 scripts/run ./scripts/run
ENTRYPOINT ./scripts/run/bootstrap.sh ./scripts/run/start.sh
