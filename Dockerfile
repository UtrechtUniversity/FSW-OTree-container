FROM python:3.11-bullseye

# set the correct timezone
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# update the base packages and add a non-sudo user
RUN apt-get update -y \
    && apt-get upgrade -y \
    && useradd -m student

# install python and the packages your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    postgresql-client

ENV APP_DIR=/opt/otree
ENV DJANGO_SETTINGS_MODULE 'settings'
ARG OTREE_APP_FOLDER=app

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
ENTRYPOINT ${APP_DIR}/entrypoint.sh
EXPOSE 8080