
def debug(x)
  puts "<div class=\"debug\" style=\"background: #ddd; padding: 1em;\"><pre>"
  puts ERB::Util.html_escape(x)
  puts "</pre></div>"
end

Given /^I am an advisor$/ do
  Given "I am on the messages page"
  Given "I press \"Act as advisor\""
end

Given /^I am a sender$/ do
  Given "I am on the messages page"
  Given "I press \"Act as sender\""
end


Given /^the "Bakkerij" example$/ do
  definition = Factory(:definition, :title => 'Bakkerij')
    
  kneden = Factory( :step, :title => 'Deeg kneden', :start => true, :definition => definition )
  bakvorm = Factory( :step, :title => 'In bakvorm stoppen', :definition => definition )
  oven = Factory( :step, :title => 'In de oven', :definition => definition )
  afkoelen = Factory( :step, :title => 'Afkoelen', :definition => definition )
  verkopen = Factory( :step, :title => 'Verkopen', :definition => definition )
  
  [kneden, bakvorm, oven, afkoelen, verkopen].inject { |l,r| r.causes << l; r.save; r }
  
end

Given /^I have a definition "([^\"]*)"$/ do |title|
  @definition = Factory.create(:definition, :title => title)
end

Given /^I have a (starting )?step "([^\"]*)"$/ do |starting, title|
  Factory.create :step,
    :title => title,
    :start => (starting == 'starting ')
end

Given /^I have a (starting )?step "([^\"]*)" in "([^\"]*)"$/ do |starting, title, definition|
  Factory.create :step,
    :title => title,
    :start => (starting == 'starting '),
    :definition => Definition.find_by_title!(definition)
end


Given /^I have an? (incoming|outgoing)? ?message "([^\"]*)" for step "([^\"]*)"$/ do |direction,title,step|
  m = Factory.create(:message, :title => title, :step => Step.find_by_title(step))
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


Given /^roles titled (.+)$/ do |titles|
  #pending # express the regexp above with the code you wish you had
  titles.split(', ').each do |title|
    Role.create!(:title => title)
  end
end

When /^I create a step Melding with role Consulent$/ do
  visit definition_steps_path(@definition)
  click_link "New Step"
  fill_in "Titel", :with => "Uber Coole Stap"
  check "Consulent"
  click_button "Maak Stap"
end


Then /^Melding should be in the Consulent role$/ do
  # pending # express the regexp above with the code you wish you had
end

