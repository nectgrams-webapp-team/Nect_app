class Home < ApplicationRecord
    mount_uploader :file, ImageUploader

    before_destroy :remove_file!

    def remove_file!
      self.remove_file
    end

    validates :title, :caption, :file, presence: true
end
