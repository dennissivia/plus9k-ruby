FROM ruby:2.6.3-slim-stretch

COPY . .

RUN gem install --no-document bundler
RUN bundle install --without development test

ENTRYPOINT ["/bin/plus9k"]
