json.array! @stocks do |stock|
  json.extract! stock, :id, :short_name, :symbol, :actual_date, :actual_price
end