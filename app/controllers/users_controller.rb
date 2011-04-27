class UsersController < ApplicationController
  def new
    @user = User.new
    @title = 'Sign up'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
     # render :id => @user, :action => 'show'
     # a short form
     #render 'show'; # automatically picks up @user =>  DRY
     sign_in(@user)
     flash[:success] = "Welcome to the Clipper App!"
     redirect_to(user_path(@user)) #above are bot redirects and push 200 response). It hsould be redirects on success
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end
  
  def show
    if user_signed_in?
      @user = User.find(params[:id])
      @machines = @user.machines.paginate(:page => params[:page])
      @title = @user.name
    else
      @title = "Sign up"
      redirect_to new_user_session_path
    end
  end
  def index 
    @users = User.find(:all)
  end
end
