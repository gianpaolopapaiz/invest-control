class Fund < ApplicationRecord
	STRATEGIES = ['post-fixed', 'pre-fixed', 'inflation', 'multimarket', 'variable', 'international']
  validates :short_name, :cnpj, :strategy, :buy_date, :buy_quantity, :buy_price, presence: true
	validates :short_name, :cnpj, uniqueness: true
	validates :strategy, inclusion: { in: STRATEGIES }
	validates :cnpj, format: { with: /\d{8}0001\d{2}/, message: 'Only allows digits!'}
end
