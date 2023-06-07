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
            @mysub.customer_id = session[:customer_id]
            @mysub.provider_id = @pack.provider_id 
            @mysub.dues = 1
    
            if @mysub.save
              redirect_to "/customerDashboard",notice: 'Customer subscribed successfully'
            else
              # flash[:subscription_errors] = "Already subscribed"

               error_message = @mysub.errors.full_messages

               puts "eeeeeeeeee----->>>>",error_message
              
              # render: "/customerDashboard"
              # puts @mysub.errors.full_messages
              # render :internetPackagesavailable
              #  status: :unprocessable_entity
              @internetPackage = Package.where("servicetype = 'Internet'")
              @cablePackage = Package.where("servicetype = 'Cable'") 
              @paperPackage = Package.where("servicetype = 'Paper'")  
              # puts @internetPackage
              if @pack.servicetype == "Internet"
                    render :internetPackagesavailable, @mysub=> @mysub
              elsif @pack.servicetype == "Cable"
                    render :cablePackagesavailable, @mysub=> @mysub
              else
                    render :paperPackagesavailable, @mysub=> @mysub
              end
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
