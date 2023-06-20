class ProvidersController < ApplicationController
    before_action :require_provider_logged_in ,only: [:dashboard, :userregister , :addPackages , :add_Package]
    before_action :update_dues, only:[:singleCustomer]
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
      @DuePackages = CustomerSubscription.where(customer_id: params[:id]).where("dues > ?",0);

    end


    def generate_bill

      @singleCustomer = Customer.find(params[:id])
      provider_id = session[:provider_id]
      provider_email=Provider.find(provider_id).email

      price=params[:price].to_i
      dues=params[:dues].to_i
      packagedescription=params[:description]

      p "params Checked : ",params

      sLnumber= SecureRandom.random_number(10000000)



      pdf = Receipts::Receipt.new(
        details: [
          ["Serial ","#{sLnumber}" ],
          ["Date paid", "....../....../........"],
          ["Payment method", "Cash"]
        ],
        company: {
          name: "#{provider_id}",
          address: "123 Fake Street\nNew York City, NY 10012",
          email: provider_email
        },
        recipient: [
          "<b>Customer Details</b>",
          ["Customer ID : #{@singleCustomer.id}"],
          ["Customer Name : #{@singleCustomer.name}"],
          "Their Address",
          "City, State Zipcode",
          "#{@singleCustomer.email}"
        ],
        line_items: [
          ["<b>Package Name</b>", "<b>Unit Cost</b>", "<b>Dues</b>", "<b>Amount</b>"],
          [packagedescription, price, dues, "$#{price*dues}"],
          [nil, nil, "Subtotal", "$#{price*dues}"],
          [nil, nil, "Total", "$#{price*dues}"],
          [nil, nil, "<b>Amount to be paid</b>", "$#{price*dues}"]
        ],
        footer: "Thanks for your business. Please contact us if you have any questions."
      )
      send_data pdf.render, filename: 'receipt.pdf', type: 'application/pdf', disposition: 'inline'


    end

    def newSubscriptions
        @all_packages = Package.where(provider_id: session[:provider_id])
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
        #  flash[:register_errors] = @package.errors.full_messages
        #  redirect_to '/'
        render :addPackages, status: :unprocessable_entity
        end
    end    

  private
  def customer_params
      params.require(:customer).permit(:name,:email,:password,:password_confirmation);
  end 

  private
  def packages_params
      params.require(:package).permit(:description, :price, :servicetype);
  end 




  def update_dues
    @duePackages = CustomerSubscription.where(customer_id: params[:id]);
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

end
