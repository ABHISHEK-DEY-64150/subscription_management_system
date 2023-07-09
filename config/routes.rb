Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # get the home page
  get "/" => "providers#home"

  #login of provider

  get "/providerLogin" => "providers#signIn"

  post "/providerlogin" => "providers#loginprovider",as:"loginProvider"


  # after login admin the admin lands on admin dashboard

  get "/providerDashboard" => "providers#dashboard"

  get "/allcustomers" => "providers#registerredCustomers" , as: "allCustomersUnderProvider"

  get "/singlecustomer/:id"  => "providers#singleCustomer", as: "showCustomerDetails"

  get "/dues" => "providers#dues",as: "allduesofcustomers"

  post "/singlecustomer/:id/generate_bill" => "providers#generate_bill", as: "generate_bill"

  get "/showreviews" => "providers#showreviews",as: "showreviews"

  get "/bills" => "payments#bills", as: "bills"

  post "/genBills" => "payments#gen_monthly_bill", as: "gen_monthly_bills"


  #logout of admin on admindashboard

  delete "/logoutadmin" => 'providers#destroy', as: "logoutprovider"

  #Registration of a user by provider

  get "/customerregistration" => 'providers#userregister'

  post "/customerRegister" => 'providers#customerRegister',as:"customerregister"

  get '/provider/customer_register/service_type_selector' => 'providers#service_type_selection'


  #Subscription by provider

  get "/subscriptions/:id" => "subscriptions#newSubscriptions" , as:"newSubscriptions"

  #packages by provider

  get "/addpackages" => "providers#addPackages"

  post "/add_Package" => "providers#add_Package",as: "addpackage"




  #Customer functionalities

  post "/customerLogin" => "customers#loginCustomer",as:"customerlogin"

  get "/customerlogin" => "customers#signIn", as:"customerSignin"

  get "/customerDashboard" => "customers#dashboard",as:"customerDashboard"

  get "/duePackages" => "customers#duePackages", as: "duePackages"

  get "/reviews" =>  "customers#reviews", as:"reviews"
 
  delete "/logoutcustomer" => 'customers#destroy',as: "logoutcustomer"

  post '/createNewReview', to: 'customers#createNewReview', as: "createNewReview"


  #available packages of customer

  get "/internetPackagesavailable" => "subscriptions#internetPackagesavailable"

  get "/cablePackagesavailable" => "subscriptions#cablePackagesavailable"

  get "/paperPackagesavailable" => "subscriptions#paperPackagesavailable"

  get "/selectpackage" => "subscriptions#selectpackage"
  
  

  post "/addmySubscription/:id" => "subscriptions#addmySubscription",as:"addMysubscription"

  delete "/unsubscribe/:id" => "subscriptions#subscription_destroy", as:"unsubscribe"



  #payment
  get "/payment/:id" =>"payments#payment",as:"showPaymentforPackage"

  post "/makepayment/:id" => "payments#makePayment",as:"paymentforpackage"

  get "/paymenthistory" => "payments#paymenthistory",as:"transectionhistory"

  get '/paymenthistory/:id/download_pdf', to: 'payments#download_pdf', as: 'download_pdf'

end
