class PaymentsController < ApplicationController
  before_action :require_customer_logged_in, :update_dues, only:[:payhistory]
  before_action :require_provider_logged_in, only:[:bills]
  def payment
    # @unpaidpack = CustomerSubscription.find(params[:id])

    @unpaidpack = Bill.find(params[:id])

    # @pay = Payment.new
    # @pay = Payment.new
  end

  def paymenthistory
    @payhistory = Bill.where(customer_id: session[:customer_id],status: 1).order(created_at: :desc)
  end

  def generate_pdf
    html = render_to_string(template: "example.pdf.erb", layout: false)

    pdf_file = WickedPdf.new.pdf_from_string(html)

    document = Document.new
    document.pdf_data = pdf_file
    document.save

    redirect_to document_path(document)
  end

  def download_pdf
    document = Payment.find(params[:id])
    send_data document.invoicepdf, filename: "document.pdf", type: "application/pdf", disposition: "attachment"
  end

  # def makePayment
  #   p "=====subs====>", params
  #   # puts "ppppp--->",params[:packagedescription]
  #   @pay = Payment.new
  #   @pay.servicetype = params[:servicetype]
  #   @pay.packagedescription = params[:packagedescription]
  #   @pay.price = params[:price]
  #   @pay.dues = params[:dues]
  #   @pay.amount = params[:amount]
  #   @pay.customer_id = session[:customer_id]
  #   customer_name = Customer.find(@pay.customer_id).name
  #   customer_email = Customer.find(@pay.customer_id).email
  #   customersub = CustomerSubscription.find(params[:id])
  #   @pay.package_id = customersub.package_id
  #   @pay.provider_id = customersub.provider_id
  #   provider_email = Provider.find(@pay.provider_id).email
  #   @pay.subscription_id = params[:id]
  #   @pay.timestamp = Time.now
  #   @pay.card = params[:card]

  #   h1 = session[:customer_id].to_s
  #   h2 = params[:card].to_s
  #   h3 = @pay.timestamp.to_s
  #   h4 = @pay.amount.to_s
  #   h5 = @pay.dues.to_s

  #   combined = h1 + h2 + h3 + h4 + h5

  #   hash = Digest::SHA256.hexdigest(combined)[0, 10]

  #   @pay.txid = hash

  #   r = Receipts::Receipt.new(
  #     details: [
  #       ["Transaction ID", hash],
  #       ["Date paid", Date.today],
  #       ["Payment method", "Online"],
  #     ],
  #     company: {
  #       name: "Example, LLC",
  #       address: "123 Fake Street\nNew York City, NY 10012",
  #       email: provider_email,
  #     },
  #     recipient: [
  #       "<b>Customer Details</b>",
  #       ["Customer ID : #{@pay.customer_id}"],
  #       ["Customer Name : #{customer_name}"],
  #       "Their Address",
  #       "City, State Zipcode",
  #       customer_email,
  #     ],
  #     line_items: [
  #       ["<b>Item</b>", "<b>Unit Cost</b>", "<b>Quantity</b>", "<b>Amount</b>"],
  #       ["Subscription", "$#{@pay.price}", "#{@pay.dues}", "$#{@pay.amount}"],
  #       [nil, nil, "Subtotal", "$#{@pay.amount}"],
  #       [nil, nil, "Tax", "5%"],
  #       [nil, nil, "Total", "$#{@pay.amount * 1.05}"],
  #       [nil, nil, "<b>Amount paid</b>", "$#{@pay.amount * 1.05}"],
  #     ],
  #     footer: "Thanks for your business. Please contact us if you have any questions.",
  #   )

  #   @pay.invoicepdf = r.render
  #   ActiveRecord::Base.transaction do
  #     if @pay.save
  #       duePackages = CustomerSubscription.where(id: params[:id])
  #       duePackages.update(dues: 0)
  #       redirect_to "/paymenthistory", notice: "Payment done"
  #     else
  #       #  flash[:payment_errors] = "payment error"
  #       render :payment, @pay => @pay
  #     end
  #   end
  # end

  def gen_monthly_bill
    p = Provider.find(session[:provider_id])
    @customer_of_provider = p.customers.all
    @customer_of_provider.each do |c|
      @all_packs = c.customer_subscriptions.all
      @all_packs.each do |pack|
        @bill_new = Bill.new
        @bill_new.provider_id = p.id
        @bill_new.customer_id = c.id
        @bill_new.package_id = pack.id
        @bill_new.packdescription = pack.packagedescription
        @bill_new.price = pack.price
        @bill_new.fine = 0
        @bill_new.amount = @bill_new.price
        @bill_new.status = 0
        @bill_new.date = Date.current.beginning_of_month
        # @bill_new.date = Date.today.prev_month(4).beginning_of_month
        @bill_new.due_date = Date.current.end_of_month
        @bill_new.save
      end
    end
    redirect_to "/bills"
  end

  def getbills
    month = params[:month]
    year = params[:year]
    puts "month => ", month, year
    if month.present? && year.present?
      dat = Date.new(year.to_i, month.to_i, 1)
      @your_bills = Bill.where(date: dat).order("status ASC")
      # @your_bills = Bill.where("extract(month from date) = ? AND extract(year from date) = ?", month.to_i, year.to_i)
    else
      @currmonth = Date.current.beginning_of_month
      @your_bills = Bill.where(provider_id: session[:provider_id], date: @currmonth).order("status ASC")
      # @your_bills = Bill.where(provider_id: session[:provider_id]).order("status ASC")
    end
    render partial: "bills_partial", locals: { your_bills: @your_bills }
  end

  def bills
  end

  def generate_bill
    @bill = Bill.find(params[:id])
    @cus = Customer.find(@bill.customer_id)
    provider_id = @cus.provider_id
    provider_email = Provider.find(provider_id).email

    packid = @bill.package_id
    price = params[:price].to_i
    date = params[:date]
    puts "date: ", date
    month = date.to_time.strftime("%B")
    year = date.to_time.strftime("%Y")
    due_date = params[:due_date]
    packagedescription = params[:packdescription]
    amount = params[:amount]
    st = ""
    if @bill.status == 0
      st = "Due"
    else
      st = "paid"
    end

    p "params Checked : ", params

    # sLnumber = SecureRandom.random_number(10000000)
    # sLnumber =

    pdf = Receipts::Receipt.new(
      details: [
        # if @bill.txid.present?
        # ["TxId: ", "#{@bill.txid}"],
        # end
        ["Month", "#{month},#{year}"],
        ["Pay within", "#{due_date}"],
        ["Payment method", "Cash"],
      ],
      company: {
        name: "#{provider_id}",
        address: "123 Fake Street\nNew York City, NY 10012",
        email: provider_email,
      },
      recipient: [
        "<b>Customer Details</b>",
        ["Customer ID : #{@bill.customer_id}"],
        ["Customer Name : #{@cus.name}"],
        ["Customer Address : #{@cus.address}"],
        ["Customer email : #{@cus.email}"],

      ],
      line_items: [
        ["<b>Package id</b>", "<b>Package Name</b>", "<b>price</b>", "<b>Month</b>", "<b>Amount</b>", "<b>Payment status</b>"],
        [packid, packagedescription, price, month, "$#{amount}", nil],
        [nil, nil, nil, "Subtotal", "BDT#{amount}", nil],
        [nil, nil, nil, "Total", "BDT#{amount}", nil],
        [nil, nil, nil, "<b>Amount to be paid</b>", "BDT#{amount}", "#{st}"],
      ],
      footer: "Thanks for your business. Please contact us if you have any questions.",

    )
    send_data pdf.render, filename: "#{month},#{year}_Bill_#{@bill.id}_#{@cus.name}_#{@cus.id}.pdf", type: "application/pdf", disposition: "inline"
  end

  def confirm_pay
    @bill = Bill.find(params[:id])
    @bill.update(status: 1)
    h1 = @bill.customer_id.to_s
    h2 = @bill.amount.to_s
    h3 = @bill.due_date.to_s
    h4 = @bill.date.to_s
    h5 = @bill.package_id.to_s
    h6 = @bill.provider_id.to_s
    h7 = @bill.status.to_s

    combined = h1 + h2 + h3 + h4 + h5 + h6 + h7

    hash = Digest::SHA256.hexdigest(combined)[0, 10]

    @bill.txid = hash

    @bill.save
    flash[:confirmsg] = "bill payment confirmed"
    redirect_to "/bills"
    # render :bills
  end

  def confirm_pay_customer
    @bill = Bill.find(params[:id])
    customerid = session[:customer_id]
    if @bill.status == 1
      flash[:billpaid] = "Bill already paid"
    else
      @bill.update(status: 1)

      h1 = @bill.customer_id.to_s
      h2 = @bill.amount.to_s
      h3 = @bill.due_date.to_s
      h4 = @bill.date.to_s
      h5 = @bill.package_id.to_s
      h6 = @bill.provider_id.to_s
      h7 = @bill.status.to_s

      combined = h1 + h2 + h3 + h4 + h5 + h6 + h7

      hash = Digest::SHA256.hexdigest(combined)[0, 10]

      @bill.txid = hash

      @bill.save

      flash[:billpaid] = "Thank you for your payment"
    end

    redirect_to customerbills_path
  end

  def confirm_pay_provider
    @bill = Bill.find(params[:id])
    @bill.update(status: 1)
    h1 = @bill.customer_id.to_s
    h2 = @bill.amount.to_s
    h3 = @bill.due_date.to_s
    h4 = @bill.date.to_s
    h5 = @bill.package_id.to_s
    h6 = @bill.provider_id.to_s
    h7 = @bill.status.to_s

    combined = h1 + h2 + h3 + h4 + h5 + h6 + h7

    hash = Digest::SHA256.hexdigest(combined)[0, 10]

    @bill.txid = hash

    @bill.save
    flash[:confirmsg] = "bill payment confirmed"
    redirect_to showCustomerDetails_path(@bill.customer_id)
  end

  def destroy
    @bil = Bill.find(params[:id])
    @bil.destroy
    redirect_to "/bills"
  end
end
