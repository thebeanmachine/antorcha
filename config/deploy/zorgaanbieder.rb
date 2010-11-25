
set :deploy_to, "/data/app/zorgaanbieder.thebeanmachine.nl"

role :web, "thebeanmachine.nl"                          # Your HTTP server, Apache/etc
role :app, "thebeanmachine.nl"                          # This may be the same as your `Web` server
role :db,  "thebeanmachine.nl", :primary => true # This is where Rails migrations will run

set :branch, 'maint'
