class PortfoliosController < ApplicationController
	
	def index
		@portfolios = policy_scope(Portfolio).order(created_at: :desc)
		@global_amount = 0
		@global_buy_amount = 0
		@global_return_tax = 0
		@global_strategy_composition_value = {}
		@global_initial_date = DateTime.current.to_date
		@global_finish_date = 0
		@portfolios.each do |portfolio|
			@global_amount += portfolio.amount
			@global_buy_amount += portfolio.initial_amount
			@global_strategy_composition_value = @global_strategy_composition_value.merge(portfolio.strategy_composition_value){ |k, a_value, b_value| a_value + b_value }
			@global_initial_date = portfolio.initial_date if portfolio.initial_date && portfolio.initial_date < @global_initial_date
			@global_finish_date = portfolio.finish_date if portfolio.finish_date && portfolio.finish_date > @global_finish_date
		end
		@global_return_tax = (@global_amount - @global_buy_amount) / @global_buy_amount * 100 if @global_buy_amount != 0
		@global_return_value = @global_amount - @global_buy_amount
		@global_strategy_composition_percentage = {}
		@global_strategy_composition_value.each do |key,value| 		
			@global_strategy_composition_percentage["#{key}"] = value / @global_amount * 100
		end
		if @global_finish_date != 0
			@global_cdi_tax = Cdi.where("date_tax >= '#{@global_initial_date}' AND date_tax <= '#{@global_finish_date}'").sum(:value_day) * 100
		else
			@global_cdi_tax = 0
			@global_initial_date = 0
		end
	end

	def show
		@portfolio = Portfolio.find(params[:id])
		authorize @portfolio
		@stocks = @portfolio.stocks
		@funds = @portfolio.funds
		#portfolio
		@portfolio_actual_amount = portfolio_actual_amount
		@portfolio_buy_amount = portfolio_buy_amount
		if  @portfolio.initial_date && @portfolio.finish_date
			@days = (@portfolio.finish_date - @portfolio.initial_date).to_i
		else
			@days = 0
		end
		if @stocks.length > 0 || @funds.length > 0
			@portfolio_return_tax = ((@portfolio_actual_amount / @portfolio_buy_amount) - 1) *100
			@portfolio_return_value = (@portfolio_actual_amount - @portfolio_buy_amount)
		else
			@portfolio_return_tax = 0
			@portfolio_return_value = 0
		end
		# stocks
		@stocks_actual_amount = product_actual_amount(@stocks)
		@stocks_buy_amount = product_buy_amount(@stocks)
		if @stocks.length > 0 
			if @stocks_actual_amount != 0
				@stocks_return_tax = ((@stocks_actual_amount / @stocks_buy_amount) - 1) *100
				@stocks_return_value = (@stocks_actual_amount - @stocks_buy_amount)
			else
				@stocks_return_tax = 0
				@stocks_return_value = 0
			end 
		end
		# funds
		@funds_actual_amount = product_actual_amount(@funds)
		@funds_buy_amount = product_buy_amount(@funds)
		if @funds.length > 0 
			if @funds_actual_amount != 0
				@funds_return_tax = ((@funds_actual_amount / @funds_buy_amount) - 1) *100
				@funds_return_value = (@funds_actual_amount - @funds_buy_amount)
			else
				@funds_return_tax = 0
				@funds_return_value = 0
			end
		end
	end

	def new
		@portfolio = Portfolio.new
		authorize @portfolio
	end

	def create
		@portfolio = Portfolio.new(portfolio_params)
		authorize @portfolio
		@portfolio.user = current_user
		if @portfolio.save
			redirect_to portfolios_path
		else
			flash[:alert] = @portfolio.errors.messages
			render :new
		end
	end

	def edit
		@portfolio = Portfolio.find(params[:id])
		authorize @portfolio
	end

	def update
		@portfolio = Portfolio.find(params[:id])
		authorize @portfolio
			if @portfolio.update(portfolio_params)
				flash[:success] = "Portfolio was successfully updated"
				redirect_to portfolios_path
			else
				flash[:error] = "Something went wrong"
				render :edit
			end
	end

	def destroy
		@portfolio = Portfolio.find(params[:id])
		authorize @portfolio
		@portfolio.destroy
		redirect_to portfolios_path
	end

	def consolidated
		@portfolios = current_user.portfolios
		authorize @portfolios
	end

	def update_products_value
		portfolios = current_user.portfolios
		authorize portfolios
		errors = []
		portfolios.each do |portfolio|
			# fundos
			if portfolio.funds.length.positive?
				portfolio.funds.each do |fund|
					data_fetch = fetch_fund_price(fund.cnpj_clean)
					if data_fetch.last['data'] && data_fetch.last['data'] != fund.actual_date
						fund.actual_date = Date.strptime(data_fetch.last['data'], '%Y-%m-%d')
						fund.actual_price = data_fetch.last['valor'].to_f
						if fund.save
							flash[:alert] = "#{fund.short_name} atualizado"
						else
							errors << fund.errors.messages
						end
					end
				end
			else
				flash[:alert] = "Fundos já estão atualizados"
			end
			# stocks
			if portfolio.stocks.length.positive?
				stock_symbols = []
				portfolio.stocks.each do |stock| 
					stock_symbols << stock.symbol
				end
				query = stock_symbols.join(',')
				data_fetch = fetch_stock_price(query)
				if data_fetch['quoteResponse']
					portfolio.stocks.each_with_index do |stock, index| 
						stock.actual_price = data_fetch['quoteResponse']['result'][index]['regularMarketPrice']
						stock.actual_date = DateTime.now
						if stock.save
							flash[:alert] = 'Ações atualizadas'
						else
							errors << stock.errors.messages
						end
					end
				else
					errors << 'Erro na API de ações, tente novamente mais tarde'
				end
			end
		end

		# cdi
		cdi_values = fetch_cdi_value
		if cdi_values.count > 0 
			cdi_values.each do |cdi|
				new_cdi = Cdi.new()
				new_cdi.value_year = cdi['valor'].to_f
				new_cdi.value_month = (1 + new_cdi.value_year) ** (1.0 / 12.0) - 1
				new_cdi.value_day = (1 + new_cdi.value_year) ** (1.0 / 252.0) - 1
				new_cdi.date_update = Date.current
				new_cdi.date_tax = Date.new(cdi["data"][0..3].to_i, cdi["data"][5..6].to_i, cdi["data"][8..9].to_i)
				if new_cdi.save
					flash[:alert] = 'Cdi criada'
				else
					errors << new_cdi.errors.messages
				end
			end
		end

		if errors.count.positive?
			flash[:alert] = errors.join(' | ')
		else
			flash[:alert] = 'Ativos atualizados com sucesso!' 
		end 
		redirect_to portfolios_path
	end

	private

	def portfolio_actual_amount
		portfolio = Portfolio.find(params[:id])
		sum = 0
		sum = product_actual_amount(portfolio.stocks) if portfolio.stocks.length > 0
		sum += product_actual_amount(portfolio.funds) if portfolio.funds.length > 0
		sum
	end

	def portfolio_buy_amount
		portfolio = Portfolio.find(params[:id])
		sum = 0
		sum = product_buy_amount(portfolio.stocks) if portfolio.stocks.length > 0
		sum += product_buy_amount(portfolio.funds) if portfolio.funds.length > 0
		sum
	end
	
	def product_actual_amount(product)
		sum = 0
		product.each do |product|
			sum += (product.buy_quantity * product.actual_price) if product.actual_price 
		end
		sum
	end

	def product_buy_amount(product)
		sum = 0
		product.each do |product|
			sum += (product.buy_quantity * product.buy_price)
		end
		sum
	end

	def portfolio_params
		params.require(:portfolio).permit(:name)
	end

	# for value update
	# cdi
	def fetch_cdi_value
    token = get_financial_data_token
    if token
			actual_date = "#{Date.current.year}-#{Date.current.month}-#{Date.current.day}"
			if Cdi.all.count > 0
				last_cdi_date = Cdi.last.date_tax + 1
			else
				last_cdi_date = '2010-01-01'
			end
      uri = URI.parse("https://api.financialdata.io/v1/indices/CDI/serie?dataInicio=#{last_cdi_date}&dataFim=#{actual_date}")
      header = {'Content-Type': 'application/json', 'Authorization': "Bearer #{token}"}
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri, header)
      response = http.request(request)
      return JSON.parse(response.read_body) 
    end
  end

	# funds
	def fetch_fund_price(query)
    token = get_financial_data_token
    if token
      uri = URI.parse("https://api.financialdata.io/v1/fundos/#{query}/cotas")
      header = {'Content-Type': 'application/json', 'Authorization': "Bearer #{token}"}
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri, header)
      response = http.request(request)
      return JSON.parse(response.read_body) 
    end
  end

  def get_financial_data_token
    login = ENV["FINANCIAL_LOGIN"]
    password = ENV["FINANCIAL_PASSWORD"]
    uri = URI.parse('https://api.financialdata.io/v1/token')
    header = {'Content-Type': 'application/json'}
    body = {usuario: login, senha: password}
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = body.to_json
    response = http.request(request)
    return response.read_body
  end
	# stocks
	def fetch_stock_price(query)
    url = URI("https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-quotes?region=BR&symbols=#{query}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV["YAHOO_API"]
    request["x-rapidapi-host"] = 'apidojo-yahoo-finance-v1.p.rapidapi.com'
    response = http.request(request)
    return JSON.parse(response.read_body)
  end
	
end
