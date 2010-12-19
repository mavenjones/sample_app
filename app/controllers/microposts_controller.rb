class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:create,:destroy]
  before_filter :authorized_user, :only => :destroy

  def create
    params[:micropost][:in_reply_to] = in_reply_to
    @micropost = current_user.microposts.build(params[:micropost])

    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end
  
  private
  
  def in_reply_to
    matchingUser = params[:micropost][:content].match(/\A@[\w+\-.]+/).to_s
    if matchingUser
      return matchingUser[1..-1] 
    end
  end
  
  def authorized_user
    @micropost = Micropost.find(params[:id])
    redirect_to root_path unless current_user?(@micropost.user)
  end
end