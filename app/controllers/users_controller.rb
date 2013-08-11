# encoding: UTF-8

class UsersController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :validate_user, only: [:edit, :update, :show]
  
  def index
    @users = User.all.sort
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.save ? redirect_to(users_path, notice: "Usuario correctamente creado.") : redirect_to(new_user_path, alert: @user.errors.full_messages.join("<br />").html_safe)
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if params[:user][:password].present?
      u = @user.update_with_password(params[:user])
    else
      u = @user.update_without_password(params[:user])
    end
    
    if u
      sign_in @user, bypass: true
      redirect_to((@user.has_role?(:delegate) ? user_path(@user) : users_path), notice: "Usuario correctamente actualizado.")
    else
      clean_up_passwords @user
      redirect_to(user_path(@user), alert: @user.errors.full_messages.join("<br />").html_safe)
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path
  end
end
