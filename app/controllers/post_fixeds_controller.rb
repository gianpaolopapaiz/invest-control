class PostFixedsController < ApplicationController
  def new
    @post_fixed = PostFixed.new
    authorize @post_fixed
    @portfolio = Portfolio.find(params[:portfolio_id])
    authorize @portfolio
  end

  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    authorize @portfolio
    @post_fixed = PostFixed.new(post_fixed_params)
    @post_fixed.portfolio = @portfolio
    @post_fixed.strategy = 'Pós-fixado'
    if @post_fixed.save
      # update_prefixeds_price
      # FINISH this part
    else
      render :new
    end
  end

  private

  def post_fixed_params
    params.require(:post_fixed).permit(:buy_date, :buy_quantity, :buy_price, :description, :short_name, :advisor, :end_date, :tax_index, :rate_index)
  end
end
