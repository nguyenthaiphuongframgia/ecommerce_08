class User < ApplicationRecord
  mount_uploader :avatar, PictureUploader
  has_many :recently_vieweds, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :suggest_products, dependent: :destroy
  has_many :comments, dependent: :destroy

  mount_uploader :avatar, PictureUploader

  validates :name, presence: true, length: {maximum: Settings.maximum.name}
  validates :address, presence: true,
    length: {maximum: Settings.maximum.address}
  validates :phone, presence: true, length: {maximum: Settings.maximum.phone}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: {maximum: Settings.maximum.email},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {maximum: Settings.maximum.password}, allow_nil: true

  before_save {email.downcase!}

  scope :of_ids, -> ids {where id: ids}

  def is_user? user
    self == user
  end

  scope :by_name, ->name do
    where "name LIKE '%#{name}%'" if name.present?
  end
end
