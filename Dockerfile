FROM postgres:14-alpine

RUN apk update \
	&& apk add coreutils \
	&& apk add postgresql-client \
	&& apk add python3 py3-pip && pip3 install --upgrade pip && pip3 install awscli \
	&& apk add openssl \
	&& apk add curl \
	&& curl -L --insecure https://github.com/odise/go-cron/releases/download/v0.0.6/go-cron-linux.gz | zcat > /usr/local/bin/go-cron && chmod u+x /usr/local/bin/go-cron \
	&& apk del curl \
	&& rm -rf /var/cache/apk/*

ENV POSTGRES_DATABASE **None**
ENV POSTGRES_HOST **None**
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER **None**
ENV POSTGRES_PASSWORD **None**
ENV POSTGRES_EXTRA_OPTS ''
ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION us-west-1
ENV S3_PREFIX 'backup'
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no
ENV SCHEDULE **None**
ENV ENCRYPTION_PASSWORD **None**
ENV DELETE_OLDER_THAN **None**

RUN apk add dos2unix

ADD run.sh run.sh
ADD backup.sh backup.sh
RUN dos2unix run.sh
RUN dos2unix backup.sh

CMD ["sh", "run.sh"]
