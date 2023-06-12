Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # get the home page
  get "/" => "providers#home"

  #login of provider

  get "/providerLogin" => "providers#signIn"

  post "/providerlogin" => "providers#loginprovider"


  # after login admin the admin lands on admin dashboard

  get "/providerDashboard" => "providers#dashboard"

  #logout of admin on admindashboard

  delete "/logoutadmin" => 'providers#destroy'

  #Registration of a user by provider

  get "/customerregistration" => 'providers#userregister'

  post "/customerRegister" => 'providers#customerRegister'

  #packages by provider

  get "/addpackages" => "providers#addPackages"

  post "/add_Package" => "providers#add_Package"


  #Customer functionalities

  post "/customerLogin" => "customers#loginCustomer"

  get "/customerlogin" => "customers#signIn"

  get "/customerDashboard" => "customers#dashboard",as:"customerDashboard"

  get "/duePackages" => "customers#duePackages"


  delete "/logoutcustomer" => 'customers#destroy',as: "logoutcustomer"


  #available packages of customer

  get "/internetPackagesavailable" => "subscriptions#internetPackagesavailable"

  get "/cablePackagesavailable" => "subscriptions#cablePackagesavailable"

  get "/paperPackagesavailable" => "subscriptions#paperPackagesavailable"

  get "/selectpackage" => "subscriptions#selectpackage"
  
  

  post "/addmySubscription/:id" => "subscriptions#addmySubscription",as:"addMysubscription"

  delete "/unsubscribe/:id" => "subscriptions#destroy", as:"unsubscribe"

  #payment
  get "/payment/:id" =>"payments#payment",as:"showPaymentforPackage"

  post "/makepayment/:id" => "payments#makePayment",as:"paymentforpackage"

  get "/paymenthistory" => "payments#paymenthistory",as:"transectionhistory"

end
