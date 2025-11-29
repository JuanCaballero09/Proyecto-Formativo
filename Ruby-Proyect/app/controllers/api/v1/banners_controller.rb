class Api::V1::BannersController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    banners = Banner.includes(imagen_attachment: :blob).order(:id)
    render json: banners.map { |banner|
      {
        id: banner.id,
        imagen_url: banner.imagen.attached? ? url_for(banner.imagen) : nil,
        imagen_desktop_url: banner.imagen.attached? ? url_for(banner.imagen_resized) : nil,
        imagen_tablet_url: banner.imagen.attached? ? url_for(banner.imagen_tablet) : nil,
        imagen_mobile_url: banner.imagen.attached? ? url_for(banner.imagen_mobile) : nil,
        created_at: banner.created_at,
        updated_at: banner.updated_at
      }
    }
  end
end
