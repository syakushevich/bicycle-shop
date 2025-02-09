# Dockerfile
FROM ruby:3.2

# Install dependencies:
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set an environment variable to disable bundler warnings:
ENV BUNDLE_FORCE_RUBY_PLATFORM=true

WORKDIR /app

# Copy Gemfile and Gemfile.lock and install gems.
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code.
COPY . .

# Expose port 3000 and run the Rails server.
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
