module Api
  module V1
    class AuditLogsController < ApplicationController
      before_action :require_admin!

      def index
        logs = paginate(AuditLog.recent)
        render json: logs
      end

      def show
        log = AuditLog.find(params[:id])
        render json: log
      end
    end
  end
end