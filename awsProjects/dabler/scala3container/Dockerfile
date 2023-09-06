FROM attemptthisonline/scala3
WORKDIR /usr/src/app
COPY amqp-publish /usr/local/bin
RUN  chmod +x /usr/local/bin/amqp-publish
COPY run.sh ./
RUN chmod +x run.sh
CMD ./run.sh