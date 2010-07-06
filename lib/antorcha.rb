module Antorcha
  def self.definition title, &block
    builder = DefinitionBuilder.new(title)
    builder.build &block
  end
end

