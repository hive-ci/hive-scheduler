desc 'Setup Hive Scheduler'
task :setup do
  sh 'rake db:create'
  sh 'rake db:migrate'
  sh 'rake db:seed'
  sh 'rake assets:precompile'
end
