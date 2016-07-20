FROM index.alauda.cn/library/centos:6.6

#RUN curl http://mirrors.aliyun.com/repo/Centos-6.repo >  /etc/yum.repos.d/CentOS-Base.repo && yum makecache && \
#	curl http://mirrors.aliyun.com/repo/epel-6.repo > /etc/yum.repos.d/epel.rep

RUN rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm

RUN yum makecache 
RUN yum install --skip-broken -y nginx php php-fpm php-redis php-mbstring && \
	yum install -y git php-pear php-devel gcc gcc-c++ autoconf automake  && \
	yum clean all

RUN yum install -y pcre pcre-devel
RUN yum install -y python-pip && \
	yum clean all && \
	pip install supervisor supervisor-stdout && \
	pip install --upgrade setuptools

# add php yaf ext
RUN yum install -y git
WORKDIR /php-yaf
RUN git clone -b php5 https://github.com/laruence/php-yaf /tmp/php-yaf
	cd /tmp/php-yaf && \
	phpize && \
	./configure --with-php-config=/usr/bin/php-config && \
	make && make install && \
	echo 'extension=yaf.so' >> /etc/php.ini && \
	cd / && rm -rf /tmp/php-yaf
