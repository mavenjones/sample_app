class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end
  
  def create
    user= User.authenticate(params[:session][:email],
                            params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title="Sign in"
      render 'new'
    else
      sign_in user
      redirect_back_or user
    
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  def recovery
    begin
      key= Crypto.decrypt(params[:id]).split(/:/)
      
      user = User.find_by_id(key[0],:conditions => {:salt => key[1]})
      
      if user.nil?
        flash.now[:error] = "The recover link given is not valid."
        @title="Sign in"
        render 'new'
      else
        sign_in user
        params[:id] = key[0]

        flash[:notice] = "Please change your password"
        redirect_to "/users/#{key[0]}/edit"
      end
      
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "The recover link given is not valid"
      redirect_to(root_url)
      
    end
  end

end
