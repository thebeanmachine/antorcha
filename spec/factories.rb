
Factory.define(:procedure) do |f|
  f.sequence(:title) {|n| "Procedure #{n}"}
end

Factory.define(:instruction) do |f|
  f.sequence(:title) {|n| "Instruction #{n}"}
  f.procedure { Factory(:procedure) }
end

Factory.define :task  do |f|
  f.sequence(:title) {|n| "Task #{n}"}
  f.procedure { Factory(:procedure) }
end

Factory.define :message do |f|
  f.sequence(:title) {|n| "Message #{n}"}
  f.instruction { Factory(:instruction) }
  f.task { Factory(:task) }
  f.body "Dit is de message body"
end

