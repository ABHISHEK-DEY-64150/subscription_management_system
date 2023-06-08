class CustomersController < ApplicationController
  # before_action :update_dues  
  # prepend_before_action :require_customer_logged_in,only: :update_dues
  before_action :require_customer_logged_in, :update_dues, only:[:dashboard]
 
    def dashboard
      puts notice
      # @package = Package.all 
      @customerspackage = CustomerSubscription.where(customer_id: session[:customer_id])
      # @DuePackages = CustomerSubscription.where(customer_id: session[:customer_id]).where("dues > ?",0);

    end
    
    def duePackages
      @DuePackages = CustomerSubscription.where(customer_id: session[:customer_id]).where("dues > ?",0);
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

    def update_dues
      @duePackages = CustomerSubscription.where(customer_id: session[:customer_id]);
      if @duePackages.nil?
         redirect_to "/customerDashboard"
      else
      @duePackages.each do |pack|
          update_time = pack.updated_at
          current_time = Time.now

          min_diff = ((current_time - update_time)/60)
          puts "days_difffffffffffff",min_diff,"pack.dues",pack.dues 

          if min_diff >=1 && pack.dues.present?
             days = pack.dues + min_diff
             puts "days_difffffffffffff2222222",min_diff,"pack.dues",pack.dues 
             pack.update(dues:days)
          else
            pack.update(dues:pack.dues)
          end
      end
    end

    end

    private
    def customer_login_params
      params.require(:logincustomer).permit(:email,:password);
    end  

  
end
