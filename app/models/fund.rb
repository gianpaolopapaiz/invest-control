class Fund < ApplicationRecord
	belongs_to :portfolio
	STRATEGIES = ['Pós-fixado', 'Prefixado', 'Inflação', 'Multimercado', 'Variável', 'Internacional']
	ADVISORS = ['Zenit', 'Bittencourt', 'Nenhum']
  validates :short_name, :cnpj, :cnpj_clean, :strategy, :buy_date, :buy_quantity, :buy_price, :advisor, presence: true
	validates :strategy, inclusion: { in: STRATEGIES }
	validates :advisor, inclusion: { in: ADVISORS }
	validates :cnpj_clean, format: { with: /\d{8}0001\d{2}/, message: 'Only allows digits!'}

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
    ((((actual_price / buy_price) ** (1 / (actual_date - buy_date).to_f)) - 1) * 100)
  end
  def month_return
    ((((day_return / 100) + 1) ** 30) - 1) * 100
  end
  def year_return
    ((((month_return / 100) + 1) ** 12) - 1) * 100
  end
	def cdi_tax
		if buy_date && actual_date  
    	Cdi.where("date_tax >= '#{buy_date}' AND date_tax <= '#{actual_date}'").sum(:value_day) * 100
		else
			0
		end
  end
  def ipca_tax 
    sum = 0
    sum = Ipca.where("date_tax >= '#{buy_date}'").sum(:value_day) * 100 if buy_date
    last_ipca_date = Ipca.last.date_tax
    date = last_ipca_date
    tax = Ipca.last.value_day
    if DateTime.now > last_ipca_date
      (DateTime.now - last_ipca_date).to_i.times do
        date += 1
        sum += tax if (date.wday != 6 && date.wday != 0)
      end
    end
    sum
	end
end
