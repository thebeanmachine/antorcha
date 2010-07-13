

module AntorchaHelper
  
  %w[step message definition transaction reaction role organization delivery].each do |model|
    self.class_eval <<-RUBY
      def mock_#{model} name = :default
        @mock_#{model} ||= {}
        @mock_#{model}[name] ||= mock_model(#{model.classify})
      end
      
      def mock_#{model.pluralize} name = :default
        @mock_#{model.pluralize} ||= {}
        @mock_#{model.pluralize}[name] ||= [mock_#{model}(name), mock_#{model}(name)]
      end
    RUBY
  end
  
  %w[message_delivery transaction_cancellation].each do |job|
    self.class_eval <<-RUBY
      def stub_new_#{job}_job
        #{job.classify}Job.stub(:new => mock_#{job}_job)
      end
  
      def mock_#{job}_job
        @mock_#{job}_job ||= mock(#{job.classify}Job)
      end
    RUBY
  end

  %w[worker].each do |model|
    self.class_eval <<-RUBY
      def stub_new_#{model}
        #{model.classify}.stub(:new => mock_#{model})
      end
  
      def mock_#{model}
        @mock_#{model} ||= mock(#{model.classify})
      end
      
      def mock_#{model.pluralize}
        @mock_#{model.pluralize} ||= [mock_#{model}, mock_#{model}]
      end
    RUBY
  end
  
  def act_as who
    session[:user] = [who]
  end

  def mock_search
    @mock_search ||= mock(Searchlogic::Search)
  end

  def stub_new(mocked_model, params = nil)
    s = mocked_model.class.stub(:new)
    s = s.with(params) if params
    s.and_return(mocked_model)
  end

  def stub_create(mocked_model, params = nil)
    s = mocked_model.class.stub(:create)
    s = s.with(params) if params
    s.and_return(mocked_model)
  end

  def stub_new_on(finder, mocked_model, params = nil)
    s = finder.stub(:new)
    s = s.with(params) if params
    s.and_return(mocked_model)
  end
  
  def stub_build_on(finder, mocked_model, params = nil)
    s = finder.stub(:build)
    s = s.with(params) if params
    s.and_return(mocked_model)
  end

  def stub_find_on(finder, mocked_model, params = nil)
    s = finder.stub(:find)
    s = s.with(params) if params
    s.and_return(mocked_model)
  end

  def stub_all(mocked_model)
    mocked_model.class.stub(:all => [mocked_model])
  end

  def stub_find(mocked_model)
    mocked_model.class.stub(:find).with(mocked_model.to_param).and_return(mocked_model)
  end
  
  def stub_find_by model, options
    scope = options.delete :on
    scope ||= model.class

    model.stub options unless model.nil?

    options.each do |key, value|
      scope.stub("find_by_#{key}").with(value).and_return(model)
    end
  end

  def stub_find_by! model, hash
    model.stub hash
    hash.each do |key, value|
      model.class.stub("find_by_#{key}!").with(value).and_return(model)
    end
  end

  def stub_successful_save_for(mocked_model)
    mocked_model.stub(:save => true)
  end

  def stub_unsuccessful_save_for(mocked_model)
    mocked_model.stub(:save => false)
  end

  def stub_authorize!
    controller.stub :authorize! => nil
  end
  
  def expect_authorize how, what
    controller.should_receive(:authorize!).with(how, what)
  end

  def debug(x)
    puts "<div class=\"debug\" style=\"background: #ddd; padding: 1em;\"><pre>"
    puts ERB::Util.html_escape(x)
    puts "</pre></div>"
  end

  def debunk(x)
    puts "<div class=\"debug\" style=\"background: #ddd; padding: 1em;\"><pre>"
    puts ERB::Util.html_escape(x)
    puts "</pre></div>"
  end
  
  
  Spec::Matchers.define :have_before_filter do |expected|
    match do |actual|
      actual.class.before_filters.include?(expected)
    end

    failure_message_for_should do |actual|
      "expected that #{actual} would have a before filter #{expected}"
    end

    failure_message_for_should_not do |actual|
      "expected that #{actual} would not have before filter #{expected}"
    end

    description do
      "have before filter #{expected}"
    end
  end
  
  
  def stub_render_partial
    template.stub(:render).with(hash_including(:partial => anything())).and_return('')
  end
  
  def should_render_partial name
    template.should_receive(:render).with(hash_including(:partial => name))
  end
end

