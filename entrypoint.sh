# If run for the first time, set up databases
if [ ! -f "/home/student/init/.done" ]; then
    git clone https://${GITHUB_USER}:${ACCESS_TOKEN}@github.com/UtrechtUniversity/${REPOSITORY}
    python -u /usr/local/bin/otree resetdb --noinput && touch /home/student/init/.done
fi
# Start oTree server
cd /home/student/${REPOSITORY} \
  && pip install -f requirements.txt \
  && otree prodserver