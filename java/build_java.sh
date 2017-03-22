set -e

ROS2_CURDIR=$PWD
ROS2_JAVA_DIR=/home/travis/build
ROS2_OUTPUT_DIR=$ROS2_JAVA_DIR/output
AMENT_WS=$ROS2_JAVA_DIR/ament_ws
ROS2_JAVA_WS=$ROS2_JAVA_DIR/ros2_java_ws
AMENT_BUILD_DIR=$ROS2_OUTPUT_DIR/build_isolated_ament
AMENT_INSTALL_DIR=$ROS2_OUTPUT_DIR/install_isolated_ament
ROS2_JAVA_BUILD_DIR=$ROS2_OUTPUT_DIR/build_isolated_java
ROS2_JAVA_INSTALL_DIR=$ROS2_OUTPUT_DIR/install_isolated_java

git config --global user.email "esteve@apache.org"
git config --global user.name "Travis CI - ros2java"

mkdir -p $ROS2_JAVA_DIR
mkdir -p $AMENT_WS/src
mkdir -p $ROS2_JAVA_WS/src

if [ -z "$ROS2_JAVA_BRANCH" ]; then
  ROS2_JAVA_BRANCH=master
fi

if [ -z "$ROS2_JAVA_SKIP_FETCH" ]; then
  cd $ROS2_JAVA_DIR
  echo "branch: $ROS2_JAVA_BRANCH"

  cd $AMENT_WS
  wget https://raw.githubusercontent.com/esteve/ament_java/$ROS2_JAVA_BRANCH/ament_java.repos || wget https://raw.githubusercontent.com/esteve/ament_java/master/ament_java.repos
  vcs import $AMENT_WS/src < ament_java.repos
  vcs custom --git --args checkout $ROS2_JAVA_BRANCH || true
  vcs export
  vcs custom --git --args rebase origin/master

  cd $ROS2_JAVA_WS
  wget https://raw.githubusercontent.com/esteve/ros2_java/$ROS2_JAVA_BRANCH/ros2_java_desktop.repos || wget https://raw.githubusercontent.com/esteve/ros2_java/master/ros2_java_desktop.repos
  vcs import $ROS2_JAVA_WS/src < ros2_java_desktop.repos
  vcs custom --git --args checkout $ROS2_JAVA_BRANCH || true
  vcs export
  cd src/ros2
  vcs custom --git --args rebase origin/master

  cd $ROS2_JAVA_WS/src/ros2/rosidl_typesupport
  patch -p1 < ../../ros2_java/ros2_java/rosidl_typesupport_ros2_java.patch
fi

if [ -z "$ROS2_JAVA_SKIP_AMENT" ]; then
  cd $AMENT_WS
  $AMENT_WS/src/ament/ament_tools/scripts/ament.py build --symlink-install --isolated --install-space $AMENT_INSTALL_DIR --build-space $AMENT_BUILD_DIR
fi

. $AMENT_INSTALL_DIR/local_setup.sh

cd $ROS2_JAVA_WS
ament build --symlink-install --isolated --install-space $ROS2_JAVA_INSTALL_DIR --build-space $ROS2_JAVA_BUILD_DIR --cmake-args -DEPROSIMA_BUILD=ON -- $@

if [ -z "$ROS2_JAVA_SKIP_TESTS" ]; then
  . $ROS2_JAVA_INSTALL_DIR/local_setup.sh

  ament test --symlink-install --isolated --install-space $ROS2_JAVA_INSTALL_DIR --build-space $ROS2_JAVA_BUILD_DIR --only-packages ament_cmake_export_jars rcljava rcljava_common rosidl_generator_java | tee /tmp/test_logging.log

  ! grep -q 'The following tests FAILED' /tmp/test_logging.log

  exit $?
fi
