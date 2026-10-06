# Use parameter expansion to split a string '<repository>@<branch>'
repo=${REPOSITORY%%@*}
branch=${REPOSITORY#*@}

# If run for the first time, set up databases
if [ ! -f "/home/student/init/.done" ]; then

    # See: https://stackoverflow.com/questions/6174220/parse-url-in-shell-script
    # extract the protocol
    proto="$(echo $repo | grep :// | sed -e's,^\(.*://\).*,\1,g')"

    # remove the protocol
    url="$(echo ${repo/$proto/})"

    # final URL segment, typically <repository>.git
    file="${url##*/}"

    # filename without the extension, in this case: repository name
    filename="${file%.*}"

    # when the '@' character is missing, both regex patterns will match
    if [ "$branch" == "$repo" ]; then
      echo "repo without branch"
      # The $repo variable will typically contain an organisation and a repository
      git clone ${proto}${GITHUB_USER}:${ACCESS_TOKEN}@${url}
    else
      echo "have a branch '$branch'"
      git clone -b ${branch} --single-branch ${proto}${GITHUB_USER}:${ACCESS_TOKEN}@${url}
    fi
    if [ $? -eq 0 ]; then
      echo "Experiment successfully downloaded from Github"
    else
      echo "Git clone failed, you may want to check your URL or access token"
      exit 1
    fi

    cd /home/student/${filename} || { echo "Cannot cd into repository"; exit 1; }
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
cd /home/student/${filename} \
  && export PATH=$PATH:~/.local/bin \
  && otree prodserver