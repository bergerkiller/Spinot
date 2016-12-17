@echo off
color a
rem ---------------------------- Varialbes ---------------------------
for /f "delims=" %%a in ('git --man-path') do @set gitdir=%%a/../../..\bin\bash.exe
rem ---------------------------- Clean up ----------------------------
echo Cleaning up old files...
rmdir /s /q build
rem --------------------- Downloading BuildTools ---------------------
echo Downloading BuildTools...
mkdir build
winget "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar" -q -O "build\BuildTools.jar" --no-check-certificate
rem ----------------------- Downloading spigot -----------------------
echo Downloading Spigot...
cd build
"%gitdir%" -l -c "javaw -jar BuildTools.jar --rev %1 --skip-compile"
rem ------------------------ Patching spigot -------------------------
echo Patching Spigot...
cd Spigot\Spigot-Server
git apply ..\..\..\patches\spinot-%1.patch
rem ------------------------ Compiling spinot ------------------------
echo Compiling Spinot...
cd ..\
call mvn -B -l mvnlog.log clean install
cd ..\..\
copy build\Spigot\Spigot-Server\target\spinot.jar spinot-%1.jar
rem -------------------------------------------------------------------
echo Complete! Get your file "spinot.jar"