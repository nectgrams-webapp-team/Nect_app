# frozen_string_literal: true

class SiteAdmins::CarouselImagesController < SiteAdmins::BaseController
    # Below here are the functions pertaining to modifying the images of the carousel in the top page
    def index
        @images = Home.all
        @new_image = Home.new
    end

    def create
        @image = Home.new(image_params)
        if @image.save
            redirect_to request.referrer, notice: "Image successfully uploaded!"
        else
            redirect_to request.referrer, notice: "Image carousel has missing parameters!"
        end
    end

    def update
        @image = Home.find(params[:id])
        if @image.update(image_params)
            redirect_to request.referrer, notice: "Image was successfully updated."
        else
            redirect_to request.referrer, notice: "Image carousel has failed to update!"
        end
    end

    def destroy
        @image = Home.find(params[:id])
        @image.destroy
        redirect_to request.referrer, notice: "Image was successfully deleted"
    end

    private

    def image_params
        params.require(:home).permit(:title, :caption, :file)
    end
end
