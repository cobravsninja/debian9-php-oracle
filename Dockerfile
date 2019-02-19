FROM debian:9

ENV LD_LIBRARY_PATH /usr/lib/oracle/12.2/client64/lib:/lib/x86_64-linux-gnu:/lib:/usr/lib
COPY rpm /rpm

RUN apt-get update && apt-get -y upgrade && \
  apt-get -y install --no-install-recommends -o APT::Install-Suggests=false \
  alien php-curl php-fpm php-json php-pgsql php-pear php-log \
  php-dev libaio1 ca-certificates && \
  alien -i /rpm/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm && \
  alien -i /rpm/oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm && \
  pecl channel-update pecl.php.net && \
  echo | pecl install oci8-2.2.0 && \
  echo "extension=oci8.so" > /etc/php/7.0/mods-available/oci.ini && \
  ln -s /etc/php/7.0/mods-available/oci.ini /etc/php/7.0/cli/conf.d/30-oci.ini && \
  ln -s /etc/php/7.0/mods-available/oci.ini /etc/php/7.0/fpm/conf.d/30-oci.ini && \
  apt-get remove -y --purge build-essential gcc-6 g++ gcc alien && \
  apt-get autoremove -y --purge && \
  rm -rf /var/lib/apt/lists/*
