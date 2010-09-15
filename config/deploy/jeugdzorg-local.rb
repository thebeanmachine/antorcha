
set :deploy_to, "/home/daan/www/app/jeugdzorg.local"

role :web, "jeugdzorg.local"                          # Your HTTP server, Apache/etc
role :app, "jeugdzorg.local"                          # This may be the same as your `Web` server
role :db,  "jeugdzorg.local", :primary => true # This is where Rails migrations will run

set :user, 'daan'
set :branch, 'https'
