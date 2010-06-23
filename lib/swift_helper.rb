
module SwiftHelper
  def self.included(base)
    base.extend SwiftHelper::HelpLinkTo::ClassMethods
  end
end
