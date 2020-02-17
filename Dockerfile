FROM ubuntu:19.10
MAINTAINER Vitalii Shvets <wuddi@wuddi.in.ua>
ENV REFRESHED_AT 2020-02-18
ENV HTTPD_PREFIX /etc/apache2
ENV TZ Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# install OS packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y sudo python-pip python inotify-tools wget curl apache2 libapache2-mod-php7.3 php7.3-gd php7.3-json php7.3-mysql php7.3-curl php7.3-mbstring php7.3-intl php-imagick php7.3-xml php7.3-zip software-properties-common php-redis
RUN pip install youtube-dl
RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
RUN chmod a+rx /usr/local/bin/youtube-dl
RUN apt-get update && apt-get install -y sudo ffmpeg nano
RUN phpenmod mcrypt
RUN a2enmod rewrite && a2enmod headers && a2enmod env && a2enmod dir && a2enmod setenvif && a2enmod ssl && a2enmod mime
RUN apt-get clean


# Remove default site, configs, and mods not needed
WORKDIR $HTTPD_PREFIX
RUN rm -f \
	sites-enabled/000-default.conf \
	conf-enabled/serve-cgi-bin.conf \
	mods-enabled/autoindex.conf \
	mods-enabled/autoindex.load

EXPOSE 80
WORKDIR /var/www
# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND
