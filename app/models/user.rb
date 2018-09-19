class User < ApplicationRecord
  require 'aws-sdk'
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessor :collection
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable, 
         :recoverable, :rememberable, :trackable, :validatable
  has_one :payment
  has_many :images
  has_many :identities
  accepts_nested_attributes_for :payment
  before_save {self.email = email.downcase}
  after_create_commit :create_collection
  validates :email, presence: true, 
                    uniqueness: {case_sesitive: false}, 
                    length: {minimum: 3, maximum: 50},
                    format: {with:  VALID_EMAIL_REGEX}
 
  private
  def create_collection
    puts "Create collection for user [" + self.id.to_s + "]"
    client = Aws::Rekognition::Client.new
    collectionid = "idora" + Rails.env + self.id.to_s

    resp = client.create_collection({
            collection_id:collectionid,
           })

    self.collectionid = collectionid

    self.save

  end

end
