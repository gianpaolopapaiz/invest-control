class Cdi < ApplicationRecord
  validates :value_month, :value_day, :value_year, :date_update, presence: :true
  validates :date_tax, uniqueness: true
end
