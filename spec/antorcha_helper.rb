

module AntorchaHelper

  %w[instruction message procedure].each do |model|
    self.class_eval <<-RUBY
      def mock_#{model}
        @mock_#{model} ||= mock_model(#{model.classify})
      end
      
      def mock_#{model.pluralize}
        @mock_#{model.pluralize} ||= [mock_#{model}, mock_#{model}]
      end
    RUBY
  end

  def mock_search
    @mock_search ||= mock(Searchlogic::Search)
  end

  def stub_new(mocked_model, params = nil)
    s = mocked_model.class.stub(:new)
    s = s.with(params) if params
    s.and_return(mocked_model)
  end

  def stub_new_on(finder, mocked_model, params = nil)
    s = finder.stub(:new)
    s = s.with(params) if params
    s.and_return(mocked_model)
  end

  def stub_all(mocked_model)
    mocked_model.class.stub(:all => [mocked_model])
  end

  def stub_find(mocked_model)
    mocked_model.class.stub(:find).with(mocked_model.to_param).and_return(mocked_model)
  end

  def stub_successful_save_for(mocked_model)
    mocked_model.stub(:save => true)
  end

  def stub_unsuccessful_save_for(mocked_model)
    mocked_model.stub(:save => false)
  end

  def stub_new_delivery_job
    MessageDeliveryJob.stub(:new => mock_delivery_job)
  end
  
  def mock_delivery_job
    @mock_delivery_job ||= mock(MessageDeliveryJob)
  end

  def debug(x)
    puts "<div class=\"debug\" style=\"background: #ddd; padding: 1em;\"><pre>"
    puts ERB::Util.html_escape(x)
    puts "</pre></div>"
  end
end

