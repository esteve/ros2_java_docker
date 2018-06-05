FROM ubuntu:xenial
MAINTAINER esteve@apache.org
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
RUN apt-get install -y --no-install-recommends \
    apt-transport-https \
    dirmngr \
    gnupg-agent \
    lsb-release \
    software-properties-common \
    tzdata
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-latest.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2486D2DD83DB69272AFE98867170598AF249743
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    cppcheck \
    git \
    python-empy \
    python3-catkin-pkg-modules \
    python3-dev \
    python3-empy \
    python3-nose \
    python3-pip \
    python3-pyparsing \
    python3-setuptools \
    python3-vcstool \
    wget
RUN pip3 install \
    argcomplete
# additional testing dependencies from pip (because not available on ubuntu 16.04)
RUN pip3 install \
    flake8 \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes \
    pytest \
    pytest-cov \
    pytest-runner
RUN apt-get install -y --no-install-recommends \
    python3-colcon-common-extensions
RUN add-apt-repository ppa:cwchien/gradle
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    gradle \
    openjdk-8-jdk-headless
RUN mkdir -p /root/.gradle
RUN echo org.gradle.daemon=true | tee /root/.gradle/gradle.properties
RUN echo org.gradle.jvmargs=-Xmx2048M | tee -a /root/.gradle/gradle.properties
RUN echo "buildscript { repositories { jcenter() }; dependencies { classpath 'com.android.tools.build:gradle:2.2.0+' } }" | tee /tmp/dummy.gradle
RUN gradle -b /tmp/dummy.gradle
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    libopencv-dev \
    libpcre3-dev
RUN apt-get install -y --no-install-recommends \
    libasio-dev \
    libtinyxml2-dev \
    openjdk-8-jdk
# dependencies for testing
RUN apt-get install -y --no-install-recommends \
    clang-format \
    pydocstyle \
    pyflakes \
    python3-coverage \
    python3-mock \
    python3-pep8 \
    uncrustify
