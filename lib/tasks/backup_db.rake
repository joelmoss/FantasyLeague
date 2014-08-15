task :dumpdb do
  `heroku pgbackups:capture`
  url = `heroku pgbackups:url`
  `curl -o latest.dump #{url}`
  `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U joelmoss -d fantasyfootball_development latest.dump`
end