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
#  task upload_secret_key: [:set_rails_env] do
#    on roles(:web) do
#      execute :mkdir, '-p', "#{shared_path}/config"
#      if File.exist? local_secret_key_path
#        upload! local_secret_key_path, "#{shared_path}/config/secrets.yml.key"
#      end
#    end
#  end
  before 'deploy:check:linked_files'#, 'deploy:upload_secret_key'

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

