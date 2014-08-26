task :dumpdb do
  `heroku pgbackups:capture`
  `curl -o latest.dump \`heroku pgbackups:url\``
  `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U joelmoss -d fantasyfootball_development latest.dump`
end