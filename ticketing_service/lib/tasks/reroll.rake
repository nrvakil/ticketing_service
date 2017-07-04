namespace :db do
  desc 'Resets application'
  task :reroll do
    system('rake db:drop && rake db:create && rake db:migrate && rake db:seed')
  end
end
