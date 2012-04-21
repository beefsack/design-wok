class ApplicationController < ActionController::Base
  protect_from_forgery

  def render_model_errors model
    @errors = model.errors
    render :controller => 'application', :action => 'errors',
      :status => :unprocessable_entity
  end
end
