module TasksHelper
  include SwiftHelper
  
  help_link_to :task
  
  def button_to_task_cancellation task
    button_to "Cancel Task", task_cancellation_path(task), :method => :post, :confirm => 'Are you sure?'
  end
end
