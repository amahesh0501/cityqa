class Question < ActiveRecord::Base
  attr_accessible  :title, :body
  belongs_to :user
  belongs_to :city
  has_many :answers
  has_many :votes, as: :voteable
  has_many :subscriptions

  validates :title, :body, :presence => true

end