export PATH=$PATH:/usr/local/java/jre/bin
if [ ! -f /etc/profile.d/jdk.sh ]; then
        export JAVA_HOME=/usr/local/java/jre
fi
