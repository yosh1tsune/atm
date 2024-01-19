FROM ruby:3.2-alpine

RUN mkdir /app

WORKDIR /app

COPY . /app

RUN bundle install