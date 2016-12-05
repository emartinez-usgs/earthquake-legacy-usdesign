## Docker file to build app as container

FROM centos:centos7
MAINTAINER "Eric Martinez" <emartinez@usgs.gov>
LABEL dockerfile_version="v0.2.0"

# Set this so builds work from within DOI network
COPY etc/DOIRootCA2.crt /etc/pki/ca-trust/source/anchors/DOIRootCA2.crt

# Update current system packages and install custom repos for packages later
RUN yum upgrade -y && \
    yum updateinfo -y && \
    yum install -y ca-certificates && \
    update-ca-trust enable && \
    update-ca-trust extract && \
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
    rpm -Uvh http://rpms.famillecollet.com/enterprise/7/remi/x86_64/remi-release-7.2-1.el7.remi.noarch.rpm && \
    yum clean all -y


# Install primary necessary packages
RUN yum install -y \
      httpd \
      php55w \
      java-1.7.0-openjdk-headless && \
    yum --enablerepo=remi install -y php55-php-pecl-cairo && \
    yum clean all -y


# copy application (ignores set in .dockerignore)
COPY html/. /var/www/html/

WORKDIR /var/www/html
ENTRYPOINT ["httpd"]
CMD ["-DFOREGROUND"]
