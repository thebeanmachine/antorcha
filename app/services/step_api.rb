
class StepAPI < ActionWebService::API::Base
  api_method :starting_steps_index, :expects => [Api::Token], :returns => [[Api::Step]]
  api_method :effect_steps_index, :expects => [Api::Token, Api::Message], :returns => [[Api::Step]]
end
