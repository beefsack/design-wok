class ApplicationController < ActionController::Base
  protect_from_forgery

  # == Description
  #
  # Renders model errors using render_errors and status Unprocessable Entity.
  #
  #
  # == Example output
  #
  #  errors:
  #    messages:
  #      name:
  #        - 'must be present'
  #    full_messages:
  #      - 'Name must be present'
  #
  def render_model_errors model
    render_errors({ messages: model.errors.messages,
      full_messages: model.errors.full_messages }, {
        status: :unprocessable_entity })
  end

  # == Description
  #
  # Renders an error
  #
  def render_errors errors, options={}
    options[:status] ||= :internal_server_error
    @errors = errors
    render controller: 'application', action: 'errors', status: options[:status]
  end
end
