FROM w3dev/php-fpm-composer

MAINTAINER Lasse Enoe Barslund <lasse_enoe@hotmail.com>



# Install dependensis and configure PHP moduls
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        # Install GD lib dependensis
        libfreetype6-dev \
        libmcrypt-dev \

        # Install IMagick dependensis
        ghostscript \
        libgs-dev \
        imagemagick \
        libmagickwand-dev \

    # Cleanup apt-get
    && rm -rf /tmp/* /var/tmp/* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*



# Configure and install php modules
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) iconv gd mysqli soap zip opcache



# Install IMagick from PECL
ENV IMAGICK_VERSION 3.4.3
RUN pecl install imagick-${IMAGICK_VERSION} \
    && docker-php-ext-enable imagick



# Install APCu from PECL
ENV APCU_VERSION 5.1.8
RUN pecl install apcu-${APCU_VERSION}



# Copy custom configuration
COPY custom.ini /usr/local/etc/php/conf.d/custom.ini



WORKDIR /var/www