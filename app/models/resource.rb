
class Resource < HyperactiveResource
  self.site = APP_CONFIG[:olympus_resource]
  self.site = 'http://localhost:3001' if Rails.env.development? and ENV['USER'] == 'daan'
end
