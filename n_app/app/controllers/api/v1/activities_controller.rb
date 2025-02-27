module Api
  module V1
    class ActivitiesController < ApplicationController
      require "mini_magick"
      include MarkdownHelper

      def preview
        content = markdown(params[:content])
        render :json => { content: }
      end

      def upload
        return render json: { error: "ファイルがありません" }, status: :bad_request unless params[:image]

        # 挿入された画像を取得
        dragged_image = params[:image]
        file_size = dragged_image.tempfile.size

        # 画像を圧縮
        compressed_image = MiniMagick::Image.open(dragged_image.tempfile.path)
        if compressed_image.width > 840
          compressed_image.resize "840x"
        else
          compressed_image.quality "50"
        end
        compressed_image.format "jpeg"

        # `compressed_image` を IO オブジェクトに変換
        io = StringIO.new(compressed_image.to_blob)
        filename = "#{File.basename(dragged_image.original_filename, '.*')}.jpg"
        image = ActiveStorage::Blob.create_and_upload!(
          io: io,
          filename: filename
        )
        render json: { url: url_for(image) }, status: :ok
      end
    end
  end
end
