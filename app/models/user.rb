class User < ApplicationRecord
require 'aws-sdk'
  attr_accessor :collection
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable, 
         :recoverable, :rememberable, :trackable, :validatable
  has_one :payment
  has_many :images
  has_many :identities
  accepts_nested_attributes_for :payment
  after_create_commit :create_collection
 
  private
  def create_collection
    puts "Create collection for user [" + self.id.to_s + "]"
    client = Aws::Rekognition::Client.new
    collectionid = "idora" + self.id.to_s
    resp = client.create_collection({
            collection_id:collectionid,
           })
    self.collectionid = collectionid
    self.save
  end

end
