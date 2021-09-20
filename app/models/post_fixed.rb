class PostFixed < ApplicationRecord
  belongs_to :portfolio
  STRATEGIES = ['Pós-fixado', 'Prefixado', 'Inflação', 'Multimercado', 'Variável', 'Internacional']
  ADVISORS = ['Zenit', 'Bittencourt', 'Nenhum']
  TAXES = ['CDI', 'IPCA']
  validates :short_name, :description, :strategy, :buy_date, :buy_quantity, :buy_price, :advisor, :end_date, presence: true
	validates :strategy, inclusion: { in: STRATEGIES }
  validates :advisor, inclusion: { in: ADVISORS }
  validates :index_tax, inclusion: { in: TAXES }
end
