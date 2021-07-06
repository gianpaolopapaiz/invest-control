class PortfolioPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def show?
    record.user == user
  end
  
  def create?
    return true
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  def consolidated?
    record.each do |s_record|
      s_record.user == user 
    end
  end

  def choose_stock?
    return true
  end

  def update_stocks_price?
    record.user == user
  end

  def choose_fund?
    return true
  end

  def update_funds_price?
    record.user == user
  end
end
