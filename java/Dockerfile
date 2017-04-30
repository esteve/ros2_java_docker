FROM esteve/ros2-ubuntu-xenial-travisci:common
MAINTAINER esteve@apache.org
RUN apt-get install -y --no-install-recommends default-jdk openjdk-8-jdk libasio-dev libtinyxml2-dev
#RUN apt-get install -y --no-install-recommends libboost-chrono-dev libboost-date-time-dev libboost-program-options-dev libboost-regex-dev libboost-system-dev libboost-thread-dev
ADD build_java.sh /build_java.sh
