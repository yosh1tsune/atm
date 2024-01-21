FROM ruby:3.2.2-alpine

RUN apk update && apk upgrade

RUN apk add --update --no-cache build-base

RUN mkdir /app
WORKDIR /app

COPY . /app

RUN gem update --system

RUN bundle install
