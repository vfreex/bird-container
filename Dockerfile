FROM debian:bullseye-slim
RUN echo "deb http://deb.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get -t bullseye-backports install -y --no-install-recommends bird2 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/bird && chown -R bird: /run/bird && chmod 775 -R /run/bird

USER bird:root
CMD ["/usr/sbin/bird", "-f", "-s", "/run/bird/bird.ctl"]
