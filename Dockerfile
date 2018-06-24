FROM ruby:2.4.1
LABEL description="Northwestern University Core Facility Management Software"

## set up users, files, gems
# create user
RUN groupadd www && useradd -ms /bin/bash -G www nucore
# make a home
WORKDIR /var/www/app
# copy some bundle things
COPY --chown=nucore:www .ruby-version .
COPY --chown=nucore:www Gemfile .
COPY --chown=nucore:www Gemfile.lock .
# TODO: this is kind of lazy, sorry
COPY --chown=nucore:www vendor/engines ./vendor/engines
# make sure nucore has access to the folder itself
RUN chown -R nucore:www .
# become nucore
USER nucore
# install gems
RUN bundle install --without=oracle

# install dumb-init
USER root
RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb
RUN dpkg -i dumb-init_*.deb
RUN curl https://cdn.rawgit.com/vishnubob/wait-for-it/8ed92e8cab83cfed76ff012ed4a36cef74b28096/wait-for-it.sh -o /usr/local/bin/wait-for-it && chmod +x /usr/local/bin/wait-for-it

# install tools for coordinating containers and databases
RUN apt-get update && apt-get install -y netcat mysql-client
USER nucore

# grab the rest of the files (and save some rebuild time!!)
USER root
RUN apt-get update && apt-get install -y rsync
USER nucore
COPY --chown=nucore:www . /tmp/nucore
RUN rsync -r -v --chmod=ug=rwX,o=rxX --ignore-existing /tmp/nucore/ .

## set up runtime tasks
# dumb-init reaps processes that the kernel reparents to PID 1
ENTRYPOINT ["dumb-init"]
# TODO: HEALTHCHECK
