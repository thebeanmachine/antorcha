
Given /^I have a procedure "([^"]*)"$/ do |title|
  Factory.create(:procedure, :title => title)
end

Given /^I have a (starting)? instruction "([^"]*)"$/ do |starting, title|
  Factory.create :instruction,
    :title => title,
    :start => (starting == 'starting')
end

Given /^I have a message "([^"]*)" for instruction "([^"]*)"$/ do |title,instruction|
  Factory.create(:message, :title => title, :instruction => Instruction.find_by_title(instruction))
end

Given /^I have a message "([^"]*)"$/ do |title|
  Factory.create(:message, :title => title)
end


Then /^(?:|I )should not see submit button "([^"]*)"$/ do |button|
  page.should have_no_xpath("//input[@type='submit' and @value=#{Capybara::XPath.escape(button)}]")
end
