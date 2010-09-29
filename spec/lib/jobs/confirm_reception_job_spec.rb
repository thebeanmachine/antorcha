require 'spec_helper'

describe Jobs::ConfirmReceptionJob do
  subject do
    stub_find mock_reception
    Jobs::ConfirmReceptionJob.new mock_reception.to_param
  end

  describe "confirmation" do
    it "should post the confirmation message" do
      resource_method_is_specced_in_resource_mixin_spec
      mock_resource.should_receive(:post).with('', hash_including(:content_type => :xml, :accept => :xml))
      subject.perform
    end
  end

  def resource_method_is_specced_in_resource_mixin_spec
    subject.stub :resource => mock_resource
  end
  
  def mock_resource
    @mock_resource ||= mock(RestClient::Resource)
  end

end
