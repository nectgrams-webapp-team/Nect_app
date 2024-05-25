class Team < ApplicationRecord
    #belongs_to :member
    has_many :members
    has_many :team_members, dependent: :destroy
end
