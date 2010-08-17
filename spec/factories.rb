Factory.define :transaction  do |f|
  f.sequence(:title) {|n| "Transaction #{n}"}
  f.definition { Definition.find_by_title("VIS2") }
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

Factory.define :user do |f|
  f.sequence(:username) {|n| "user#{n}"}
  f.password "asdfasdf"
  f.password_confirmation "asdfasdf"
  f.sequence(:email) {|n| "user#{n}@example.com"}
end