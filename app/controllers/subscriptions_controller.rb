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

      
          def addmySubscription
              
              puts "=====subs====>",params
              # puts "ppppp--->",params[:packagedescription]
              @mysub = CustomerSubscription.new
              @mysub.servicetype = params[:servicetype]
              @mysub.packagedescription = params[:packagedescription]
              @mysub.price = params[:price]
              @mysub.package_id = params[:package_id]
              @mysub.customer_id = session[:customer_id]
              customer = Customer.find_by(id: session[:customer_id])
              @mysub.provider_id = customer.provider_id
              @mysub.dues = 2
      
              if @mysub.save
                redirect_to "/internetPackagesavailable",notice: 'Customer subscribed successfully'
              else
                
      
                flash[:subscription_errors] = "Already subscribed"
                
                redirect_to "/internetPackagesavailable"
                # puts @mysub.errors.full_messages
                # render :internetPackagesavailable, status: :unprocessable_entity, content_type: "text/html"
      
              end
          end
      
      
          def destroy
            puts "unsubscribe an =========>>>>>",params 
            
            @customerSubscriptionrecord = CustomerSubscription.find(params[:id])
            puts "unsubscribe an article =========>>>>>",params 
            @customerSubscriptionrecord.destroy
            redirect_to "/customerDashboard"
          end
      
          private 
          def customerSub_params
              params.require(:mysub).permit(:servicetype , :packagedescription, :price, :package_id)
          end
      
end
