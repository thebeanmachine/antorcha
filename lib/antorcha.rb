module Antorcha
  def self.definition title, &block
    builder = DefinitionBuilder.new(title)
    builder.build &block
  end
  
  def self.organization title, &block
    builder = OrganizationBuilder.new(title)
    builder.build &block
  end
end

