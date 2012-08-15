require 'test/unit'
require 'pbyf'

#need more tests to make sure that these methods are returning the correct values, get some seed test data somehow
class Testgem < Test::Unit::TestCase
  @@googhist = HistoricalQuote.new('GOOG','7-15-2012','8-15-2012')

	def testHistoricalclass
		assert_not_nil @@googhist
	end

	def testMACD
		assert_instance_of Array, @@googhist.macd(3,5), 'macd method did not return an array'
	end

	def testStochasticOscillator
		assert_instance_of Array, @@googhist.stochastic_oscillator
	end

	def testFind_K
		assert_instance_of Array, @@googhist.find_k
	end

end