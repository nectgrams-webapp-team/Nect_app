module Api
  module V1
    class ActivitiesController < ApplicationController
      include MarkdownHelper

      def preview
        content = markdown(params[:content])
        render :json => { content: }
      end

      def upload
        return render json: { error: "ファイルがありません" }, status: :bad_request unless params[:image]

        image = ActiveStorage::Blob.create_and_upload!(io: params[:image], filename: params[:image].original_filename)
        render json: { url: url_for(image) }, status: :ok
      end
    end
  end
end
