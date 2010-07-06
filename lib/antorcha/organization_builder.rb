
module Antorcha
  class OrganizationBuilder < Struct.new(:title)
    def build &block
      #puts "Building organization #{title}"

      @organization = Organization.find_by_title title
      @organization = Organization.create :title => title unless @organization
      
      block.call self
      unless @organization.save
        raise "#{@organization.errors.full_messages}"
      end
    end

    def destination_url url
      @organization.url = url
    end

    def fulfills roles
      roles.each do |definition, roles|
        definition = Definition.find_by_title! definition
        roles = Array roles
        roles.each do |role|
          @organization.roles << definition.roles.find_by_title!(role)
        end
      end
    end
  end
end