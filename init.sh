#!/bin/sh 
DEMO="Generic Loan Demo"
AUTHORS="Dan-Grigore Pupaza, Alexandre Porcelli, Eric D. Schabell"
PROJECT="git@github.com:eschabell/bpms-generic-loan-demo.git"
PRODUCT="JBoss BPM Suite"
JBOSS_HOME=./target/jboss-eap-6.1
SERVER_DIR=$JBOSS_HOME/standalone/deployments/
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects/bpms-generic-loan
EAP=jboss-eap-6.1.1.zip
BPMS=jboss-bpms-6.0.0.GA-redhat-2-deployable-eap6.x.zip
VERSION=6.0.0.CR2

# wipe screen.
clear 

echo
echo "#################################################################"
echo "##                                                             ##"   
echo "##  Setting up the ${DEMO}                           ##"
echo "##                                                             ##"   
echo "##                                                             ##"   
echo "##     ####  ####   #   #      ### #   # ##### ##### #####     ##"
echo "##     #   # #   # # # # #    #    #   #   #     #   #         ##"
echo "##     ####  ####  #  #  #     ##  #   #   #     #   ###       ##"
echo "##     #   # #     #     #       # #   #   #     #   #         ##"
echo "##     ####  #     #     #    ###  ##### #####   #   #####     ##"
echo "##                                                             ##"   
echo "##                                                             ##"   
echo "##  brought to you by,                                         ##"   
echo "##   ${AUTHORS}  ##"
echo "##                                                             ##"   
echo "##  ${PROJECT}        ##"
echo "##                                                             ##"   
echo "#################################################################"
echo

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

# make some checks first before proceeding.	
if [[ -r $SRC_DIR/$EAP || -L $SRC_DIR/$EAP ]]; then
		echo EAP sources are present...
		echo
else
		echo Need to download $EAP package from the Customer Portal 
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

# Create the target directory if it does not already exist.
if [ ! -x target ]; then
		echo "  - creating the target directory..."
		echo
		mkdir target
else
		echo "  - detected target directory, moving on..."
		echo
fi

# Move the old JBoss instance, if it exists, to the OLD position.
if [ -x $JBOSS_HOME ]; then
		echo "  - existing JBoss Enterprise EAP 6 detected..."
		echo
		echo "  - moving existing JBoss Enterprise EAP 6 aside..."
		echo
		rm -rf $JBOSS_HOME.OLD
		mv $JBOSS_HOME $JBOSS_HOME.OLD
fi

# Unzip the JBoss EAP instance.
echo Unpacking new JBoss Enterprise EAP 6...
echo
unzip -q -d target $SRC_DIR/$EAP

# Unzip the required files from JBoss product deployable.
echo Unpacking $PRODUCT $VERSION...
echo
unzip -q -o -d target $SRC_DIR/$BPMS

echo "  - enabling demo accounts logins in application-users.properties file..."
echo
cp $SUPPORT_DIR/application-users.properties $SERVER_CONF

echo "  - enabling demo accounts role setup in application-roles.properties file..."
echo
cp $SUPPORT_DIR/application-roles.properties $SERVER_CONF

echo "  - enabling management accounts login setup in mgmt-users.properties file..."
echo
cp $SUPPORT_DIR/mgmt-users.properties $SERVER_CONF

echo "  - setting up demo projects..."
echo
cp -r $SUPPORT_DIR/bpm-suite-demo-niogit $SERVER_BIN/.niogit
cp -r $SUPPORT_DIR/bpm-suite-demo-index $SERVER_BIN/.index

# Optional: uncomment this to install mock data for BPM Suite, providing 
#           colorful BAM history charts and filled Process & Task dashboard 
#           views.
#
#echo "  - setting up mock bpm dashboard data..."
#echo
#cp $SUPPORT_DIR/1000_jbpm_demo_h2.sql $SERVER_DIR/dashbuilder.war/WEB-INF/etc/sql

echo "  - setting up standalone.xml configuration adjustments..."
echo
cp $SUPPORT_DIR/standalone.xml $SERVER_CONF

echo "  - making sure standalone.sh for server is executable..."
echo
chmod u+x $JBOSS_HOME/bin/standalone.sh

echo "  - temp CR1 fix for persisitence bug: https://bugzilla.redhat.com/show_bug.cgi?id=1055122 ..."
echo
cp -r $SUPPORT_DIR/persistence.xml $SERVER_DIR/business-central.war/WEB-INF/classes/META-INF/persistence.xml

echo "You can now start the $PRODUCT with $SERVER_BIN/standalone.sh"
echo

echo "PRE-LOAD DEMO"
echo "============="
echo "To load the BPM with a set of process instances, you can run the following command"
echo "after you start JBoss BPM Suite, build and deploy the mortgage project, then you can"
echo "use the helper jar file found in the support directory as follows:"
echo 
echo "   java -jar jboss-generic-loan-demo-client.jar erics bpmsuite" 
echo


echo "$PRODUCT $VERSION $DEMO Setup Complete."
echo

