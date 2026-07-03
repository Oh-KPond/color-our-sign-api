ARG RUBY_VERSION=3.4.3

# ─── Dev stage (used by docker-compose) ────────────────────────────────────────
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS dev

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev curl && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV BUNDLE_PATH=/usr/local/bundle \
    RAILS_LOG_TO_STDOUT=1

COPY Gemfile Gemfile.lock* ./
RUN bundle install

COPY . .

CMD ["bin/rails", "server", "-b", "0.0.0.0"]

# ─── Build stage ───────────────────────────────────────────────────────────────
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS build

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

COPY Gemfile Gemfile.lock* ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY . .
RUN bundle exec bootsnap precompile app/ lib/

# ─── Final stage (production / Fly.io) ────────────────────────────────────────
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS final

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libpq-dev curl && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV BUNDLE_PATH=/usr/local/bundle \
    RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=1

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails log tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
