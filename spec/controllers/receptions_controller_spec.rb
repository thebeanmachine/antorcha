require 'spec_helper'

describe ReceptionsController do

  before(:each) do    
    turn_of_devise_and_cancan_because_this_is_specced_in_the_ability_spec
  end
  
  specify { should have_devise_before_filter }

  def mock_reception(stubs={})
    @mock_reception ||= mock_model(Reception, stubs)
  end

  describe "GET index" do
    it "assigns all receptions as @receptions" do
      Reception.stub(:find).with(:all).and_return([mock_reception])
      get :index
      assigns[:receptions].should == [mock_reception]
    end
  end

  describe "GET show" do
    it "assigns the requested reception as @reception" do
      Reception.stub(:find).with("37").and_return(mock_reception)
      get :show, :id => "37"
      assigns[:reception].should equal(mock_reception)
    end
  end

  describe "POST create" do
    before(:each) do
      Reception.stub(:new).and_return(mock_reception)
      mock_reception.stub :certificate=
      mock_reception.stub :content=
    end

    def post_create
      post :create, :message => 'CONTENT'
    end
    
    describe "with valid params" do
      before(:each) do
        mock_reception.stub :save => true
      end
      
      it "assigns a newly created reception as @reception" do
        post_create
        assigns[:reception].should equal(mock_reception)
      end

      it "assigns the message hash to @reception.content" do
        mock_reception.should_receive(:content=).with('CONTENT')
        post_create
      end
      
      describe "in production mode" do
        before(:each) do
          Rails.env.stub :production? => true
          request.stub :https? => true
        end

        it "assigns the certificate from ENV[SSL_CLIENT_CERT] to @reception.certificate" do
          ENV.stub(:[]).with('SSL_CLIENT_CERT').and_return('CERTIFICATE')
          mock_reception.should_receive(:certificate=).with('CERTIFICATE')
          post_create
        end
      end

      describe "in development mode" do
        it "assigns a dummy certificate to @reception.certificate" do
          mock_reception.should_receive(:certificate=).with('NO CERTIFICATE')
          post_create
        end
      end


      it "redirects to the created reception" do
        Reception.stub(:new).and_return(mock_reception(:save => true))
        post :create, :reception => {}
        response.should redirect_to(reception_url(mock_reception))
      end
    end

    describe "with invalid params" do
      before(:each) do
        mock_reception.stub :save => false
      end
      
      it "assigns a newly created but unsaved reception as @reception" do
        Reception.stub(:new).with({'these' => 'params'}).and_return(mock_reception(:save => false))
        post :create, :reception => {:these => 'params'}
        assigns[:reception].should equal(mock_reception)
      end

      it "re-renders the 'new' template" do
        Reception.stub(:new).and_return(mock_reception(:save => false))
        post :create, :reception => {}
        response.should render_template('new')
      end
    end
  end

end
