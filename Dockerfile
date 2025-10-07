# Official Nextcloud - Manfree Technologies Institute
FROM nextcloud:latest

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    imagemagick \
    smbclient \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP settings for better performance
RUN { \
    echo 'memory_limit=512M'; \
    echo 'upload_max_filesize=10G'; \
    echo 'post_max_size=10G'; \
    echo 'max_execution_time=3600'; \
    echo 'max_input_time=3600'; \
    echo 'opcache.enable=1'; \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=10000'; \
    echo 'opcache.revalidate_freq=1'; \
    echo 'opcache.save_comments=1'; \
} > /usr/local/etc/php/conf.d/nextcloud.ini

# Copy custom entrypoint
COPY docker-entrypoint.sh /usr/local/bin/custom-entrypoint.sh
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["apache2-foreground"]
