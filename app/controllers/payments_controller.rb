class PaymentsController < ApplicationController
    def payment
        @unpaidpack = CustomerSubscription.find(params[:id]);
    end

    def paymenthistory
        @payhistory = Payment.where(customer_id: session[:customer_id]).order(created_at: :desc)
    end


     def makePayment
              
              puts "=====subs====>",params
              # puts "ppppp--->",params[:packagedescription]
              @pay = Payment.new
              @pay.servicetype = params[:servicetype]
              @pay.packagedescription = params[:packagedescription]
              @pay.price = params[:price]
              @pay.dues = params[:dues]
              @pay.amount = params[:amount]  
              @pay.customer_id = session[:customer_id]
              customersub = CustomerSubscription.find(params[:id])
              @pay.package_id = customersub.package_id
              @pay.provider_id = customersub.provider_id
              @pay.subscription_id = params[:id]
              @pay.timestamp = Time.now
              @pay.card = params[:card]

              h1 = session[:customer_id].to_s
              h2 = params[:card].to_s
              h3 = @pay.timestamp.to_s
              h4 = @pay.amount.to_s
              h5 = @pay.dues.to_s

              combined = h1 + h2 + h3 + h4 + h5 

              hash = Digest::SHA256.hexdigest(combined)[0,10]

              @pay.txid = hash 

              
      
              if @pay.save && @pay.dues > 0 && @pay.amount > 0 && @pay.card 
                duePackages = CustomerSubscription.where(id: params[:id])
                duePackages.update(dues:0)
                redirect_to "/paymenthistory",notice: 'Payment done'

              else
                 flash[:payment_errors] = "payment error"
                 render :payment,@pay => @pay 
              end 
    end


end
