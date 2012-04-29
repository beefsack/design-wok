class ApplicationController < ActionController::Base
  protect_from_forgery

  # == Description
  #
  # Renders the errors in a nice format as an API.
  #
  # == Example output
  #
  #  errors:
  #    messages:
  #      name:
  #        - 'must be present'
  #    full_messages:
  #      - 'Name must be present'
  def render_model_errors model
    @errors = model.errors
    render :controller => 'application', :action => 'errors',
      :status => :unprocessable_entity
  end
end
