FROM ubuntu:xenial
MAINTAINER esteve@apache.org
RUN apt-get update
RUN apt-get install -y --no-install-recommends locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
RUN apt-get install -y --no-install-recommends lsb-release software-properties-common
RUN apt-get install -y --no-install-recommends apt-transport-https
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -cs` main" | tee /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu `lsb_release -cs` main" | tee /etc/apt/sources.list.d/gazebo-latest.list
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys D2486D2DD83DB69272AFE98867170598AF249743
RUN add-apt-repository ppa:webupd8team/java
RUN add-apt-repository ppa:cwchien/gradle
#RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" | tee /etc/apt/sources.list.d/dotnetdev.list
RUN apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893
RUN apt-get update
RUN apt-get install -y --no-install-recommends git wget
RUN apt-get install -y --no-install-recommends build-essential cppcheck cmake libopencv-dev python-empy python3-dev python3-empy python3-nose python3-pip python3-setuptools python3-vcstool
# dependencies for testing
RUN apt-get install -y --no-install-recommends clang-format pydocstyle pyflakes python3-coverage python3-mock python3-pep8 uncrustify
#RUN apt-get install -y --no-install-recommends oracle-java8-installer oracle-java8-set-default oracle-java8-unlimited-jce-policy
RUN apt-get install -y --no-install-recommends openjdk-8-jdk-headless default-jdk-headless
RUN apt-get install -y --no-install-recommends gradle
#RUN apt-get install -y --no-install-recommends lib32z1 lib32ncurses5 lib32stdc++6
#RUN apt-get install -y --no-install-recommends vim net-tools
# lib32bz2-1.0 lib32stdc++6
#RUN apt-get install -y --no-install-recommends dotnet-dev-1.0.0-preview2-003131
RUN mkdir -p /root/.gradle
RUN echo org.gradle.daemon=true | tee /root/.gradle/gradle.properties
RUN echo org.gradle.jvmargs=-Xmx2048M | tee -a /root/.gradle/gradle.properties
#RUN apt-get install -y --no-install-recommends junit4
#RUN apt-get install -y --no-install-recommends libslf4j-java
RUN apt-get install -y --no-install-recommends file
RUN echo "buildscript { repositories { jcenter() }; dependencies { classpath 'com.android.tools.build:gradle:2.2.0+' } }" | tee /tmp/dummy.gradle
RUN gradle -b /tmp/dummy.gradle
#ENV J2SDKDIR=/usr/lib/jvm/java-8-oracle
#ENV J2REDIR=/usr/lib/jvm/java-8-oracle/jre
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH=$PATH:${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin
#ENV DERBY_HOME=/usr/lib/jvm/java-8-oracle/db
# Initialize dotnet cache
# Disable dotnet for now
# RUN mkdir /tmp/dotnet-first-run && cd /tmp/dotnet-first-run && dotnet new && cd && rm -rf /tmp/dotnet-first-run
# RUN mkdir -p /root/.android
# RUN touch /root/.android/analytics.settings
RUN pip3 install --upgrade pip
RUN pip3 install vcstool flake8
