require_relative '../models/reviews'

class ProvidersController < ApplicationController
  before_action :require_provider_logged_in, only: [:dashboard, :userregister, :addPackages, :add_Package, :registerredCustomers, :singleCustomer, :dues]
  before_action :update_dues, only: [:singleCustomer]

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

  def dashboard
    @customer_count = Customer.where(provider_id: session[:provider_id]).count
    @package_count = Package.where(provider_id: session[:provider_id]).count
    @subscription_count = CustomerSubscription.where(provider_id: session[:provider_id]).count
    @internetPackage_count = Package.where(provider_id: session[:provider_id]).where("servicetype = 'Internet'").count
    @cablePackage_count = Package.where(provider_id: session[:provider_id]).where("servicetype = 'Cable'").count
    @paperPackage_count = Package.where(provider_id: session[:provider_id]).where("servicetype = 'Paper'").count
    puts notice
  end

  def addPackages
    @package = Package.new
  end

  def userregister
    @customer = Customer.new
  end

  def registerredCustomers
    @regCustomers = Current.provider.customers.all
  end

  def singleCustomer
    @singleCustomer = Customer.find(params[:id])
    @subcribedPackages = CustomerSubscription.where(customer_id: params[:id])
    @DuePackages = Bill.where(customer_id: params[:id]).where(status: 0)
  end

  def dues
    @dues = CustomerSubscription.where("dues > ?", 0).order(dues: :desc)
  end


  def customerRegister
    puts params
    @customer = Customer.new(customer_params)
    @customer.paymentDues = 0
    @customer.provider_id = session[:provider_id]
    # @customer.provider_id = "someenn"
    pack_id = Package.find_by(provider_id: session[:provider_id], description: params[:package_selector], servicetype: params[:service_selector])
    # puts ">>>>>>>>>>>>>>",pack_id.price
      ActiveRecord::Base.transaction do
        @customer.save!
        @mysub = CustomerSubscription.new
        @mysub.servicetype = pack_id.servicetype
        @mysub.packagedescription = pack_id.description
        @mysub.price = pack_id.price
        @mysub.package_id = pack_id.id
        # @mysub.package_id = "sdhfdzusvgfihdklshbrgefgi"
        @mysub.customer_id = @customer.id
        @mysub.provider_id = pack_id.provider_id
        @mysub.dues = 1
        @mysub.subscriptiondate = params[:subscription_date]
        @mysub.save!
        redirect_to showCustomerDetails_path(@customer.id)
      end
      
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:transactionErr] = "Transaction Rollback occured: #{e.message}"
      puts "*******************rollback occured :  #{e.message}"     
      render :userregister, status: :unprocessable_entity
    rescue StandardError => e
      flash.now[:transactionErr] = "Transaction Rollback occured: #{e.message}"
      puts "*******************rollback occured for standered error: #{e.message}"     
      render :userregister, status: :unprocessable_entity  
  end



  def service_type_selection
    first_selector_value = params[:first_selector_value]

    # Use the first_selector_value to find the options for the second selector
    @second_selector_options = Package.where(provider_id: session[:provider_id], servicetype: first_selector_value).pluck(:description)

    respond_to do |format|
      format.html { render partial: "second_selector_options" } # Create a partial view for the second selector options
    end
  end

  def loginprovider
    @provider = Provider.find_by(email: params[:email])
    # puts ">>>>>>>>>>>>>>",provider.email
    if @provider.present? && @provider.authenticate(params[:password])
      session[:provider_id] = @provider.id
      redirect_to "/providerDashboard", notice: "Provider Logged in successfully"
    else
      # flash[:login_errors] = ['invalid credentials']
      # redirect_to '/'
      flash.now[:alert] = "Invalid email/password combination"
      render :signIn, status: :unprocessable_entity
    end
  end

  def destroy
    session[:provider_id] = nil
    redirect_to "/"
  end

  def showreviews
    @reviews = Review.where(provider_id: session[:provider_id])
  end

  def add_Package
    puts "========", session[:provider_id]
    @package = Package.new(packages_params)

    @package.provider_id = session[:provider_id]
    # puts "========",session[:provider_id]
    if @package.save
      redirect_to "/providerDashboard"
    else
      #  flash[:register_errors] = @package.errors.full_messages
      #  redirect_to '/'
      render :addPackages, status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :password, :password_confirmation, :address, :avatar)
  end

  private

  def packages_params
    params.require(:package).permit(:description, :price, :servicetype)
  end

  def update_dues
    @duePackages = CustomerSubscription.where(customer_id: params[:id])
    if @duePackages.nil?
      redirect_to "/customerDashboard"
    else
      @duePackages.each do |pack|
        update_time = pack.updated_at
        current_time = Time.now

        min_diff = ((current_time - update_time) / 60)
        puts "days_difffffffffffff", min_diff, "pack.dues", pack.dues

        if min_diff >= 1 && pack.dues.present?
          days = pack.dues + min_diff
          puts "days_difffffffffffff2222222", min_diff, "pack.dues", pack.dues
          pack.update(dues: days)
        else
          pack.update(dues: pack.dues)
        end
      end
    end
  end
end
