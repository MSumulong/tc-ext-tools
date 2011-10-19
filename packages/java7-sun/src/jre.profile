export PATH=$PATH:/usr/local/java-sun/jre/bin
if [ ! -f /etc/profile.d/sun-jdk.sh ]; then
        export JAVA_HOME=/usr/local/java-sun/jre
fi
