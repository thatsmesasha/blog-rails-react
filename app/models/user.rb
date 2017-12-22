class User < ApplicationRecord
  has_many :posts
  has_many :likes
  has_many :comments

  validates :name, presence: true
end
