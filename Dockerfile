FROM python:3.11-bullseye

# set the correct timezone
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# update the base packages and add a non-sudo user
RUN apt-get update -y \
    && apt-get upgrade -y \
    && useradd -m student

ENV APP_DIR=/opt/otree

# app dirs
RUN mkdir -p ${APP_DIR} \
    && mkdir -p /opt/init

ADD . ${APP_DIR}
RUN pip install --no-cache-dir -r ${APP_DIR}/requirements.txt

ADD entrypoint.sh ${APP_DIR}
RUN chmod +x ${APP_DIR}/entrypoint.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "student" so all subsequent commands are run as the student user
USER student

WORKDIR ${APP_DIR}
VOLUME /opt/init
ENTRYPOINT ["/bin/bash", "/opt/otree/entrypoint.sh"]
EXPOSE 8080