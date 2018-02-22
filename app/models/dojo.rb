class Dojo < ActiveRecord::Base
    has_many :students , dependent: :destroy #or :delete
   # attr_accessible :branch, :street, :city, :state
    validates :branch, :street, :city, :state, presence: true, length: {in: 2..20}
end
