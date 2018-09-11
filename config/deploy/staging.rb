set :stage, :staging
set :rails_env, 'staging'
set :branch, 'master'
set :bundle_without, %i[test]

set :sidekiq_options_per_process, ['-q default -q cron -q mailers']
set :sidekiq_processes, 1
set :sidekiq_role, %i[worker]

server '172.50.50.175', user: 'ec2-user', roles: %w[web app worker]

