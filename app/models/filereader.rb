class Filereader < ApplicationRecord
  has_attached_file :file_upload
  belongs_to :account
  
  validates_attachment_content_type :file_upload, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf", "text/html", "text/plain", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/vnd.openxmlformats-officedocument.presentationml.presentation"]

end
