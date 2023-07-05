class ProvidersController < ApplicationController
  before_action :require_provider_logged_in, only: [:dashboard, :userregister, :addPackages, :add_Package]
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
    @DuePackages = CustomerSubscription.where(customer_id: params[:id]).where("dues > ?", 0)
  end

  def dues
    @dues = CustomerSubscription.where("dues > ?", 0).order(dues: :desc)
  end

  def generate_bill
    @singleCustomer = Customer.find(params[:id])
    provider_id = session[:provider_id]
    provider_email = Provider.find(provider_id).email

    price = params[:price].to_i
    dues = params[:dues].to_i
    packagedescription = params[:description]

    p "params Checked : ", params

    sLnumber = SecureRandom.random_number(10000000)

    pdf = Receipts::Receipt.new(
      details: [
        ["Serial ", "#{sLnumber}"],
        ["Date paid", "....../....../........"],
        ["Payment method", "Cash"],
      ],
      company: {
        name: "#{provider_id}",
        address: "123 Fake Street\nNew York City, NY 10012",
        email: provider_email,
      },
      recipient: [
        "<b>Customer Details</b>",
        ["Customer ID : #{@singleCustomer.id}"],
        ["Customer Name : #{@singleCustomer.name}"],
        "Their Address",
        "City, State Zipcode",
        "#{@singleCustomer.email}",
      ],
      line_items: [
        ["<b>Package Name</b>", "<b>Unit Cost</b>", "<b>Dues</b>", "<b>Amount</b>"],
        [packagedescription, price, dues, "$#{price * dues}"],
        [nil, nil, "Subtotal", "$#{price * dues}"],
        [nil, nil, "Total", "$#{price * dues}"],
        [nil, nil, "<b>Amount to be paid</b>", "$#{price * dues}"],
      ],
      footer: "Thanks for your business. Please contact us if you have any questions.",
    )
    send_data pdf.render, filename: "receipt.pdf", type: "application/pdf", disposition: "inline"
  end

  def customerRegister
    puts params
    @customer = Customer.new(customer_params)
    @customer.paymentDues = 0
    @customer.provider_id = session[:provider_id]
    pack_id = Package.find_by(provider_id: session[:provider_id], description: params[:package_selector], servicetype: params[:service_selector])
    # puts ">>>>>>>>>>>>>>",pack_id.price
    if @customer.save
      @mysub = CustomerSubscription.new
      @mysub.servicetype = pack_id.servicetype
      @mysub.packagedescription = pack_id.description
      @mysub.price = pack_id.price
      @mysub.package_id = pack_id.id
      @mysub.customer_id = @customer.id
      @mysub.provider_id = pack_id.provider_id
      @mysub.dues = 1
      @mysub.subscriptiondate = params[:subscription_date]
      if @mysub.save
      #  redirect_to "/providerDashboard"
      redirect_to showCustomerDetails_path(@customer.id)
      end 
    else
      render :userregister, status: :unprocessable_entity
    end
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
    params.require(:customer).permit(:name, :email, :password, :password_confirmation, :address)
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
