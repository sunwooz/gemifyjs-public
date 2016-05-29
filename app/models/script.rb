class Script < ActiveRecord::Base
  belongs_to :jem
  mount_uploader :file, ScriptUploader
  
  validates :file,
    :presence => true,
    :file_size => {
      :maximum => 0.5.megabytes.to_i
    }

  validate :validate_file_name_is_unique

  private
  def validate_file_name_is_unique
    if Jem.find(jem_id).scripts.where(:file => file.file.original_filename).count > 0
      errors.add :file, "'#{file.file.original_filename}' already exists"
    end
  end
end
