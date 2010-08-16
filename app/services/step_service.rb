class StepService < AuthenticatedService
  web_service_api StepAPI

  def starting_steps_index token
    Step.to_start_with
  end
  
  def effect_steps_index token, api_message
    message = Message.find(api_message.id)
    message.effect_steps
  end
end
