
def debug(x)
  puts "<div class=\"debug\" style=\"background: #ddd; padding: 1em;\"><pre>"
  puts ERB::Util.html_escape(x)
  puts "</pre></div>"
end

Given /^the VIS(\d+) transaction definition is available$/ do |arg1|
  #dit is een fixture die extern is geimplementeerd, nl. op http://tankenberg.heroku.communicator
end

Given /^I am logged in as a "([^\"]*)"$/ do |user_type|
  u = Factory.create(:user)
  u.user_type = user_type
  u.save
  visit path_to("the sign in page")
  fill_in('user_username', :with => u.username)
  fill_in('user_password', :with => 'asdfasdf')
  click_button("Inloggen")
end


Given /^I have a transaction "([^\"]*)"$/ do |title|
  @transaction = Factory.create(:transaction, :title => title)
end

Given /^I have an? (incoming|outgoing)? ?message "([^\"]*)" for step "([^\"]*)"$/ do |direction,title,step|
  m = Factory.create(:message, :title => title, :step => Step.find_by_title(step), :transaction => Factory.create(:transaction, :title => "Transaction"))
  m.incoming = (direction == 'incoming')
  m.save
end

Given /^I have an? (incoming|outgoing)? ?message "([^\"]*)"$/ do |direction,title|
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

Given /^I am a communicator$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^the "([^"]*)" example$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
