@echo off
color a
for /f "delims=" %%a in ('git --man-path') do @set gitdir=%%a/../../..\bin\bash.exe
rem -q for mvn javaw for java
rem ---------------------------- Clean up ----------------------------
echo Cleaning up old files...
rmdir /s /q build
rem --------------------- Downloading BuildTools ---------------------
echo Downloading BuildTools...
mkdir build
winget "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar" -q -O "build\BuildTools.jar" --no-check-certificate
rem ----------------------- Downloading spigot -----------------------
echo Downloading spigot...
cd build
"%gitdir%" -l -c "javaw -jar BuildTools.jar --rev 1.8.8 --skip-compile"
rem ------------------------ Patching spigot -------------------------
echo Patching spigot...
cd ..\
git apply patches\spinot-1.8.8.patch
rem ------------------------ Compiling spinot ------------------------
echo Compiling spinot...
cd build\Spigot\Spigot-Server
mvn -B -q clean install
cd ..\..\..\
çopy build\Spigot\Spigot-Server\target\spigot-1.8.8-R0.1-SNAPSHOT.jar spigot.jar
rem -------------------------------------------------------------------
echo Complete!