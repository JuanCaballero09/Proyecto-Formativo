# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super do |resource|
        if resource.persisted? && !resource.confirmed?
          resource.send_confirmation_instructions unless resource.confirmation_token.present?
        end
    end
  end
  protected


  def after_inactive_sign_up_path_for(resource)
      new_user_session_path
  end
end