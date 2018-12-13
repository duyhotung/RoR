### Introduction
##### Capistrano
Capistrano is a remote server automation tool. It supports the scripting and execution of arbitrary tasks, and includes a set of sane-default deployment workflows.
##### Circle CI
Its a Continuous integration platform that supports automated build and test from every commit. Improve team productivity, efficiency, happiness. Find problems and solve them, quickly. Release higher quality, more stable products.
##### Capistrano + Circle CI
This combination will give us the fully automated CI/CD platform.
### Prerequisite
1. Gitub account
2. Sample RoR source code
3. Server to be deployed with port 22 open and Ruby on Rails ready
4. List of software should be ready in servers:
    * Ruby 2.5.0
    * Rails 5.2.0
    * ImageMagick 6.7.8-9
    * Redis 3.2.11
    * Yarn 1.7.0
    * Nginx 1.12.1
    * Node.js 6.14.3
    * Unicorn 5.4.0
### Setup
##### Circle CI
###### 1. Setup account
* Visit the CircleCI signup page and click “Start with GitHub”. You will need to give CircleCI access to your GitHub account to run your builds.
* Next, you will be given the option of following any projects you have access to that are already building on CircleCI (this would typically apply to developers connected to a company or organization’s GitHub account). On the next screen, you’ll be able to add the repo you just created as a new project on CircleCI.
* To add your new repo, ensure that your GitHub account is selected in the dropdown in the upper-left, find the repository you just created below, and click the Setup project button next to it.
* On the next screen, you’re given some options for configuring your project on CircleCI. Leave everything as-is for now and just click the Start building button a bit down the page on the right.
###### 2. Configuration
* Add a .circleci folder at the top of your project’s master branch
* Add a config.yml file inside the .circleci folder.
* Add the following sample contents to your config.yml file (it depends on project)
```
version: 2
jobs:
  build:
    working_directory: ~/RoR1
    docker:
      - image: circleci/ruby:2.5.0-node
        environment:
          RAILS_ENV: test
          BASTION_HOST: 13.231.95.80
          BASTION_USER: ec2-user
      - image: circleci/mysql:5.7.18
        environment:
          MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'
          MYSQL_ROOT_HOST: '%'
      - image: redis:3.2.10
      - image: circleci/node:8.9
    steps:
      - checkout
      - type: cache-restore
        key: bundle-{{ checksum "Gemfile.lock" }}
      - run: bundle install --path vendor/bundle
      - type: cache-save
        key: bundle-{{ checksum "Gemfile.lock" }}
        paths:
          - vendor/bundle
      - run: bundle exec rails db:create
      - run: bundle exec rake db:migrate
      - run: yarn install
      - type: shell
        command: |
          bundle exec rspec --profile 10 \
                            --format RspecJunitFormatter \
                            --out /tmp/test-results/rspec.xml \
                            --format progress \
                            $(circleci tests glob "spec/**/*_spec.rb" | circleci tests split --split-by=timings)

      - type: store_test_results
        path: /tmp/test-results
      - add_ssh_keys:
          fingerprints:
            - "80:2d:a6:b8:db:95:4a:da:97:58:60:a4:8c:cb:57:24"
```
##### Capistrano
###### 1. Installation
* The following command will install the latest released capistrano v3 revision:
`$ gem install capistrano`
###### 2. Configuration
* Configuration variables can be either global or specific to your stage.
  * global
`config/deploy.rb`
  * stage specific: 
`config/deploy/<stage_name>.rb`
###### 3. Prepare your application
* Move secrets out of the repository.
Ideally one should remove config/database.yml to something like config/database.yml.example. You and your team should copy the example file into place on their development machines, under Capistrano. This leaves the database.yml filename unused so that we can symlink the production database configuration into place at deploy time.
The original database.yml should be added to the .gitignore
* Initialize Capistrano in your application.
```
$ cd my-project
$ cap install
```
This will create a bunch of files, the important ones are:
```
├── Capfile
├── config
│   ├── deploy
│   │   ├── production.rb
│   │   └── staging.rb
│   └── deploy.rb
└── lib
    └── capistrano
            └── tasks
```
* Configure your server addresses in the generated files
Example of config/deploy/<stage_name>.rb:
```
set :stage, :staging
set :rails_env, 'staging'
set :branch, 'master'
set :bundle_without, %i[test]

set :sidekiq_options_per_process, ['-q default -q cron -q mailers']
set :sidekiq_processes, 1
set :sidekiq_role, %i[worker]

server '172.50.50.175', user: 'ec2-user', roles: %w[web app worker]
```
* Set the shared information in deploy.rb
Example of deploy.rb:
```
if ENV['VIA_BASTION']
  require 'net/ssh/proxy/command'
  # Use a default host for the bastion, but allow it to be overridden
  bastion_host = ENV['BASTION_HOST']
  # Use the local username by default
  bastion_user = ENV['BASTION_USER'] || ENV['USER']
  # Configure Capistrano to use the bastion host as a proxy
  ssh_command = "ssh -o 'StrictHostKeyChecking=no' #{bastion_user}@#{bastion_host} -CW %h:%p"
  set :ssh_options, proxy: Net::SSH::Proxy::Command.new(ssh_command)
end

repo_url = 'git@github.com:duyhotung/RoR.git'
application = 'ror'
#local_secret_key_path = 'config/secrets.yml.key'

set :application, application
set :repo_url, repo_url
append :linked_dirs, 'log', 'tmp/sockets', 'tmp/pids', 'tmp/cache', 'vendor/bundle', 'public/system'
#append :linked_files, local_secret_key_path
#append :linked_files, 'config/master.key'

set :default_env, path: '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
set :keep_releases, 5
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :deploy_to, '/var/www'
set :log_level, :debug
set :preload_app, true

namespace :deploy do
  desc 'ridgepole apply'
  task ridgepole_apply: [:set_rails_env] do
    on primary(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'ridgepole:apply'
        end
      end
    end
  end
  after 'deploy:updated', 'deploy:ridgepole_apply'

  task :restart do
    invoke 'unicorn:restart'
  end
  after 'deploy:publishing', 'deploy:restart'
end
```
##### Commit, deploy and debug
* We can define in .circleci/config.yml where to deploy when there is commit in github.
* Depends on the branch, circleCI will deploy to stage server via Capistrano accordingly 
```
- deploy:
          name: Deploy
          command: |
            if [ "${CIRCLE_BRANCH}" == "develop" ]; then
              bundle exec cap staging deploy
            elif [ "${CIRCLE_BRANCH}" == "master" ]; then
              bundle exec cap production deploy
            else
              bundle exec cap integration deploy
            fi
```
* Commit to github and monitor in circleCI console for building and deploying progress.
* Check the error log return if the build is failed for details and fixing in both console and your registered email address. 
