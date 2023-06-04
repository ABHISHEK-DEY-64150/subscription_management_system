class CustomersController < ApplicationController
  before_action :require_customer_logged_in ,only: [:dashboard]

    def dashboard
      puts notice
      @package = Package.all 
      @duePackages = CustomerSubscription.where(customer_id: session[:customer_id]).where("dues > ?",0);

    end


    def loginCustomer
        customer = Customer.find_by(email:customer_login_params[:email])
        # puts ">>>>>>>>>>>>>>",provider.email
        if customer && customer.authenticate(customer_login_params[:password])
            session[:customer_id] = customer.id 
            redirect_to '/customerDashboard',notice: 'Customer Logged in successfully'
        else
          flash[:login_errors] = ['invalid credentials']
          redirect_to '/'
        end
     
    end

    def destroy
        session[:customer_id] = nil
        redirect_to '/customerlogin'
    end  



    private
    def customer_login_params
      params.require(:logincustomer).permit(:email,:password);
    end  

  
end
