class Stock < ApplicationRecord
  belongs_to :portfolio
  STRATEGIES = ['post-fixed', 'pre-fixed', 'inflation', 'multimarket', 'variable', 'international']
  ADVISORS = ['Zenit', 'Bittencourt', 'None']
  validates :short_name, :symbol, :strategy, :buy_date, :buy_quantity, :buy_price, :advisor, presence: true
	validates :short_name, :symbol, uniqueness: true
	validates :strategy, inclusion: { in: STRATEGIES }
  validates :advisor, inclusion: { in: ADVISORS }

  def amount
    actual_price * buy_quantity
  end
  def return_value
    (actual_price - buy_price) * buy_quantity
  end
  def return_tax
    (((actual_price / buy_price) -1 ) * 100) 
  end 
  def day_return
    ((((actual_price / buy_price) ** (1 / (actual_date - buy_date).to_f)) - 1) * 100)
  end
  def month_return
    ((((day_return / 100) + 1) ** 30) - 1) * 100
  end
  def year_return
    ((((month_return / 100) + 1) ** 12) - 1) * 100
  end
end
