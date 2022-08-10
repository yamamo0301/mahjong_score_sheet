class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :prefecture
  has_many :rules, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :score_sheets, dependent: :destroy
  accepts_nested_attributes_for :players
end
