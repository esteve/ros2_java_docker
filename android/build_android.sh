set -e

ROS2_CURDIR=$PWD
ROS2_JAVA_DIR=$(test -n $TRAVIS && echo /home/travis/build || echo $ROS2_CURDIR)
ROS2_OUTPUT_DIR=$ROS2_JAVA_DIR/output
AMENT_WS=$ROS2_JAVA_DIR/ament_ws
ROS2_ANDROID_WS=$ROS2_JAVA_DIR/ros2_android_ws
AMENT_BUILD_DIR=$ROS2_OUTPUT_DIR/build_isolated_ament
AMENT_INSTALL_DIR=$ROS2_OUTPUT_DIR/install_isolated_ament
ROS2_ANDROID_BUILD_DIR=$ROS2_OUTPUT_DIR/build_isolated_android
ROS2_ANDROID_INSTALL_DIR=$ROS2_OUTPUT_DIR/install_isolated_android
#TOOLCHAIN_FILE=/opt/android/android-ndk-r13b/build/cmake/android.toolchain.cmake
ANDROID_NDK=/opt/android/android-ndk-r14
TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake
#ANDROID_STL=c++_shared
ANDROID_STL=gnustl_shared
ANDROID_TARGET=android-22
ANDROID_ABI=armeabi-v7a

mkdir -p $ROS2_JAVA_DIR
mkdir -p $AMENT_WS/src
mkdir -p $ROS2_ANDROID_WS/src

if [ -z "$ROS2_JAVA_SKIP_FETCH" ]; then
  cd $ROS2_JAVA_DIR
  echo "branch: $ROS2_JAVA_BRANCH"

  cd $AMENT_WS
  wget https://raw.githubusercontent.com/esteve/ament_java/$ROS2_JAVA_BRANCH/ament_java.repos || wget https://raw.githubusercontent.com/esteve/ament_java/master/ament_java.repos
  vcs import $AMENT_WS/src < ament_java.repos
  vcs custom --git --args checkout $ROS2_JAVA_BRANCH || true
  vcs export

  cd $ROS2_ANDROID_WS
  wget https://raw.githubusercontent.com/esteve/ros2_java/$ROS2_JAVA_BRANCH/ros2_java_android.repos || wget https://raw.githubusercontent.com/esteve/ros2_java/master/ros2_java_android.repos
  vcs import $ROS2_ANDROID_WS/src < ros2_java_android.repos || true
  vcs custom --git --args checkout $ROS2_JAVA_BRANCH || true
  vcs export

  cd $ROS2_ANDROID_WS/src/ros2/rosidl
  touch python_cmake_module/AMENT_IGNORE
  test -e $ROS2_ANDROID_WS/src/ros2/rmw_fastrtps/rmw_fastrtps_c/package.xml && touch rosidl_generator_cpp/AMENT_IGNORE
  touch rosidl_generator_py/AMENT_IGNORE
  test -e $ROS2_ANDROID_WS/src/ros2/rmw_fastrtps/rmw_fastrtps_c/package.xml && touch rosidl_typesupport_introspection_cpp/AMENT_IGNORE

  cd $ROS2_ANDROID_WS/src/ros2/rosidl_typesupport
  patch -p1 < ../../ros2_java/ros2_java/rosidl_typesupport_ros2_android.patch

#  cd $ROS2_ANDROID_WS/src/eProsima/Fast-RTPS
#  git submodule init
#  git submodule update
fi

cd $ROS2_ANDROID_WS/src/ros2/rmw_fastrtps
test -e $ROS2_ANDROID_WS/src/ros2/rmw_fastrtps/rmw_fastrtps_c/package.xml && touch rmw_fastrtps_cpp/AMENT_IGNORE

cd $ROS2_ANDROID_WS/src/ros2/rosidl_typesupport
test -e $ROS2_ANDROID_WS/src/ros2/rmw_fastrtps/rmw_fastrtps_c/package.xml && touch rosidl_typesupport_cpp/AMENT_IGNORE

if [ -z "$ROS2_JAVA_SKIP_AMENT" ]; then
  cd $AMENT_WS
  $AMENT_WS/src/ament/ament_tools/scripts/ament.py build --symlink-install --isolated --install-space $AMENT_INSTALL_DIR --build-space $AMENT_BUILD_DIR
fi

. $AMENT_INSTALL_DIR/local_setup.sh

cd $ROS2_ANDROID_WS
ament build --symlink-install --isolated --install-space $ROS2_ANDROID_INSTALL_DIR --build-space $ROS2_ANDROID_BUILD_DIR --cmake-args \
  -DEPROSIMA_BUILD=ON \
  -DPYTHON_EXECUTABLE=/usr/bin/python3 -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE \
  -DANDROID_FUNCTION_LEVEL_LINKING=OFF -DANDROID_NATIVE_API_LEVEL=$ANDROID_TARGET -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-clang -DANDROID_STL=$ANDROID_STL \
  -DANDROID_ABI=$ANDROID_ABI -DANDROID_NDK=$ANDROID_NDK -DTHIRDPARTY=ON -DCOMPILE_EXAMPLES=OFF -DCMAKE_FIND_ROOT_PATH="$AMENT_INSTALL_DIR;$ROS2_ANDROID_INSTALL_DIR" \
  -DANDROID_CPP_FEATURES="exceptions rtti" \
  -DENABLE_RMW_FASTRTPS_C=ON \
  -- \
  --ament-cmake-args \
  -DEPROSIMA_BUILD=ON \
  -DPYTHON_EXECUTABLE=/usr/bin/python3 -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE \
  -DANDROID_FUNCTION_LEVEL_LINKING=OFF -DANDROID_NATIVE_API_LEVEL=$ANDROID_TARGET -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-clang -DANDROID_STL=$ANDROID_STL \
  -DANDROID_ABI=$ANDROID_ABI -DANDROID_NDK=$ANDROID_NDK -DTHIRDPARTY=ON -DCOMPILE_EXAMPLES=OFF -DCMAKE_FIND_ROOT_PATH="$AMENT_INSTALL_DIR;$ROS2_ANDROID_INSTALL_DIR" \
  -DANDROID_CPP_FEATURES="exceptions rtti" \
  -DENABLE_RMW_FASTRTPS_C=ON \
  -- \
  --ament-gradle-args \
  -Pament.android_stl=$ANDROID_STL -Pament.android_abi=$ANDROID_ABI -Pament.android_ndk=$ANDROID_NDK -- $@

cd $ROS2_CURDIR
