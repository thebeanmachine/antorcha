
class Statistic < ActiveResource::Base
  self.site = APP_CONFIG[:olympus_resource]
  self.prefix = '/organizations/:organization_id/'

  def self.push
    unless Identity.count == 0
      Statistic.create \
        :running => (not Worker.all.empty?),
        :version => version,
        :organization_id => Identity.first!.organization_id
    end
  end

private
  def self.version
    File.read File.join(Rails.root, 'VERSION')
  end
end
