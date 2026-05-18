source "https://rubygems.org"

ruby "3.4.3"

gem "rails", "~> 8.0.0"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"
gem "solid_queue"
gem "bootsnap", require: false
gem "rack-cors"

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "pry-rails"
end

group :development do
  gem "listen", "~> 3.8"
end

group :test do
  gem "minitest-rails"
  gem "minitest-reporters"
end

gem "tzinfo-data", platforms: %i[windows jruby]
