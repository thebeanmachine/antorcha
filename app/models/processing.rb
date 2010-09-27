class Processing
  def self.all
     @processings = []
     path = "#{RAILS_ROOT}/log"
     File.open("#{path}/#{Rails.env}.log").each do |line| 
       @processings << line if (line =~ /Completed/ || line =~ /Rendering/ || line =~ /Processing/) 
     end
     @processings.reverse![0..99]
  end
  
  def self.human_name options = {}
    "Logboek"
  end
  
end