

Given /^I have a (starting)? step "([^"]*)"$/ do |starting, title|
  Factory.create(:step, :title => title, :start => (starting == 'starting'))
end

Given /^I have a message "([^"]*)" for step "([^"]*)"$/ do |title,step|
  Factory.create(:message, :title => title, :step => Step.find_by_title(step))
end
