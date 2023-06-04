class PaymentsController < ApplicationController
    def payment
        @unpaidpack = CustomerSubscription.find(params[:id]);
    end


    def makePayment
        
    end


end
