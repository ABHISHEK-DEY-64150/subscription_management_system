class ProvidersController < ApplicationController
    before_action :require_provider_logged_in ,only: [:dashboard]
    def home
         puts alert
    end

    def dashboard
        puts notice
    end

    def loginprovider
        provider = Provider.find_by(email:login_params[:email])
        # puts ">>>>>>>>>>>>>>",provider.email
        if provider && provider.authenticate(login_params[:password])
            session[:provider_id] = provider.id 
            redirect_to '/adminDashboard',notice: 'Admin Logged in successfully'
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
end
