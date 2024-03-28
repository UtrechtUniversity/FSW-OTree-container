# If run for the first time, set up databases
if [ ! -f "/home/student/init/.done" ]; then
    python -u /usr/local/bin/otree resetdb --noinput && touch /home/student/init/.done
fi
# Start oTree server
cd /home/student && otree prodserver