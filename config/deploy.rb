#if ENV['VIA_BASTION']
#  require 'net/ssh/proxy/command'

  # Use a default host for the bastion, but allow it to be overridden
#  bastion_host = ENV['BASTION_HOST']

  # Use the local username by default
#  bastion_user = ENV['BASTION_USER'] || ENV['USER']

  # Configure Capistrano to use the bastion host as a proxy
#  ssh_command = "ssh -o 'StrictHostKeyChecking=no' #{bastion_user}@#{bastion_host} -CW %h:%p"
#  set :ssh_options, proxy: Net::SSH::Proxy::Command.new(ssh_command)
#end

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
set :rails_env, 'staging'


namespace :deploy do
#  task upload_secret_key: [:set_rails_env] do
#    on roles(:web) do
#      execute :mkdir, '-p', "#{shared_path}/config"
#      if File.exist? local_secret_key_path
#        upload! local_secret_key_path, "#{shared_path}/config/secrets.yml.key"
#      end
#    end
#  end
#  before 'deploy:check:linked_files', 'deploy:upload_secret_key'

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
  after 'deploy:updating', 'deploy:ridgepole_apply'

  task :restart do
    invoke 'unicorn:restart'
  end
  after 'deploy:publishing', 'deploy:ridgepole_apply'
  after 'deploy:published', 'deploy:restart'
end

