namespace :db do
  desc 'Sets up application'
  task :roll do
    system('rake db:create && rake db:migrate && rake db:seed')
  end
end
