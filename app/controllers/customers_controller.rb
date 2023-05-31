class CustomersController < ApplicationController
  before_action :require_customer_logged_in ,only: [:dashboard]

    def dashboard
      puts notice
      @package = Package.all 
    end


    def internetPackagesavailable
        @internetPackage = Package.where("servicetype = 'Internet'")
        @customersInternet = CustomerSubscription.where(customer_id: session[:customer_id],servicetype:"Internet")
    end

    def addmySubscription
        
        puts "=====subs====>",params
        puts "ppppp--->",params[:packagedescription]
        @mysub = CustomerSubscription.new
        @mysub.servicetype = params[:servicetype]
        @mysub.packagedescription = params[:packagedescription]
        @mysub.price = params[:price]
        @mysub.package_id = params[:package_id]
        @mysub.customer_id = session[:customer_id]
        customer = Customer.find_by(id: session[:customer_id])
        @mysub.provider_id = customer.provider_id

        if @mysub.save
          redirect_to "/customerDashboard",notice: 'Customer subscribed successfully'
        else
          

          flash[:subscription_errors] = "Already subscribed"
          
          redirect_to "/internetPackagesavailable"
          # puts @mysub.errors.full_messages
          # render :internetPackagesavailable, status: :unprocessable_entity, content_type: "text/html"

        end
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

    private 
    def customerSub_params
        params.require(:mysub).permit(:servicetype , :packagedescription, :price, :package_id)
    end
  
end
