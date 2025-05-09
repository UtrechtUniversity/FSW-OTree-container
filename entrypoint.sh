# Use parameter expansion to split a string '<repository>@<branch>'
repo=${REPOSITORY%%@*}
branch=${REPOSITORY#*@}

# If run for the first time, set up databases
if [ ! -f "/home/student/init/.done" ]; then
    # when the '@' character is missing, both regex patterns will match
    if [ "$branch" == "$repo" ]; then
      echo "repo without branch"
      git clone https://${GITHUB_USER}:${ACCESS_TOKEN}@github.com/UtrechtUniversity/${repo}
    else
      echo "have a branch '$branch'"
      git clone -b ${branch} --single-branch https://${GITHUB_USER}:${ACCESS_TOKEN}@github.com/UtrechtUniversity/${repo}
    fi
    if [ $? -eq 0 ]; then
      echo "Experiment successfully downloaded from Github"
    else
      echo "Git clone failed, you may want to check your access token"
      exit 1
    fi

    cd /home/student/${repo} || { echo "Cannot cd into repository"; exit 1; }
    pip install -r requirements.txt
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "Could not install requirements"
        exit 1
    fi
    python -u /home/student/.local/bin/otree resetdb --noinput && touch /home/student/init/.done
fi
# Start oTree server
cd /home/student/${repo} \
  && export PATH=$PATH:~/.local/bin \
  && otree prodserver