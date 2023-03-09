FROM ubuntu:22.10

RUN apt-get update \
  && apt remove -y cmdtest yarn \
  && ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata \
  && dpkg-reconfigure --frontend noninteractive tzdata

# Install required packages
RUN apt install -y npm nodejs nginx

# Due to an issue with yarn, it needs to be installed via NPM globally
RUN npm install -g yarn

RUN npm install -g ts-node

RUN yarn global add serve nodemon

# Configure Nginx
COPY image/etc/nginx/nginx.conf /etc/nginx/sites-available/default
RUN chmod u+s /usr/sbin/nginx

# Container start scripts
COPY image/entrypoint /opt/entrypoint
WORKDIR /opt/entrypoint
RUN chmod 755 -R *

# Create a user to run the application
RUN groupadd nodejs \
  && useradd --create-home --home-dir /home/nodejs --gid nodejs --shell /bin/bash nodejs

# Copy the application into the container volumes (this is not require as we are mounting the volumes)
# and ensure that the user has the required access.
COPY --chown=nodejs:nodejs volumes/web/public/ /opt/web/public/
COPY --chown=nodejs:nodejs volumes/web/src/ /opt/web/src/
COPY --chown=nodejs:nodejs volumes/web/*.* /opt/web/
#
COPY --chown=nodejs:nodejs volumes/api/src/ /opt/api/src/
COPY --chown=nodejs:nodejs volumes/api/*.* /opt/api/

# Switch to the application user and build(compile) the application
USER nodejs:nodejs
# Web frontend
WORKDIR /opt/web
RUN yarn install
RUN yarn build
# API
WORKDIR /opt/api
RUN npm install

ENTRYPOINT [ "/opt/entrypoint/entrypoint.sh" ]
