FROM ruby:2.2
LABEL maintainer "nshadov <ns@ravencloud.net>"

RUN apt-get update && apt-get upgrade -y

RUN apt-get -y install curl git build-essential openssl software-properties-common \
    libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 \
    libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libc6-dev libncurses5-dev \
    automake libtool bison subversion locales

RUN apt-get -y install python python-dev python-pip
RUN pip install --upgrade pip
RUN pip install awscli

RUN apt-get clean && apt-get autoremove

RUN locale-gen UTF-8 en_US && localedef -c -f UTF-8 -i en_US en_US.UTF-8

RUN useradd -mrs /bin/nologin beef-user
WORKDIR /home/beef-user
ADD get_config.sh .
RUN chmod a+rx get_config.sh


RUN mkdir /home/beef-user/vol && chown beef-user:beef-user /home/beef-user/vol
VOLUME ["/home/beef-user/vol"]

USER beef-user

RUN git clone git://github.com/beefproject/beef.git beef-repo
RUN cp -r beef-repo/* .
RUN gem install bundler && bundle install

RUN sed -i 's|db_file: "beef.db"|db_file: "vol/beef.db"|' config.yaml

RUN mkdir .beef .aws
RUN mkdir -p /home/beef-user/extensions/admin_ui/media/
VOLUME ["/home/beef-user/.aws/"]
VOLUME ["/home/beef-user/extensions/admin_ui/media/"]

ENV URI_CONFIG s3://base-security-container-config/beef.conf
ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en" LC_ALL="en_US.UTF-8"

EXPOSE 3000

CMD ./get_config.sh || ruby ./beef