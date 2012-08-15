require 'pbyf'
hist_columns = {close: 4, open: 1, high: 2, low: 3}
# a = PBYF.get_quote('GOOG', 'nsl1op')
hist = PBYF.get_hist_quote('GOOG', '7-13-2012', '8-13-2012')
#calculate moving average based on daily closing prices

#by default this is in descending order
# need to give a column number and the array of arrays
def get_hist_column hist_array, col
	hist_array.slice!(0)

	closings = []
	hist_array.each do |a|
		closings << a[col]
	end
	closings.collect! {|i| i.to_f} unless col == 0
	closings
end

# This function is limited by the long parameter. It will return data starting at the date hist_array[long-1] 
# or something like that anyway. Returns an array
def macd hist_array, short, long, column = 4
	raise 'Your historical data array is too short!' if hist_array.size < long
	
	data = get_hist_column(hist_array, column)
	puts "data= #{data.size}"
	b = data.moving_average(long)
	data.slice!(0, long-short)
	a = data.moving_average(short)
	puts "a= #{a.size}"
	puts "b= #{b.size}"

	i=0
	result = []
	#a.collect {|ele| ele-b[i]}
	a.each do |ele|
		puts ele
		ele = ele - b[i]
		result << ele
		i+=1
	end
	result
end


class Array
	def moving_average interval
		return self.average if interval == 1
    	a = self.dup
    	result = []
    	i=0
    	while(i <= a.size-interval)
    		data = a.slice(i,interval)
    		#puts "data= #{data}"
    		#puts "avg=  #{data.average}"
    		result << data.average
    		i+=1
    	end
    	result
	end

	def average
		r = (self.inject(:+)/self.size)
	end
end

b = get_hist_column hist, 4
puts b.inspect
puts "size of column is #{b.size}"
res = b.moving_average(5)
mac = macd(hist, 5, 10)
#arr = [1.0,2.0,3.0,4.0,5.0]
#res = arr.moving_average(2)
#puts "moving average is #{res.inspect}"
puts "macd is #{ mac }"