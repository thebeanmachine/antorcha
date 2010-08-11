
Factory.define(:definition) do |f|
  f.sequence(:title) {|n| "Definition #{n}"}
end

Factory.define(:step) do |f|
  f.sequence(:title) {|n| "Step #{n}"}
  f.definition { Factory(:definition) }
end

Factory.define :transaction  do |f|
  f.sequence(:title) {|n| "Transaction #{n}"}
  f.definition { Factory(:definition) }
end

Factory.define :message do |f|
  f.sequence(:title) {|n| "Message #{n}"}
  f.step { mock_step }
  f.transaction { mock_transaction }
  f.body "Dit is de message body"
end

Factory.define :role do |f|
  f.sequence(:title) {|n| "Role #{n}"}
end

Factory.define :organization do |f|
  f.sequence(:title) {|n| "Organization #{n}"}
end
