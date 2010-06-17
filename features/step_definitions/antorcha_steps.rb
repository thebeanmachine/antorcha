
Given /^I have a task "([^"]*)"$/ do |title|
  Factory.create(:task, :title => title)
end


Given /^I have a (starting)? step "([^"]*)"$/ do |starting, title|
  Factory.create(:step, :title => title, :start => (starting == 'starting'))
end

Given /^I have a message "([^"]*)" for step "([^"]*)"$/ do |title,step|
  Factory.create(:message, :title => title, :step => Step.find_by_title(step))
end

Then /^(?:|I )should not see submit button "([^"]*)"$/ do |button|
  page.should have_no_xpath("//input[@type='submit' and @value=#{Capybara::XPath.escape(button)}]")
end
