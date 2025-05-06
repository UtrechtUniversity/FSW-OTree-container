# If run for the first time, set up databases
if [ ! -f "/home/student/init/.done" ]; then
    git clone https://${GITHUB_USER}:${ACCESS_TOKEN}@github.com/UtrechtUniversity/${REPOSITORY}
    if [ $? -eq 0 ]; then
        echo "Experiment successfully downloaded from Github"
    else
        echo "Git clone failed, you may want to check your access token"
        exit 1
    fi
    cd /home/student/${REPOSITORY} || { echo "Cannot cd into repository"; exit 1; }
    pip install -r requirements.txt
    returnValue=$?
    if ! test "returnValue" -eq 0
    then
        echo "Could not install requirements"
        exit 1
    fi
    python -u /usr/local/bin/otree resetdb --noinput && touch /home/student/init/.done
fi
# Start oTree server
cd /home/student/${REPOSITORY} \
  && export PATH=$PATH:~/.local/bin \
  && otree prodserver