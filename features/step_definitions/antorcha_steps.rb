
def debug(x)
  puts "<div class=\"debug\" style=\"background: #ddd; padding: 1em;\"><pre>"
  puts ERB::Util.html_escape(x)
  puts "</pre></div>"
end

Given /^I have a definition "([^\"]*)"$/ do |title|
  Factory.create(:definition, :title => title)
end

Given /^I have a (starting)? step "([^\"]*)"$/ do |starting, title|
  Factory.create :step,
    :title => title,
    :start => (starting == 'starting')
end

Given /^I have a (starting)? step "([^\"]*)" in "([^\"]*)"$/ do |starting, title, definition|
  Factory.create :step,
    :title => title,
    :start => (starting == 'starting'),
    :definition => Definition.find_by_title!(definition)
end


Given /^I have a message "([^\"]*)" for step "([^\"]*)"$/ do |title,step|
  Factory.create(:message, :title => title, :step => Step.find_by_title(step))
end

Given /^I have a (incoming|outgoing)? ?message "([^\"]*)"$/ do |direction,title|
  m = Factory.create(:message, :title => title)
  m.incoming = (direction == 'incoming')
  m.save
end


Then /^(?:|I )should not see submit button "([^"]*)"$/ do |button|
  page.should have_no_xpath("//input[@type='submit' and @value=#{Capybara::XPath.escape(button)}]")
end


When 'the system processes jobs' do
  Delayed::Worker.new.work_off
end

When /^I confirm a js popup on the next step$/ do
  page.evaluate_script("window.alert = function(msg) { return true; }")
  page.evaluate_script("window.confirm = function(msg) { return true; }")
end
