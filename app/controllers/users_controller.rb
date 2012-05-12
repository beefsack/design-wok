class UsersController < ApplicationController
  def me
    head :unauthorized if current_user.nil?
    @user = current_user
  end

  def index
    @users = User.all
  end

  def show
    @user = User.first(conditions: { username: params[:id] })
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
    @user = User.first(conditions: { username: params[:id] })
    if @user.update_attributes params[:user]
      render :action => 'show', :location => @user
    else
      render_model_errors @user
    end
  end

  def destroy
    @user = User.first(conditions: { username: params[:id] })
    @user.destroy
    head :no_content
  end

  def confirm
    @user = User.first conditions: {
      confirmation_token: params[:confirmation_token] }
  end
end
