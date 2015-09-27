class SessionController < ApplicationController
  get '/sign_in' do
    erb :'session/sign_in'
  end

  post '/sign_in' do
    user = User.find(email: params[:email], password_hash: Digest::SHA1.hexdigest(params[:password]))
    if user
      session[:id] = user.id
      redirect '/'
    else
      redirect '/sign_in'
    end
  end

  post '/sign_out' do
    session[:id] = nil
    redirect '/sign_in'
  end
end