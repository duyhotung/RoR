source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.2.0'

# 注意：rufus-schedulerのバージョンは3.4.2でないとsidekiq-cronが動かない
gem 'rufus-scheduler', '3.4.2'
gem 'whenever', require: false

gem 'active_hash', '~> 2.1.0'
gem 'activerecord-import'
gem 'authlogic', '~> 3.7' # 注意 >3.7は不具合あり
gem 'aws-sdk', '~> 3.0.1'
gem 'aws-sdk-rails', '~> 2.0.1'
gem 'banken', '~> 1.0.2'
gem 'breadcrumbs_on_rails', '~> 3.0.1'
gem 'browser', '~> 2.5.3'
gem 'coffee-rails', '~> 4.2'
gem 'config', '~> 1.7.0'
gem 'draper', '~> 3.0.1'
gem 'enum_help', '~> 0.0.17'
gem 'exception_notification', '~> 4.2.2'
gem 'fastimage', '~> 2.1.3'
gem 'font-awesome-sass', '~> 5.0.13'
gem 'fullcalendar-rails', '~> 3.4.0.0'
gem 'google-analytics-rails', '~> 1.1.1'
gem 'image_processing', '~> 1.2.0'
gem 'jbuilder', '~> 2.5'
gem 'jquery-datatables', '~> 1.10.16'
gem 'jquery-rails', '~> 4.3.3'
gem 'jquery-ui-rails', '~> 6.0.1'
gem 'kaminari', '~> 1.1.1'
gem 'mechanize', '~> 2.7.5'
gem 'meta-tags', '~> 2.9.0'
gem 'mini_magick', '~> 4.8.0'
gem 'momentjs-rails', '~> 2.20.1'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'nokogiri', '~> 1.8.2'
gem 'paranoia', '~> 2.4.1'
gem 'pry-rails', '~> 0.3.6'
gem 'ransack', '~> 1.8.8'
gem 'redis-namespace', '~> 1.6.0'
gem 'redis-rails', '~> 5.0.2'
gem 'ridgepole', '~> 0.7.2'
gem 'roda', '~> 3.8.0'
gem 'rubocop', '~> 0.56.0', require: false
gem 'sass-rails', '~> 5.0'
gem 'sassc-rails', '~> 1.3.0'
gem 'seed-fu', '~> 2.3.9'
gem 'sendgrid-actionmailer', '~> 0.2.1'
gem 'shrine', '~> 2.11.0'
gem 'sidekiq', '~> 5.1.3'
gem 'sidekiq-cron', '~> 0.6.3'
gem 'simple_form', '~> 4.0.1'
gem 'slack-notifier', '~> 2.3.2'
gem 'slim-rails', '~> 3.1.3'
gem 'spreadsheet', '~> 1.1.7'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn', '~> 5.4.0'
gem 'unicorn-worker-killer', '~> 0.4.4'
gem 'parser', '2.5.0.0'
gem 'turbolinks'

group :test do
  gem 'autodoc', '~> 0.6.2'
  gem 'database_cleaner', '~> 1.7.0'
  gem 'guard', '~> 2.14.2'
  gem 'guard-rspec', '~> 4.7.3', require: false
  gem 'rails-controller-testing', '~> 1.0.2'
  gem 'rspec', '~> 3.7.0'
  gem 'rspec-html-matchers', '~> 0.9.1'
  gem 'rspec-json_matcher', '~> 0.1.6'
  gem 'rspec-rails', '~> 3.7.2'
  gem 'rspec_junit_formatter', '~> 0.3.0'
  gem 'timecop', '~> 0.9.1'
end

group :integration, :development, :test do
  gem 'byebug', '~> 10.0.2', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 3.1.0'
  gem 'factory_bot_rails', '~> 4.10.0'
  gem 'ffaker', '~> 2.9.0'
  gem 'fuubar', '~> 2.3.1'
  gem 'i18n-tasks', '~> 0.9.21'
  gem 'poltergeist', '~> 1.18.0'
  gem 'pre-commit', '~> 0.38.1'
  gem 'rails-erd', '~> 1.5.2'
  gem 'selenium-webdriver', '~> 3.12.0'
  gem 'shoulda-matchers', '~> 3.1.2'
  gem 'slim_lint', '~> 0.15.1'
  gem 'test-queue', '~> 0.4.2'
end

group :integration, :development do
  gem 'brakeman', '~> 4.3.0', require: false
  gem 'bullet', '~> 5.7.5'
  gem 'html2slim', '~> 0.2.0'
  gem 'rack-mini-profiler', '~> 1.0.0', require: false
  gem 'rails-admin-scaffold', '~> 0.1.0'
  gem 'rails_best_practices', '~> 1.19.2'
  gem 'simplecov', '~> 0.16.1', require: false
  gem 'spring', '~> 2.0.2'
  gem 'spring-commands-rspec', '~> 1.0.4'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'thin', '~> 1.7.2'
end

group :development do
  gem 'web-console', '~> 3.6.2'
end

group :integration, :development, :staging do
  gem 'letter_opener_web', '~> 1.3.4'
  gem 'rack-dev-mark', '~> 0.7.7'
end

group :deploy do
  gem 'capistrano', '~> 3.10.2'
  gem 'capistrano-bundler', '~> 1.3.0'
  gem 'capistrano-rails', '~> 1.3.1'
  gem 'capistrano-rails-console', '~> 2.2.1'
  gem 'capistrano-rbenv', '~> 2.1.3'
  gem 'capistrano-sidekiq', '~> 1.0.2'
  gem 'capistrano3-unicorn', '~> 0.2.1'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
