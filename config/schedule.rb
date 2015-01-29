env 'PATH', ENV['PATH']
set :job_template, "bash -l -i -c ':job'"
set :output, { error: 'error.log', standard: 'cron.log' }

every 2.hours do
  rake "db:seed"
end

every 3.hours do
  runner "Weather.new"
end