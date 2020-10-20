# 第一層基底
FROM php:7.4.10-fpm-alpine

LABEL maintainer="mk201309@gmail.com"

# 安装必要的扩展 扩展posix已经默认开启 还需要pcntl sockets
RUN docker-php-ext-install pcntl sockets 

# 安装event event扩展需要依赖libevent-dev
RUN apk add libevent-dev autoconf gcc g++ make \
    && sh -c '/bin/echo -e "no\nyes\n/usr\nno\nyes\nno\nyes\nno" | pecl install event' \
    # 由於擴展加載的順序問題 event 需改名稱才能使 sockets 在 event 之前載入
    && docker-php-ext-enable --ini-name zz-event.ini event

# 安装redis扩展 不需要可以不安装
RUN pecl install redis \
     && docker-php-ext-enable redis

# 安装pdo_mysql redis扩展 不需要可以不安装
RUN docker-php-ext-install pdo_mysql

# 清理文件
RUN docker-php-source delete

RUN apk add git unzip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# docker terminal 顯示 LOG
# RUN mkdir -p /home/log/ \
#     && ln -sf /dev/stdout /home/log/access.log \
#     && ln -sf /dev/stdout /home/log/error.log
