class StepService < ActionWebService::Base  
  web_service_api StepAPI

  before_invocation :check_token

  def starting_steps_index token
    Step.to_start_with
  end
  
  def effect_steps_index token, api_message
    message = Message.find(api_message.id)
    message.effect_steps
  end

private

  def check_token method_name, args
    token = args[0]
    return [false, "No token specified"] unless token
    unless token.username == 'aap' and token.password == 'noot'
      return [false, "Access denied"]
    end
  end

end
