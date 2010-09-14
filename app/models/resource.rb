
class Resource < HyperactiveResource
  self.site = APP_CONFIG[:olympus_resource]
  self.site = 'http://tankenberg.heroku.com' if Rails.env.production? and ENV['USER'] == 'daan'
end
