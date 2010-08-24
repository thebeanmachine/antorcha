class StepService < AuthenticatedService
  web_service_api StepAPI

  before_invocation :can_invoke?

  def starting_steps_index token
    Step.starting_steps
  end
  
  def effect_steps_index token, api_message
    message = Message.find(api_message.id)
    message.effect_steps
  end
  
private
  def can_invoke? method_name, args
    authorize! :index, Step
  end

end
