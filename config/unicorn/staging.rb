worker_processes 1
timeout 300
preload_app true

shared_path = File.expand_path('shared')
listen File.expand_path('tmp/sockets/unicorn.sock', shared_path)
pid File.expand_path('tmp/pids/unicorn.pid', shared_path)

stderr_path File.expand_path('log/unicorn.log')
stdout_path File.expand_path('log/unicorn.log')

before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = File.expand_path('Gemfile')
  byebug
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end

