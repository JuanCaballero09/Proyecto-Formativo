module Api
  module V1
    class HealthController < BaseController
      skip_before_action :authenticate_user!, only: [:check]

      def check
        render json: {
          status: 'ok',
          timestamp: Time.current.iso8601,
          version: '1.0.0',
          database: database_status
        }, status: :ok
      rescue => e
        render json: {
          status: 'error',
          message: e.message
        }, status: :service_unavailable
      end

      private

      def database_status
        ActiveRecord::Base.connection.active? ? 'connected' : 'disconnected'
      rescue
        'disconnected'
      end
    end
  end
end
