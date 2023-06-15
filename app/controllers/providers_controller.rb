class ProvidersController < ApplicationController
    before_action :require_provider_logged_in ,only: [:dashboard, :userregister , :addPackages , :add_Package]
    before_action :require_provider_logged_in ,only: [:dashboard, :userregister , :addPackages , :add_Package]
    def home
         if Currentcustomer.customer.present?
          redirect_to "/customerDashboard"
         elsif Current.provider.present?
          redirect_to "/providerDashboard"
         end
         puts alert
    end

    def signIn
      
    end

    def signIn
      @provider = Provider.new
    end

    def dashboard
        puts notice
    end

    def addPackages
      @package = Package.new
      @package = Package.new

    end

    def userregister
      @customer = Customer.new
      @customer = Customer.new
    end

    def registerredCustomers
      
      @regCustomers = Current.provider.customers.all
      
    end

    def singleCustomer
      @singleCustomer = Customer.find(params[:id])
      @subcribedPackages = CustomerSubscription.where(customer_id: params[:id])

    end

    def subscription_destroy
      puts "unsubscribe an =========>>>>>",params             
      @customerSubscriptionrecord = CustomerSubscription.find(params[:id])
      puts "unsubscribe an article =========>>>>>",   @customerSubscriptionrecord 
      @customerId  = @customerSubscriptionrecord.customer_id
      @customerSubscriptionrecord.destroy
      redirect_to showCustomerDetails_path(@customerId)
    end

    def customerRegister
        puts params
        @customer = Customer.new(customer_params)
        @customer.paymentDues = 0
        @customer.provider_id = session[:provider_id]
        if @customer.save
         redirect_to '/providerDashboard'
        else
        #  flash[:register_errors] = @customer.errors.full_messages
        #  redirect_to '/'
        render :userregister, status: :unprocessable_entity
        end
    end

    def loginprovider
        @provider = Provider.find_by(email:params[:email])
        # puts ">>>>>>>>>>>>>>",provider.email
        if @provider.present? && @provider.authenticate(params[:password])
            session[:provider_id] = @provider.id 
            redirect_to '/providerDashboard',notice: 'Provider Logged in successfully'
        else
          # flash[:login_errors] = ['invalid credentials']
          # redirect_to '/'
          flash.now[:alert] = 'Invalid email/password combination'
          render :signIn ,status: :unprocessable_entity
        end
     
      end

      def destroy
        session[:provider_id] = nil
        redirect_to '/'
      end  



    def add_Package
        puts "========",session[:provider_id]
        @package = Package.new(packages_params)
        @package.provider_id = session[:provider_id]
        # puts "========",session[:provider_id]
        if @package.save
         redirect_to '/providerDashboard'
        else

        render :addPackages, status: :unprocessable_entity
        end
    end    

  # private
  # def login_params
  #   params.require(:provider).permit(:email,:password);
  # end  

  private
  def customer_params
      params.require(:customer).permit(:name,:email,:password,:password_confirmation);
  end 

  private
  def packages_params
      params.require(:package).permit(:description, :price, :servicetype);
  end 

end
