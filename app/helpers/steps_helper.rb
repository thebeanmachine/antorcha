module StepsHelper
  include SwiftHelper::HelpLinkTo
  
  help_can_link_to :step

  def link_to_definition_steps definition
    if can? :index, Step
      link_to Step.human_name(:count => 2), definition_steps_path(@definition)
    end
  end


end
