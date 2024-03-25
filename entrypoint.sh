# If run for the first time, set up databases
if [ ! -f "/opt/init/.done" ]; then
    /usr/bin/env python -u /usr/local/bin/otree resetdb --noinput \
    && touch /opt/init/.done
fi
DATABASE_URL=postgres://otree:otree@database/otree
# Start oTree server
cd /opt/otree && otree runprodserver 8080
