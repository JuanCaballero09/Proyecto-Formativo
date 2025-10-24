# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super do |resource|
        if resource.persisted? && !resource.confirmed?
          resource.send_confirmation_instructions unless resource.confirmation_token.present?
        end
    end
  end

  def destroy 
    current_user.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    redirect_to root_path, notice: "Tu cuenta ha sido eliminada correctamente"
  end
  protected

  def after_inactive_sign_up_path_for(resource)
      new_user_session_path
  end
end