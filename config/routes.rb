Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # get the home page
  get "/" => "providers#home"

  #login of provider

  post "/providerlogin" => "providers#loginprovider"


  # after login admin the admin lands on admin dashboard

  get "/providerDashboard" => "providers#dashboard"

  #logout of admin on admindashboard

  delete "/logoutadmin" => 'providers#destroy'

  #Registration of a user by provider

  get "/customerregistration" => 'providers#userregister'

  post "/customerRegister" => 'providers#customerRegister'

end
