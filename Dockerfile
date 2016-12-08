## Docker file to build app as container

FROM centos:centos7
MAINTAINER "Eric Martinez" <emartinez@usgs.gov>
LABEL dockerfile_version="v0.2.0"

# Set this so builds work from within DOI network
COPY etc/DOIRootCA2.crt /etc/pki/ca-trust/source/anchors/DOIRootCA2.crt

# Update current system packages and install custom repos for packages later
RUN yum upgrade -y && \
    yum updateinfo -y && \
    yum install -y \
      ca-certificates \
      autoconf \
      gcc \
      g++ \
      libc-dev \
      make \
      pkg-config \
      curl \
      libedit2 \
      libxml2 \
      xz-utils \
      which && \
    update-ca-trust enable && \
    update-ca-trust extract


# Install primary necessary packages
RUN yum install -y \
      httpd \
      php \
      php-pear \
      php-devel \
      cairo-devel \
      java-1.7.0-openjdk-headless

# Cairo
RUN pecl channel-update pecl.php.net && \
    printf "\n" | pecl install channel://pecl.php.net/cairo-0.3.2 && \
    printf "; Enable Cairo extension module\nextension=cairo.so" > /etc/php.d/cairo.ini


# copy application (ignores set in .dockerignore)
COPY html/. /var/www/html/

WORKDIR /var/www/html
ENTRYPOINT ["httpd"]
CMD ["-DFOREGROUND"]
