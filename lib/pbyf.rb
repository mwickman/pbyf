require 'rest-client'
require 'csv'
#Pause Break Yahoo Finance gem
class PBYF
  #these are the base urls for querying various parts of yahoo finance
  @@quote_url = 'http://download.finance.yahoo.com/d/quotes.csv?s='
  @@historical_quote_url = 'http://ichart.yahoo.com/table.csv?s='

  # this gets an array of arrays for the csv file
  # arr_of_arrays = CSV.parse(RestClient.get 'http://download.finance.yahoo.com/d/quotes.csv?s=%40%5EDJI,GOOG&f=nsl1op')

  #this will divide them into rows
  # CSV.parse(RestClient.get 'http://download.finance.yahoo.com/d/quotes.csv?s=%40%5EDJI,GOOG&f=nsl1op') do |row|
  # 	row
  # end

  #str_of_stocks should be formatted according to yahoo finance api docs
  def self.get_quote str_of_stocks, str_of_options
  	query_url = @@quote_url + str_of_stocks + '&f=' + str_of_options
  	arr_of_arrays = CSV.parse(RestClient.get query_url)
  end

  # one cannot get multiple stocks for historical quotes, you must get them separately
  # for now dates will be assumed to be the format Month-Day-Year, i.e. 3-19-1988
  #this should return an arrays of [Date, Open, High, Low, Close, Volume, Adj Close]
  def self.get_hist_quote str_of_stock, from_date, to_date, interval = 'd'
  	from = from_date.split('-')
  	to = to_date.split('-')
  	from_to_params = "&a=#{from[0].to_i-1}" + "&b=#{from[1]}" + "&c=#{from[2]}" + "&d=#{to[0].to_i-1}" + "&e=#{to[1]}" + "&f=#{to[2]}"
  	query_url = @@historical_quote_url + str_of_stock + from_to_params + "&g=#{interval}"
  	arr_of_arrays = CSV.parse(RestClient.get query_url)
  end
  
end
  
  #testing
  #PBYF.get_quote('%40%5EDJI,GOOG', 'nsl1op')
  #PBYF.get_hist_quote( 'GOOG', '3-19-2012', '4-19-2012', 'd' )