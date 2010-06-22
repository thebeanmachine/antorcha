module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # instruction definition in web_instructions.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /the messages page/
      messages_path

    when /the "([^\"]+)" message page/
      message_path(Message.find_by_title($1))

    when /the "([^\"]+)" procedure page/
      procedure_path(Procedure.find_by_title($1))

    # the new instruction message page of "Hello world"
    when /the new instruction message page of \"([^\"]+)\"/
      new_instruction_message_path(Instruction.find_by_title($1))

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
