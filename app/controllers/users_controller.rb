class UsersController < ApplicationController

  filter_resource_access
  
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Thank you for signing up! You are now logged in."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def show
    if current_user && current_user.is_admin?
      @user = User.find(params[:id])      
    else
      @user = @current_user
    end
  end

  def edit
    if current_user && current_user.is_admin?
      @user = User.find(params[:id])
    else
      @user = @current_user
    end
    @roles = @user.roles
  end
  
  def update
    if current_user && current_user.is_admin?
      @user = User.find(params[:id])      
    else
      @user = @current_user
    end
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      unless @user.id == current_user.id
        redirect_to @user
      else
        redirect_to root_url
      end
    else
      render :action => :edit
    end
  end
end
