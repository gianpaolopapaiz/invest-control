class Cdi < ApplicationRecord
  validates :value_month, :value_day, :date_update, presence: :true
  validates :date, uniqueness: true
end
