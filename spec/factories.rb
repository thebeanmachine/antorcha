
Factory.define(:task) do |f|
  f.sequence(:title) {|n| "Task #{n}"}
end

Factory.define(:step) do |f|
  f.sequence(:title) {|n| "Step #{n}"}
  f.task { Factory(:task) }
end

Factory.define :message do |f|
  f.sequence(:title) {|n| "Message #{n}"}
  f.step { Factory(:step) }
  f.body "Dit is de message body"
end

