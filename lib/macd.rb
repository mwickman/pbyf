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
	closings
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
b.collect! {|i| i.to_f}
puts b.inspect
res = b.moving_average(5)
#arr = [1.0,2.0,3.0,4.0,5.0]
#res = arr.moving_average(2)
puts "moving average is #{res.inspect}"