class Camera < ActiveRecord::Base
  has_many :videos
  belongs_to :quality
end
