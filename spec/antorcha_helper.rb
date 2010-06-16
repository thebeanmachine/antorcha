

module AntorchaHelper

  %w[step message].each do |model|
    self.class_eval <<-RUBY
      def mock_#{model}
        @mock_step ||= mock_model(#{model.classify})
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

  def stub_all(mocked_model)
    mocked_model.class.stub(:all => [mocked_model])
  end

  def stub_find(mocked_model)
    mocked_model.class.stub(:find).with(mocked_model.to_param).and_return(mocked_model)
  end

  def debug(x)
    puts "<div class=\"debug\" style=\"background: #ddd; padding: 1em;\"><pre>"
    puts ERB::Util.html_escape(x)
    puts "</pre></div>"
  end
end

