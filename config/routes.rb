Sosserp::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  get 'products/get_names', to: 'products#get_names'
  get "estimates/:id/to_pdf", to: "estimates#estimate_to_pdf", as: :estimate_to_pdf
  get "invoices/:id/to_pdf", to: "invoices#invoice_to_pdf", as: :invoice_to_pdf
  
  resources :clients, :invoices do
    collection { post :import }
  end
  
  resources :estimates do
    collection {
      post :import
      get ":id/convert_to_invoice", to: :invoice_converter, as: :convert_to_invoice
    }
  end
  
  resources :products do
    collection { post :import }
    get :add_new_price
    post :new_price
  end
    
  resources :taxes, :client_types, :payment_methods
  
  resources :users

  devise_for :users,
    controllers: {
      registrations: "users/registrations",
      sessions: "users/sessions",
      passwords: "users/passwords"
    },
    path: "",
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      sign_up: "register"
    }

  authenticate :user do
    root to: "estimates#index"
  end
end
