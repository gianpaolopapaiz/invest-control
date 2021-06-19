class Fund < ApplicationRecord
	belongs_to :portfolio
	STRATEGIES = ['post-fixed', 'pre-fixed', 'inflation', 'multimarket', 'variable', 'international']
	ADVISORS = ['Zenit', 'Bittencourt', 'None']
  validates :short_name, :cnpj, :strategy, :buy_date, :buy_quantity, :buy_price, :advisor, presence: true
	validates :short_name, :cnpj, uniqueness: true
	validates :strategy, inclusion: { in: STRATEGIES }
	validates :advisor, inclusion: { in: ADVISORS }
	validates :cnpj, format: { with: /\d{8}0001\d{2}/, message: 'Only allows digits!'}
end
