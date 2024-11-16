module Api
  module V1
    class ActivitiesController < ApplicationController
      include MarkdownHelper
      def preview
        content = markdown(params[:content])
        render :json => { content: }
      end
    end
  end
end
