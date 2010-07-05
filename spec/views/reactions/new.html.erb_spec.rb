require 'spec_helper'

describe "/reactions/new.html.erb" do
  include ReactionsHelper

  it "calls form partial" do
    should_render_partial 'form'
    render
  end
end
