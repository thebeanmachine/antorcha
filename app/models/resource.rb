
class Resource < HyperactiveResource
  if ENV["USER"] =~ /robin/
    self.site = "http://localhost:3010"
  else    
    self.site = "http://tankenberg.heroku.com"
  end
end
