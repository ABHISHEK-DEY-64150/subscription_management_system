class Currentcustomer < ActiveSupport::CurrentAttributes
    # makes Current.user accessible in view files.
    attribute :customer 
  end