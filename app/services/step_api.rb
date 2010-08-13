
class StepAPI < ActionWebService::API::Base
  api_method :starting_step_index, :expects => [Api::Token], :returns => [[Api::Step]]
end
