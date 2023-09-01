FROM  hseeberger/scala-sbt:8u302_1.5.5_2.13.6
WORKDIR /usr/src/app
COPY amqp-publish /usr/local/bin
COPY run.sh ./
RUN chmod +x run.sh
CMD ./run.sh