class User < ApplicationRecord
  attr_accessor :collection
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable, 
         :recoverable, :rememberable, :trackable, :validatable
  has_one :payment
  has_many :images
  has_many :identities
  accepts_nested_attributes_for :payment
end
