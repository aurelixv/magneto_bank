class ImgSignal < ApplicationRecord
  has_one_attached :file

  def file_on_disk
    ActiveStorage::Blob.service.send(:path_for, file.key)
  end
end
