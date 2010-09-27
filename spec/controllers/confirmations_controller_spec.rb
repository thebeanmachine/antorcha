require 'spec_helper'

describe ConfirmationsController do

  before(:each) do    
    turn_of_devise_and_cancan_because_this_is_specced_in_the_ability_spec
  end
  
  specify { should have_devise_before_filter }

  describe "POST create" do
    before(:each) do
      Delivery.stub(:find).with(mock_delivery.to_param, anything()).and_return(mock_delivery)
      mock_delivery.stub :confirmed=
      mock_delivery.stub :certificate=
    end

    def post_create
      post :create, \
        :organization_id => mock_organization.to_param,
        :delivery_id => mock_delivery.to_param
    end
    
    describe "with valid params" do
      before(:each) do
        mock_delivery.stub :save => true
      end
      
      it "assigns a newly created reception as @delivery" do
        post_create
        assigns[:delivery].should equal(mock_delivery)
      end

      it "only finds deliveries from the given organization" do
        Delivery.should_receive(:find).with(
            mock_delivery.to_param,
            hash_including(
              :conditions => { :organization_id => mock_organization.to_param} )
          ).and_return(mock_delivery)
        post_create
      end

      it "assigns the true to @delivery.confirmed" do
        mock_delivery.should_receive(:confirmed=).with(true)
        post_create
      end
      
      it "redirects to the created delivery" do
        post_create
        response.should redirect_to(delivery_url(mock_delivery))
      end

      
      describe "in production mode" do
        before(:each) do
          Rails.env.stub :production? => true
          
        end

        describe "using ssl" do
          before(:each) do
            request.stub :ssl? => true
          end

          it "assigns the certificate from request.headers[SSL_CLIENT_CERT] to @delivery.certificate" do
            request.env['SSL_CLIENT_CERT'] = 'CERTIFICATE'
            mock_delivery.should_receive(:certificate=).with('CERTIFICATE')
            post_create
          end
        end

        describe "using plain http" do
          before(:each) do
            request.stub :ssl? => false
          end
          it "should raise error if anyone tries to use no encryption" do
            lambda { post_create }.should raise_error
          end
        end
      end

      describe "in development mode" do
        it "assigns a dummy certificate to @delivery.certificate" do
          mock_delivery.should_receive(:certificate=).with('NO CERTIFICATE')
          post_create
        end
      end
    end

    describe "with invalid params" do
      before(:each) do
        mock_delivery.stub :save => false
      end
      
      it "assigns a newly created but unsaved reception as @delivery" do
        post_create
        assigns[:delivery].should equal(mock_delivery)
      end

      it "re-renders the 'new' template" do
        post_create
        response.should render_template('new')
      end
    end
  end

end
