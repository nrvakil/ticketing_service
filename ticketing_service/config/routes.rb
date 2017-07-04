Rails.application.routes.draw do
  root to: redirect('/api/auth/login')

  namespace :api do
    namespace :auth do
      post 'signup' => 'registrations#signup'
      post 'login' => 'registrations#login'
      post 'agent-signup' => 'registrations#agent_signup'
      post 'agent-login' => 'registrations#agent_login'
    end

    namespace :users do
      resources :tickets, except: [:destroy]
      post 'ticket-withdraw/:id' => 'tickets#withdraw'
      post 'ticket-reopen/:id' => 'tickets#reopen'
    end

    namespace :agents do
      resources :tickets, only: [:index]
      post 'ticket-process/:id' => 'tickets#processing'
      post 'ticket-resolve/:id' => 'tickets#resolve'
      post 'ticket-reject/:id' => 'tickets#reject'
      get 'report' => 'tickets#monthly_report'
    end

    namespace :admin do
      resources :admins, only: [:index]
      post 'ban_user/:id' => 'admins#ban_user'
      post 'activate_user/:id' => 'admins#activate_user'
      post 'ban_agent/:id' => 'admins#ban_agent'
      post 'approve_agent/:id' => 'admins#approve_agent'
    end
  end
end
