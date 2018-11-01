namespace :ridgepole do
  SCHEMA_FILE_PATH = 'db/schemas/Schemafile'.freeze

  desc 'ridgepole apply dry run'
  task apply_dry_run: :environment do
    exec_command("-f #{SCHEMA_FILE_PATH} --apply --dry-run")
  end

  desc 'ridgepole apply'
  task apply: :environment do
    exec_command("-f #{SCHEMA_FILE_PATH} --apply")
  end

  desc 'ridgepole export'
  task export: :environment do
    exec_command("-o #{SCHEMA_FILE_PATH} --export --split")
  end

  private

  def exec_command(option_str)
    # ridgepoleが暗号化されたdatabase.ymlを読めないためここで復号化する
    host = "127.0.0.1" 
    password = ""

    db_config = Rails.configuration.database_configuration
    username = db_config[Rails.env]['username']
    database = db_config[Rails.env]['database']
    conf_path = "mysql2://#{username}@#{host}:3306/#{database}"
    if Rails.env.development? || Rails.env.test?
      conf_path = "mysql2://#{username}@127.0.0.1:3306/#{database}"
    end
    p "bundle exec ridgepole -c #{conf_path} -E #{Rails.env} --dump-with-default-fk-name #{option_str}"
    result = system "bundle exec ridgepole -c #{conf_path} -E #{Rails.env} --dump-with-default-fk-name #{option_str}"
    raise "Ridgepole Error - env #{Rails.env} conf_path #{conf_path} options: #{option_str}" unless result
  end
end
