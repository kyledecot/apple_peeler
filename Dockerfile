FROM ruby:alpine

WORKDIR apple_peeler

COPY ./ ./


RUN apk add --update build-base libffi-dev git && \
    gem install bundler && \
    bundle install




