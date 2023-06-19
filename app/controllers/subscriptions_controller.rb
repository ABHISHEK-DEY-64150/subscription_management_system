class SubscriptionsController < ApplicationController
        before_action :require_customer_logged_in ,only: [:internetPackagesavailable]
        
          def selectpackage
            
          end

          def internetPackagesavailable
              @internetPackage = Package.where("servicetype = 'Internet'")             
          end

          def cablePackagesavailable
            @cablePackage = Package.where("servicetype = 'Cable'")  
          end

          def paperPackagesavailable
            @paperPackage = Package.where("servicetype = 'Paper'")  
          end

      
          # def addmySubscription
              
          #     puts "=====subs====>",params
          #     # puts "ppppp--->",params[:packagedescription]
          #     @mysub = CustomerSubscription.new
          #     @mysub.servicetype = params[:servicetype]
          #     @mysub.packagedescription = params[:packagedescription]
          #     @mysub.price = params[:price]
          #     @mysub.package_id = params[:package_id]
          #     @mysub.customer_id = session[:customer_id]
          #     customer = Customer.find_by(id: session[:customer_id])
          #     @mysub.provider_id = customer.provider_id
          #     @mysub.dues = 2
      
          #     if @mysub.save
          #       redirect_to "/customerDashboard",notice: 'Customer subscribed successfully'
          #     else
          #       # flash[:subscription_errors] = "Already subscribed"

          #        error_message = @mysub.errors.full_messages

          #        puts "eeeeeeeeee----->>>>",error_message
                
          #       # render: "/customerDashboard"
          #       # puts @mysub.errors.full_messages
          #       # render :internetPackagesavailable
          #       #  status: :unprocessable_entity
          #       @internetPackage = Package.where("servicetype = 'Internet'")
          #       @cablePackage = Package.where("servicetype = 'Cable'") 
          #       @paperPackage = Package.where("servicetype = 'Paper'")  
          #       # puts @internetPackage
          #       if params[:servicetype] == "Internet"
          #             render :internetPackagesavailable, @mysub=> @mysub
          #       elsif params[:servicetype] == "Cable"
          #             render :cablePackagesavailable, @mysub=> @mysub
          #       else
          #         render :paperPackagesavailable, @mysub=> @mysub
          #       end
          #     end
          # end


        def newSubscriptions
            session[:curr_customer] = params[:id]
            @subsss = CustomerSubscription.where(customer_id: session[:curr_customer])
            @all_packages = Package.where(provider_id: session[:provider_id] )
            # @all_packages = Package.where("provider_id = :value1 AND id != :value2", value1: session[:provider_id], value2: @subsss.package_id)
        end
    
        def subscription_destroy
          puts "unsubscribe an =========>>>>>",params             
          @customerSubscriptionrecord = CustomerSubscription.find(params[:id])
          puts "unsubscribe an article =========>>>>>",   @customerSubscriptionrecord 
          @customerId  = @customerSubscriptionrecord.customer_id
          @customerSubscriptionrecord.destroy
          redirect_to showCustomerDetails_path(@customerId)
        end
    

          def addmySubscription
              
            puts "=====subs====>",params
            # puts "ppppp--->",params[:packagedescription]
            @pack = Package.find(params[:id])
            puts "dfkjidfbhgj===>",@pack.servicetype
            @mysub = CustomerSubscription.new
            @mysub.servicetype = @pack.servicetype
            @mysub.packagedescription = @pack.description
            @mysub.price = @pack.price
            @mysub.package_id = params[:id]
            @mysub.customer_id = session[:curr_customer]
            @mysub.provider_id = @pack.provider_id 
            @mysub.dues = 1
    
            if @mysub.save
              session[:curr_customer] = nil
              redirect_to showCustomerDetails_path(@mysub.customer_id),notice: 'Customer subscribed successfully'
            else
              # flash[:subscription_errors] = "Already subscribed"

               error_message = @mysub.errors.full_messages

               puts "eeeeeeeeee----->>>>",error_message
              
              # render: "/customerDashboard"
              # puts @mysub.errors.full_messages
              # render :internetPackagesavailable
              #  status: :unprocessable_entity
              # @internetPackage = Package.where("servicetype = 'Internet'")
              # @cablePackage = Package.where("servicetype = 'Cable'") 
              # @paperPackage = Package.where("servicetype = 'Paper'")  
              # puts @internetPackage
              flash.now[:subscription_errors] = error_message
              redirect_to newSubscriptions_path(@mysub.customer_id)
              # if @pack.servicetype == "Internet"
              #       render :internetPackagesavailable, @mysub=> @mysub
              # elsif @pack.servicetype == "Cable"
              #       render :cablePackagesavailable, @mysub=> @mysub
              # else
              #       render :paperPackagesavailable, @mysub=> @mysub
              # end
            end
        end
      
      
          private 
          def customerSub_params
              params.require(:mysub).permit(:servicetype , :packagedescription, :price, :package_id)
          end
      
end
