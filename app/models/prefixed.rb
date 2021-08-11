class Prefixed < ApplicationRecord
  belongs_to :portfolio
  STRATEGIES = ['Pós-fixado', 'Prefixado', 'Inflação', 'Multimercado', 'Variável', 'Internacional']
  ADVISORS = ['Zenit', 'Bittencourt', 'Nenhum']
  validates :short_name, :description, :strategy, :buy_date, :buy_quantity, :buy_price, :advisor, :end_date, :year_tax, presence: true
	validates :strategy, inclusion: { in: STRATEGIES }
  validates :advisor, inclusion: { in: ADVISORS }

  def initial_amount
      buy_price * buy_quantity
  end
  
  def amount
    if actual_price
      actual_price * buy_quantity
    else
      0
    end
  end
  def return_value
    if actual_price
      (actual_price - buy_price) * buy_quantity
    else
      0
    end
  end
  def return_tax
    if actual_price
      (((actual_price / buy_price) -1 ) * 100) 
    else
      0
    end
  end 
  def day_return
    ((((year_tax / 100.0) + 1.0)**(1.0/252.0)) - 1.0) * 100.0
  end
  def month_return
    ((((year_tax / 100.0) + 1.0)**(1.0/12.0)) - 1.0) * 100.0
  end
  def year_return
    year_tax
  end
  def days_count
    date = Date.current
    sum = 0
    while date >= buy_date do
      if (date.wday > 0 && date.wday < 6)
        sum += 1
      end
      date -= 1
    end
    return sum
  end

  def cdi_tax
    if buy_date && actual_date
      Cdi.where("date_tax >= '#{buy_date}' AND date_tax <= '#{actual_date}'").sum(:value_day) * 100
    else
      0
    end
  end

  def ipca_tax
    if buy_date && actual_date
      Ipca.where("date_tax >= '#{buy_date}' AND date_tax <= '#{actual_date}'").sum(:value_day) * 100
    else
      0
    end
  end
end
