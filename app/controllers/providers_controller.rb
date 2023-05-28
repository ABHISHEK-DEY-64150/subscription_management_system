class ProvidersController < ApplicationController
    before_action :require_provider_logged_in ,only: [:dashboard, :userregister]
    def home
         puts alert
    end

    def dashboard
        puts notice
    end

    def userregister

    end

    def customerRegister
        puts params
        customer = Customer.new(customer_params)
        customer.paymentDues = 0
        customer.provider_id = session[:provider_id]
        if customer.save
         redirect_to '/providerDashboard'
        else
         flash[:register_errors] = customer.errors.full_messages
         redirect_to '/'
        end
    end

    def loginprovider
        provider = Provider.find_by(email:login_params[:email])
        # puts ">>>>>>>>>>>>>>",provider.email
        if provider && provider.authenticate(login_params[:password])
            session[:provider_id] = provider.id 
            redirect_to '/providerDashboard',notice: 'Admin Logged in successfully'
        else
          flash[:login_errors] = ['invalid credentials']
          redirect_to '/'
        end
     
      end

      def destroy
        session[:provider_id] = nil
        redirect_to '/'
      end  

  private
  def login_params
    params.require(:loginprovider).permit(:email,:password);
  end  

  private

  def customer_params
      params.require(:customer).permit(:name,:email,:password,:password_confirmation);
  end 
end
