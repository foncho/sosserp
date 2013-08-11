# encoding: UTF-8

class User < ActiveRecord::Base
  simple_roles do
    strategy :one
    valid_roles :admin, :user, :delegate
  end
  
  has_many :expenses
  has_one :bank_account
  
  belongs_to :zone
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  #accepts_nested_attributes_for :roles
  #accepts_nested_attributes_for :user_roles
         
  attr_accessor :current_password
  attr_accessible :username, :current_password, :email, :password, :password_confirmation, :remember_me, :role,
    :name, :surname, :pid, :phone, :zone_id, :observations, :address
         
  validates :username, presence: { message: " no puede estar en blanco." }
  validates :email, presence: { message: " no puede estar en blanco." }
  validates :password, presence: { message: " no puede estar en blanco.", if: :password_changed? }
  validates_confirmation_of :password, message: " no puede estar en blanco.", if: :password_changed?
  #validates :current_password, presence: true, on: :update
  
  private
    def password_changed?
      !password.blank? && password_confirmation.blank?
    end
end
