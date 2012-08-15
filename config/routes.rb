Reboleto::Application.routes.draw do
  root to: "bank_bills#new"
  resources :bank_bills, only: [:new, :create]
end
