# If run for the first time, set up databases
#if [ ! -f "/opt/init/.done" ]; then
#    /usr/bin/env python -u /usr/local/bin/otree resetdb --noinput \
#    && touch /opt/init/.done
#fi
# Start oTree server
/usr/bin/env
cd /home/student && otree prodserver 8080