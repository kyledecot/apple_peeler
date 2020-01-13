FROM ruby:alpine

ENV WORKDIR=/apple_peeler

WORKDIR $WORKDIR

VOLUME $WORKDIR

COPY ./ ./

RUN apk add --update build-base libffi-dev less git && \
    gem install bundler && \
    bundle install

