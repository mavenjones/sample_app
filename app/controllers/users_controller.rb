class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create, :recover]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  before_filter :signed_in_user, :only => [:new, :create]

  def new
    @user=User.new
    @title= "Sign up"
  end

  def index
    @title= "All users"
    @users = User.search(params[:search]).paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.registration_confirmation(:key => Crypto.encrypt("#{@user.id}:#{@user.salt}"),
                          :email => @user.email, :name => @user.name, :username => @user.username,
                          :domain => request.env['HTTP_HOST']).deliver
      #sign_in @user
      flash[:success] = "Welcome to the Sample App!  Please check your email to verify your account and login."
      #redirect_to @user
      
      
      #@user.activate #for testing:activates user automatically after signup
      
      redirect_to root_path
      
      
    else
      @user.password=""
      @user.password_confirmation=""
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title= "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if  current_user?(@user)
      redirect_to users_path, :notice => "Cannot Destroy Oneself."
    else
    
    
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
 
  def recover
    user = User.find_by_email(params[:email])
    if user
      UserMailer.recovery(:key => Crypto.encrypt("#{user.id}:#{user.salt}"),
                          :email => user.email,
                          :domain => request.env['HTTP_HOST']).deliver
      flash[:notice] = "Please check your email"
      redirect_to(root_path)
    else
      flash[:notice] = "Your account could not be found"
      redirect_to(root_path)
    end
    
  end
 
 
 private

  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
  
  def signed_in_user
    redirect_to(root_path) if signed_in?
  end

 

end
