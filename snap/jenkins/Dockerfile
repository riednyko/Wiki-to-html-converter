FROM ubuntu:latest

# This is in accordance to : https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	apt-get install -y ant && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;
	
# Fix certificate issues, found as of 
# https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/983302
RUN apt-get update && \
	apt-get install -y ca-certificates-java && \
	apt-get clean && \
	update-ca-certificates -f && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

# Setup JAVA_HOME, this is useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_AGENT_HOME=/home/${user}

ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}

RUN groupadd -g ${gid} ${group} \
    && useradd -d "${JENKINS_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}"

VOLUME "${JENKINS_AGENT_HOME}" "/tmp" "/run" "/var/run"
WORKDIR "${JENKINS_AGENT_HOME}"

RUN apt-get update && apt-get install -y rpm dpkg-dev ant osslsigncode curl zip unzip bzip2 wget xz-utils git build-essential --classic snapcraft lxd

ARG MAVEN_VERSION=3.5.2
ARG USER_HOME_DIR="/home/jenkins"
ARG SHA=707b1f6e390a65bde4af4cdaf2a24d45fc19a6ded00fff02e91626e3e42ceaff
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

ARG NSIS_VERSION=3.01
ARG NSIS_SHA=daa17556c8690a34fb13af25c87ced89c79a36a935bf6126253a9d9a5226367c
ARG BASE_URL=https://netix.dl.sourceforge.net/project/nsis/NSIS%203
ARG NSIS_ZIP=nsis-${NSIS_VERSION}.zip

#RUN mkdir /home/jenkins/tests \
#  && curl -fsSL -o /tmp/${NSIS_ZIP} ${BASE_URL}/${NSIS_VERSION}/${NSIS_ZIP} \
#  && echo "${NSIS_SHA}  /tmp/${NSIS_ZIP}" | sha256sum -c - \
#  && unzip /tmp/${NSIS_ZIP} -d /home/jenkins/tests

RUN apt-get update && apt-get install -y gcc libgcc-5-dev scons zlib1g-dev

RUN mkdir -p /opt/jenkins/tests \
  && curl -fsSL -o /tmp/${NSIS_ZIP} ${BASE_URL}/${NSIS_VERSION}/${NSIS_ZIP} \
  && echo "${NSIS_SHA}  /tmp/${NSIS_ZIP}" | sha256sum -c - \
  && unzip /tmp/${NSIS_ZIP} -d /opt/jenkins/tests \
  && curl -fsSL -o /opt/jenkins/tests/nsis-3.01-src.tar.bz2 https://vorboss.dl.sourceforge.net/project/nsis/NSIS%203/3.01/nsis-3.01-src.tar.bz2 \
  && cd /opt/jenkins/tests && tar xvfj nsis-3.01-src.tar.bz2 && cd nsis-3.01-src \
  && scons SKIPSTUBS=all SKIPPLUGINS=all SKIPUTILS=all SKIPMISC=all NSIS_CONFIG_CONST_DATA_PATH=no PREFIX=/opt/jenkins/tests/nsis-3.01 install-compiler \
  && cp build/urelease/makensis/makensis /opt/jenkins/tests/nsis-3.01/ \
  && cd /opt/jenkins/tests/nsis-3.01/ && ln -s . bin && cd /opt/jenkins/tests && ln -s nsis-3.01/Stubs Stubs \
  && curl -fsSL -o /opt/jenkins/tests/UAC.zip http://nsis.sourceforge.net/mediawiki/images/8/8f/UAC.zip \
  && unzip /opt/jenkins/tests/UAC.zip -d /opt/jenkins/tests/UAC \
  && cp /opt/jenkins/tests/UAC/Plugins/x86-ansi/UAC.dll /opt/jenkins/tests/nsis-3.01/Plugins/x86-ansi/ \
  && cp /opt/jenkins/tests/UAC/Plugins/x86-unicode/UAC.dll /opt/jenkins/tests/nsis-3.01/Plugins/x86-unicode/ \
  && cp /opt/jenkins/tests/UAC/UAC.nsh /opt/jenkins/tests/nsis-3.01/Include/ \
  && mkdir /opt/jenkins/tests/nsis-3.01/share && ln -s /opt/jenkins/tests/nsis-3.01 /opt/jenkins/tests/nsis-3.01/share/nsis \
  && cp -r /opt/jenkins/tests/nsis-3.01 /usr/share/nsis-3.01 \
  && ln -s /usr/share/nsis-3.01 /usr/share/nsis

ENV NSISDIR /usr/share/nsis 

USER jenkins
