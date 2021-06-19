class Fund < ApplicationRecord
	belongs_to :portfolio
	STRATEGIES = ['post-fixed', 'pre-fixed', 'inflation', 'multimarket', 'variable', 'international']
	ADVISORS = ['Zenit', 'Bittencourt', 'None']
  validates :short_name, :cnpj, :cnpj_clean, :strategy, :buy_date, :buy_quantity, :buy_price, :advisor, presence: true
	validates :short_name, :cnpj_clean, uniqueness: true
	validates :strategy, inclusion: { in: STRATEGIES }
	validates :advisor, inclusion: { in: ADVISORS }
	validates :cnpj_clean, format: { with: /\d{8}0001\d{2}/, message: 'Only allows digits!'}
end
