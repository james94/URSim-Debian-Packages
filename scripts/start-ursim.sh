#!/bin/bash

export LD_LIBRARY_PATH=/opt/urtool-3.0/lib

URSIM_ROOT=$(dirname $(readlink -f $0))

pushd $URSIM_ROOT &>/dev/null

CLASSPATH=$(echo $URSIM_ROOT/lib/*.jar | tr ' ' ':')

./stopurcontrol.sh

ROBOT_TYPE="UR5"
if [ "$1" == "UR10" ] ; then
  ROBOT_TYPE="UR10"
elif [ "$1" == "UR3" ] ; then
  ROBOT_TYPE="UR3"
elif [ "$1" == "UR16" ] ; then
  ROBOT_TYPE="UR16"
fi

#Setting up the configuration files according to the robot type
#urcontrol.conf
CONFIG_ROOT=$HOME/.ur

mkdir -p $CONFIG_ROOT
mkdir -p $CONFIG_ROOT/.urcontrol

if [ ! -f "$CONFIG_ROOT/.urcontrol/urcontrol.conf.$ROBOT_TYPE" ]; then
    ln -s $URSIM_ROOT/.urcontrol/urcontrol.conf.$ROBOT_TYPE $CONFIG_ROOT/.urcontrol/urcontrol.conf.$ROBOT_TYPE
fi
rm -f $CONFIG_ROOT/.urcontrol/urcontrol.conf
ln -s $CONFIG_ROOT/.urcontrol/urcontrol.conf.$ROBOT_TYPE $CONFIG_ROOT/.urcontrol/urcontrol.conf

if [ ! -f "$CONFIG_ROOT/.urcontrol/joint_size0_G5_rev1.conf" ]; then
    ln -s $URSIM_ROOT/.urcontrol/joint_size0_G5_rev1.conf $CONFIG_ROOT/.urcontrol/joint_size0_G5_rev1.conf
fi
if [ ! -f "$CONFIG_ROOT/.urcontrol/joint_size1_G5_rev1.conf" ]; then
    ln -s $URSIM_ROOT/.urcontrol/joint_size1_G5_rev1.conf $CONFIG_ROOT/.urcontrol/joint_size1_G5_rev1.conf
fi
if [ ! -f "$CONFIG_ROOT/.urcontrol/joint_size2_G5_rev1.conf" ]; then
    ln -s $URSIM_ROOT/.urcontrol/joint_size2_G5_rev1.conf $CONFIG_ROOT/.urcontrol/joint_size2_G5_rev1.conf
fi
if [ ! -f "$CONFIG_ROOT/.urcontrol/joint_size3_G5_rev1.conf" ]; then
    ln -s $URSIM_ROOT/.urcontrol/joint_size3_G5_rev1.conf $CONFIG_ROOT/.urcontrol/joint_size3_G5_rev1.conf
fi
if [ ! -f "$CONFIG_ROOT/.urcontrol/joint_size4_G5_rev1.conf" ]; then
    ln -s $URSIM_ROOT/.urcontrol/joint_size4_G5_rev1.conf $CONFIG_ROOT/.urcontrol/joint_size4_G5_rev1.conf
fi

#ur-serial
if [ ! -f "$CONFIG_ROOT/ur-serial.$ROBOT_TYPE" ]; then
    ln -s $URSIM_ROOT/ur-serial.$ROBOT_TYPE $CONFIG_ROOT/ur-serial.$ROBOT_TYPE
fi
rm -f $CONFIG_ROOT/ur-serial
ln -s $CONFIG_ROOT/ur-serial.$ROBOT_TYPE $CONFIG_ROOT/ur-serial

#safety.conf
if [ ! -f "$CONFIG_ROOT/.urcontrol/safety.conf.$ROBOT_TYPE" ]; then
    cp $URSIM_ROOT/.urcontrol/safety.conf.$ROBOT_TYPE $CONFIG_ROOT/.urcontrol/safety.conf.$ROBOT_TYPE
fi
rm -f $CONFIG_ROOT/.urcontrol/safety.conf
ln -s $CONFIG_ROOT/.urcontrol/safety.conf.$ROBOT_TYPE $CONFIG_ROOT/.urcontrol/safety.conf

#program directory
mkdir -p $CONFIG_ROOT/programs.$ROBOT_TYPE
if [ ! -f "$CONFIG_ROOT/programs.$ROBOT_TYPE/license.p7b" ]; then
    ln -s $URSIM_ROOT/programs.$ROBOT_TYPE/license.p7b $CONFIG_ROOT/programs.$ROBOT_TYPE/license.p7b
fi
rm -f $CONFIG_ROOT/programs
ln -s $CONFIG_ROOT/programs.$ROBOT_TYPE $CONFIG_ROOT/programs

#GUI directory
mkdir -p $CONFIG_ROOT/GUI
rm -f $CONFIG_ROOT/GUI/bin
rm -f $CONFIG_ROOT/GUI/bundle
rm -f $CONFIG_ROOT/GUI/conf
rm -rf $CONFIG_ROOT/GUI/felix-cache
ln -s $URSIM_ROOT/GUI/bin $CONFIG_ROOT/GUI/bin
ln -s $URSIM_ROOT/GUI/bundle $CONFIG_ROOT/GUI/bundle
ln -s $URSIM_ROOT/GUI/conf $CONFIG_ROOT/GUI/conf

# URControl
if [ ! -f "$CONFIG_ROOT/stopurcontrol.sh" ]; then
    ln -s $URSIM_ROOT/stopurcontrol.sh $CONFIG_ROOT/stopurcontrol.sh
fi
if [ ! -f "$CONFIG_ROOT/starturcontrol.sh" ]; then
    ln -s $URSIM_ROOT/starturcontrol.sh $CONFIG_ROOT/starturcontrol.sh
fi

# Robot Root Certificate check
#$URSIM_ROOT/ursim-certificate-check.sh

HOME=$CONFIG_ROOT ./starturcontrol.sh

#Start the gui
pushd $CONFIG_ROOT/GUI
HOME=$CONFIG_ROOT /usr/lib/jvm/java-8-openjdk-amd64/bin/java -Duser.home=$CONFIG_ROOT -Dconfig.path=$CONFIG_ROOT/.urcontrol -Djava.library.path=/usr/lib/jni -jar bin/*.jar
popd

#clean up
rm -f $CONFIG_ROOT/.urcontrol/urcontrol.conf
rm -f $CONFIG_ROOT/ur-serial
rm -f $CONFIG_ROOT/.urcontrol/safety.conf
rm -f $CONFIG_ROOT/programs

popd &>/dev/null
