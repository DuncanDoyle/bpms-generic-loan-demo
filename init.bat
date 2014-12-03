@ECHO OFF
setlocal

set PROJECT_HOME=%~dp0
set DEMO=Generic Loan Demo
set AUTHORS=Dan-Grigore Pupaz, Alexandre Porcelli, Eric D. Schabell
set PROJECT=git@github.com:jbossdemocentral/bpms-generic-loan-demo.git
set PRODUCT=JBoss BPM Suite
set JBOSS_HOME=%PROJECT_HOME%\target\jboss-eap-6.1
set SERVER_DIR=%JBOSS_HOME%\standalone\deployments\
set SERVER_CONF=%JBOSS_HOME%\standalone\configuration\
set SERVER_BIN=%JBOSS_HOME%\bin
set SRC_DIR=%PROJECT_HOME%\installs
set SUPPORT_DIR=%PROJECT_HOME%\support
set PRJ_DIR=%PROJECT_HOME%\projects\bpms-generic-loan
set BPMS=jboss-bpms-installer-6.0.3.GA-redhat-1.jar
set VERSION=6.0.3

REM wipe screen.
cls

echo.
echo #################################################################
echo ##                                                             ##   
echo ##  Setting up the %DEMO%                            ##
echo ##                                                             ##   
echo ##                                                             ##   
echo ##     ####  ####   #   #      ### #   # ##### ##### #####     ##
echo ##     #   # #   # # # # #    #    #   #   #     #   #         ##
echo ##     ####  ####  #  #  #     ##  #   #   #     #   ###       ##
echo ##     #   # #     #     #       # #   #   #     #   #         ##
echo ##     ####  #     #     #    ###  ##### #####   #   #####     ##
echo ##                                                             ##   
echo ##                                                             ##   
echo ##  brought to you by,                                         ##   
echo ##   ${AUTHORS}  ##
echo ##                                                             ##   
echo ##  %PROJECT%  ##
echo ##                                                             ##   
echo #################################################################
echo.

REM make some checks first before proceeding.	
if exist %SRC_DIR%\%BPMS% (
        echo Product sources are present...
        echo.
) else (
        echo Need to download %BPMS% package from the Customer Support Portal
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

REM Move the old JBoss instance, if it exists, to the OLD position.
if exist %JBOSS_HOME% (
         echo - existing JBoss product install detected...
         echo.
         echo - moving existing JBoss product install moved aside...
         echo.
        
        if exist "%JBOSS_HOME%.OLD" (
                rmdir /s /q "%JBOSS_HOME%.OLD"
        )
        
         move "%JBOSS_HOME%" "%JBOSS_HOME%.OLD"
 )

REM Run installer.
echo Product installer running now...
echo.
java -jar %SRC_DIR%/%BPMS% %SUPPORT_DIR%\installation-bpms -variablefile %SUPPORT_DIR%\installation-bpms.variables

echo - setting up demo projects...
echo.

echo - enabling demo accounts role setup in application-roles.properties file...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\application-roles.properties" "%SERVER_CONF%"
echo. 

mkdir "%SERVER_BIN%\.niogit\"
xcopy /Y /Q /S "%SUPPORT_DIR%\bpm-suite-demo-niogit\*" "%SERVER_BIN%\.niogit\"
echo. 

REM Optional: uncomment this to install mock data for BPM Suite, providing 
REM           colorful BAM history charts and filled Process & Task dashboard 
REM           views.
REM
REM echo - setting up mock bpm dashboard data...
REM echo.
REM xcopy /Y /Q "%SUPPORT_DIR%\1000_jbpm_demo_h2.sql" "%SERVER_DIR%\dashbuilder.war\WEB-INF\etc\sql"
REM echo. 

echo - setting up standalone.xml configuration adjustments...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\standalone.xml" "%SERVER_CONF%"
echo.

echo.
echo You can now start the %PRODUCT% with %SERVER_BIN%\standalone.bat
echo.

echo PRE-LOAD DEMO
echo =============
echo To load the BPM with a set of process instances, you can run the following
echo command after you start JBoss BPM Suite, build and deploy the mortgage
echo project, then you can use the helper jar file found in the support directory
echo as follows:
echo. 
echo    java -jar jboss-generic-loan-demo-client.jar erics bpmsuite1!
echo.


echo %PRODUCT% %VERSION% %DEMO% Setup Complete.
echo.
