class Player < ActiveRecord::Base
  validates :name, presence: true
 # has_and_belongs_to_many :matches
  has_many :scores, dependent: :destroy
  has_many :matches, through: :scores
  belongs_to :user 
  mount_uploader :image, ImageUploader
end
