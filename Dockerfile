FROM ubuntu:14.04

MAINTAINER Dmitry Lisin <Dmitry.Lisin@gmail.com>

ARG ANSIBLE_VERSION=1.9.4
ARG GRADLE_VERSION=2.14.1
ARG NODEJS_VERSION=6.x

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -yq \
            software-properties-common \
            build-essential \
            libffi-dev \
            python-dev python-pip python-yaml python-jinja2 python-httplib2 python-paramiko python-pkg-resources \
            curl \
            unzip \
            wget \
 && apt-add-repository ppa:webupd8team/java \
 && curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION} | sudo -E bash - \
 && apt-get update \
 && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && pip install ansible==${ANSIBLE_VERSION} \
 && apt-get install -yq \
            git \
            nodejs \
            oracle-java8-installer \
            protobuf-compiler \
            uuid-runtime \
 && apt-get clean

RUN cd /usr/lib \
 && curl -fl https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle-bin.zip \
 && unzip "gradle-bin.zip" \
 && ln -s "/usr/lib/gradle-${GRADLE_VERSION}/bin/gradle" /usr/bin/gradle \
 && rm "gradle-bin.zip"

COPY run-agent.sh /run-agent.sh

ENV GRADLE_HOME /usr/lib/gradle
ENV PATH $GRADLE_HOME/bin:$PATH
ENV TEAMCITY_AGENT_NAME ""
ENV TEAMCITY_AGENT_PORT 9090
ENV TEAMCITY_SERVER "http://localhost:8111"

EXPOSE $TEAMCITY_AGENT_PORT

CMD ["/run-agent.sh"]
