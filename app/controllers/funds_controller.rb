class FundsController < ApplicationController
  def index
    @portfolio = Portfolio.find(params[:portfolio_id])
    authorize @portfolio
    @funds = @portfolio.funds
    @funds_actual_amount = funds_actual_amount(@funds)
		@funds_buy_amount = funds_buy_amount(@funds)
		
    if @funds.length > 0 
			@funds_return_tax = ((@funds_actual_amount / @funds_buy_amount) - 1) *100
			@funds_return_value = (@funds_actual_amount - @funds_buy_amount) 
		end

    if params[:query] && params[:query] != ''
      @query = params[:query]
      @funds = @portfolio.funds.where("cnpj_clean ILIKE ? OR advisor ILIKE ? OR short_name ILIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%")
    end
    
  end
  
  def choose_fund
    @portfolio = Portfolio.find(params[:portfolio_id])
    @fund = Fund.new
    @query = 'nil'
    if params[:query] && params[:query] != ''
      @query = params[:query]
      @fetched_fund = fetch_fund(@query)
      if !@fetched_fund
        flash[:alert] = 'API error, please try again later'
      end
    end   
  end

  def new
    @short_name = params[:short_name]
    @cnpj = params[:cnpj]
    @cnpj_clean = params[:cnpj_clean]
    @fund_class = params[:fund_class]
    @fund = Fund.new
    @fund.cnpj = @cnpj
    @fund.cnpj_clean = @cnpj_clean
    @fund.fund_class = @fund_class
    @fund.short_name = @short_name
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    @fund = Fund.new(fund_params)
    @fund.portfolio = @portfolio
    if @fund.save
      redirect_to portfolio_funds_path(@portfolio)
    else
      render :new
    end
  end

  def edit
    @fund = Fund.find(params[:id])
  end

  def update
    @fund = Fund.find(params[:id])
      if @fund.update(fund_params)
        flash[:success] = "Fund successfully updated"
        redirect_to portfolio_path(@fund.portfolio)
      else
        flash[:alert] = @fund.errors.messages
        render :edit
      end
  end

  def destroy
    fund = Fund.find(params[:id])
    fund.destroy
    redirect_to portfolio_funds_path(fund.portfolio)
  end

  def update_funds_price
		portfolio = Portfolio.find(params[:id])
		if portfolio.funds.length.positive?
			portfolio.funds.each do |fund|
        data_fetch = fetch_fund_price(fund.cnpj_clean)
        if data_fetch.last['data'] && data_fetch.last['data'] != fund.actual_date
          fund.actual_date = Date.strptime(data_fetch.last['data'], '%Y-%m-%d')
          fund.actual_price = data_fetch.last['valor'].to_f
          if fund.save
            flash[:alert] = "Updated #{fund.short_name}"
          else
            flash[:alert] = fund.errors.messages
          end
        end
      end
    else
      flash[:alert] = "Funds already updated"
    end
		redirect_to portfolio_funds_path(portfolio)
	end
  
  private

  def funds_actual_amount(funds)
		sum = 0
		funds.each do |fund|
			sum += (fund.buy_quantity * fund.actual_price) if fund.actual_price
		end
		sum
	end

	def funds_buy_amount(funds)
		sum = 0
		funds.each do |fund|
			sum += (fund.buy_quantity * fund.buy_price)
		end
		sum
	end
  
  def fetch_fund(query)
    token = get_financial_data_token
    if token
      uri = URI.parse("https://api.financialdata.io/v1/fundos/#{query}")
      header = {'Content-Type': 'application/json', 'Authorization': "Bearer #{token}"}
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri, header)
      response = http.request(request)
      return JSON.parse(response.read_body) 
    else
      flash[:alert] = 'Error to retrieve token'
      render :choose_fund
    end
  end
  
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

  def fund_params
    params.require(:fund).permit(:buy_date, :buy_quantity, :buy_price, :cnpj, :cnpj_clean, :short_name, :advisor, :fund_class, :strategy)
  end
end
