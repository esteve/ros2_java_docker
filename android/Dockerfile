FROM esteve/ros2-ubuntu-xenial-travisci:common
MAINTAINER esteve@apache.org

RUN apt-get install -y --no-install-recommends unzip

# Install CMake 3.6, required by Android's CMake toolchain
RUN add-apt-repository ppa:csaba-kertesz/random
RUN apt-get update
RUN apt-get install -y --no-install-recommends cmake

ENV ANDROID_NDK_VERSION android-ndk-r15
# tools_r26.0.2
ENV ANDROID_SDK_VERSION 3859397

RUN wget -O /tmp/android-ndk.zip https://dl.google.com/android/repository/${ANDROID_NDK_VERSION}-linux-x86_64.zip && mkdir -p /opt/android/ && cd /opt/android/ && unzip /tmp/android-ndk.zip && rm /tmp/android-ndk.zip
RUN wget -O /tmp/android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip && mkdir -p /opt/android/android-sdk-linux && cd /opt/android/android-sdk-linux && unzip /tmp/android-sdk.zip && rm /tmp/android-sdk.zip

ENV ANDROID_TARGET android-21
ENV ANDROID_ABI armeabi-v7a
ENV ANDROID_NDK /opt/android/${ANDROID_NDK_VERSION}/
ENV ANDROID_SDK /opt/android/android-sdk-linux/

# The following are required for aapt (Android)
RUN apt-get install -y --no-install-recommends lib32z1 lib32ncurses5 lib32stdc++6
ENV ANDROID_HOME ${ANDROID_SDK}
ENV PATH $PATH:$ANDROID_HOME/platform-tools/:$ANDROID_HOME/tools/

# Accept licenses
RUN yes | ${ANDROID_SDK}/tools/bin/sdkmanager --licenses

# Install platform tools
RUN yes | ${ANDROID_SDK}/tools/bin/sdkmanager --verbose "platforms;${ANDROID_TARGET}"

# Disable emulator for now
# RUN yes | ${ANDROID_SDK}/tools/bin/sdkmanager --verbose "emulator"
# RUN yes | ${ANDROID_SDK}/tools/bin/sdkmanager --verbose "system-images;${ANDROID_TARGET};default;armeabi-v7a"
# RUN yes | ${ANDROID_SDK}/tools/bin/sdkmanager --verbose "system-images;${ANDROID_TARGET};default;x86_64"
# RUN echo no | ${ANDROID_SDK}/tools/bin/avdmanager create avd --force --name test --package "system-images;${ANDROID_TARGET};default;${ANDROID_ABI}" --abi ${ANDROID_ABI}

ADD build_android.sh /build_android.sh
