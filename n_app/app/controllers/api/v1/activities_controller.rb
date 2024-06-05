module MarkdouwnApi
  module V1
    class ActivitiesController < ApplicationController
      def preview
        content = markdown(params[:content])
        render json: { content: }
      end
    end
  end
end
