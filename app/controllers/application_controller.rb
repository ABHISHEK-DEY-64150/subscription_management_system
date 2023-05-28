class ApplicationController < ActionController::Base
    
    before_action  :set_current_provider
    before_action  :set_current_customer
    
    def set_current_provider
        Current.provider = Provider.find_by(id: session[:provider_id]) if session[:provider_id]
    end

    def require_provider_logged_in
        redirect_to '/providerLogin',alert:'you must be signed in' if Current.provider.nil?
    end

    def set_current_customer
        Currentcustomer.customer = Customer.find_by(id: session[:customer_id]) if session[:customer_id]
    end

    def require_customer_logged_in 
        redirect_to '/customerlogin',alert:'you must be signed in' if Currentcustomer.customer.nil?
    end
end
