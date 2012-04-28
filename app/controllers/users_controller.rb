class UsersController < ApplicationController
  def me
    head :unauthorized if current_user.nil?
    @user = current_user
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
  end

  def create
    @user = User.new params[:user]
    if @user.save
      render :action => 'show', :status => :created, :location => @user
    else
      render_model_errors @user
    end
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes params[:user]
      redirect_to @user
    else
      render_model_errors @user
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
    head :no_content
  end
end
