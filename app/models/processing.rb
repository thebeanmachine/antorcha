class Processing
  def self.all
     @processings = []
     path = "#{RAILS_ROOT}/log"
     File.open("#{path}/#{Rails.env}.log").each do |line| 
       @processings << line if (line =~ /Processing TransactionsController#/ || line =~ /Processing MessagesController#/ || line =~ /Processing UsersController#/) 
     end
     @processings.reverse![0..99]
  end
end