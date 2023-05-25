class ApplicationController < ActionController::Base
    
    before_action  :set_current_provider
    
    def set_current_provider
        Current.provider = Provider.find_by(id: session[:provider_id]) if session[:provider_id]
    end

    def require_provider_logged_in
        redirect_to '/',alert:'you must be signed in' if Current.provider.nil?
    end
end
