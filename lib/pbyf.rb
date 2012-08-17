#Pause Break Yahoo Finance gem

require 'rest-client'
require 'csv'

class PBYF
  #these are the base urls for querying various parts of yahoo finance
  @@quote_url = 'http://download.finance.yahoo.com/d/quotes.csv?s='
  @@historical_quote_url = 'http://ichart.yahoo.com/table.csv?s='

  #str_of_stocks should be formatted according to yahoo finance api docs
  # might need to do work here on the formatting when multiple stocks are requested
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

# making a class to do calculations using the historical data from yahoo finance
# maybe refactor so @high @low @close etc. columns are precalculated after initializing. Could be faster/cleaner, I dunno. 
class HistoricalQuote
  attr_accessor :data, :close
  @@col = {date: 0, open: 1, high: 2, low: 3, close: 4}

  def initialize str_of_stock, from_date, to_date, interval = 'd'
    @data = PBYF.get_hist_quote str_of_stock, from_date, to_date, interval = 'd'
    @data.slice!(0)
    @close = get_hist_column(@@col[:close])
  end

  #get a column from the historical quotes CSV table
  def get_hist_column col
    closings = @data.map { |x| x[col] }
    closings.collect! {|i| i.to_f} unless col == 0
    closings
  end

  # get a better name for this
  def diffavg interval=20
    result =[]
    mvgavg = @data.moving_average(interval)

    @close.each_index do |i| 
      result << (@close[i] - mvavg[i])
    end
    result
  end

  # calculates MACD using exponential moving averages
  def macd short, long    
    data = @close
    raise 'Your historical data array is too short!' if (data.size < long)

    b = data.exp_moving_average(long)

    a = data.exp_moving_average(short)
    a.slice!(0, long-short)

    i=0
    result = []
    a.each do |ele|
      result << (ele-b[i])
      i+=1
    end
    result
  end

  # this method should return an array of %K, with a value for every row of the data set (every date)
  def find_k
    # %K = (Current Close - Lowest Low)/(Highest High - Lowest Low) * 100
    high = get_hist_column(@@col[:high])
    low = get_hist_column(@@col[:low])
    close = get_hist_column(@@col[:close])
    result = []

    close.each_index do |i|
      result << ((close[i]-low[i])/(high[i]-low[i]))*100
    end
  end

  # This is the 3 day exponential moving average of %K
  def stochastic_oscillator
    find_k.exp_moving_average(3)
  end

end

class Array
  def moving_average interval
    return self if interval == 1
    a = self.dup.map{|i| i.to_f}
    result = []
    i=0
    while(i <= a.size-interval)
      data = a.slice(i,interval)
      result << data.average
      i+=1
    end

    result
  end

  def exp_moving_average interval
    return self if interval == 1
    a = self.dup.map{|i| i.to_f}
    result = []
    result << a.moving_average(interval)[0]
    k = 2/(interval.to_f+1)

    (a.size-interval).times do |i|
      ema = ((a[i+interval]-result[i])*k + result[i])
      result << ema
    end
    result
  end

  def average
    self.inject(:+)/(self.size.to_f)
  end
end
