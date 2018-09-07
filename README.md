# RailsMySQL
Sample Application on Ruby on Rails 5 using MySQL

## Install MySQL

1. Download `MAMP` and install
2. Add `mysql2` gem to rails project
3. Set adapter to `mysql2` in `database.yml` 
4. By default, the username and password for MAMP MySQL are both `root` 
5. Use `rails db:create` to create the database, database name is case-sensitive and set in `database.yml` 
6. Once model is generated, use `rails db:migrate` to migrate the table structure