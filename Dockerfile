FROM qnib/alpn-node

RUN cd /tmp/ \
 && wget -q https://github.com/ChristianKniep/docker-swarm-visualizer/archive/master.zip \
 && cd /opt/ \
 && unzip /tmp/master.zip \
 && mkdir -p /opt/swarm-visualizer/ \
 && cd /opt/swarm-visualizer/ \
# Only run npm install if these files change.
 && cp /opt/docker-swarm-visualizer-master/package.json . \
# Install dependencies
 && npm install --unsafe-perm=true

# Add the rest of the sources
RUN cp -r /opt/docker-swarm-visualizer-master/* /opt/swarm-visualizer/ \
# Build the app
 && cd /opt/swarm-visualizer/ \
 && npm run dist

# Default host is localhost. This is for same-origin policies.
ENV HOST=localhost \
    DOCKER_HOST=/var/run/docker.sock

# Number of milliseconds between polling requests. Default is 1000.
ENV MS 1000

#Default port to expose.
ENV PORT 8080
EXPOSE 8080

ADD etc/supervisord.d/swarm-visualizer.ini /etc/supervisord.d/
ADD opt/qnib/swarm-visualizer/bin/start.sh \
    opt/qnib/swarm-visualizer/bin/healthcheck.sh \
    /opt/qnib/swarm-visualizer/bin/
ADD etc/consul.d/swarm-visualizer.json /etc/consul.d/
HEALTHCHECK --interval=2s --retries=120 --timeout=1s \
  CMD /opt/qnib/swarm-visualizer/bin/healthcheck.sh
