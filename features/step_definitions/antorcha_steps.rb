

Given /^I have a (starting)? step "([^"]*)"$/ do |starting, title|
  Factory.create(:step, :title => title, :start => (starting == 'starting'))
end

