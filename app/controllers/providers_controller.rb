class ProvidersController < ApplicationController
    before_action :require_provider_logged_in ,only: [:dashboard, :userregister , :addPackages , :add_Package]
    def home
         if Currentcustomer.customer.present?
          redirect_to "/customerDashboard"
         end
         puts alert
    end

    def signIn
      
    end

    def dashboard
        puts notice
    end

    def addPackages
      @package = Package.new

    end

    def userregister
      @customer = Customer.new
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
        #  flash[:register_errors] = @package.errors.full_messages
        #  redirect_to '/'
        render :addPackages, status: :unprocessable_entity
        end
    end    

  private
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
