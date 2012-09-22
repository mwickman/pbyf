require 'test/unit'
require_relative 'pbyf'
require 'csv'

class Factory
  
  def self.testdata
      arr = CSV.read('test_data.csv')
      arr.slice!(0) #date period for this file is 1-03-2011 to 05-31-2011
      arr
  end

  def self.get_col(col, array = [])
    array = Factory.testdata
    closings = array.map { |x| x[col] }
    closings.collect! {|i| i.to_f} unless col == 0
    closings.slice!(0,2) if col == 9
    closings
  end
end

#need more tests to make sure that these methods are returning the correct values, get some seed test data somehow
class Testgem < Test::Unit::TestCase
    #initialize test data
    @@googhist = HistoricalQuote.new('GOOG','1-3-2011','5-31-2011') #don't change this date

    @@test1 = [21,20,25,27,30,25,27,36,27,29,21,23,30,39,40,38,36,33,31,36,39,43,41,44,44,45,43,50,52,48,55,45,33,40,56]
    @@test1exp4 = [23.25,25.95,25.57,26.142,30.0852,28.85112,28.910672,25.7464032,24.64784192,26.788705152,31.6732230912,35.0039338547,36.2023603128,36.1214161877,34.8728497126,33.3237098276,34.3942258965,36.2365355379,38.9419213228,39.7651527937,41.4590916762,42.4754550057,43.4852730034,43.2911638021,45.9746982812,48.3848189687,48.2308913812,50.9385348287,48.5631208972,42.3378725383,41.402723523,47.2416341138]
    @@test1exp10 = [26.7,25.6636363636,25.179338843,26.0558226897,28.4093094734,30.516707751,31.8773063417,32.6268870068,32.6947257329,32.3865937814,33.0435767303,34.1265627793,35.7399150013,36.6962940919,38.0242406207,39.110742326,40.1815164486,40.6939680034,42.3859738209,44.1339785808,44.8368915661,46.6847294632,46.3784150153,43.9459759216,43.228525754,45.5506119806]
    @@test1simpavg4 = [23.25,25.5,26.75,27.25,29.5,28.75,29.75,28.25,25,25.75,28.25,33,36.75,38.25,36.75,34.5,34,34.75,37.25,39.75,41.75,43,43.5,44,45.5,47.5,48.25,51.25,50,45.25,43.25,43.5]
    @@test1macd = [2.210672,0.0827668364,-0.531496923,0.7328824623,3.2639136178,4.4872261038,4.3250539711,3.4945291809,2.1781239797,0.9371160461,1.3506491663,2.1099727586,3.2020063215,3.0688587017,3.4348510555,3.3647126797,3.3037565549,2.5971957987,3.5887244603,4.250840388,3.3939998152,4.2538053656,2.1847058819,-1.6081033833,-1.825802231,1.6910221332]

    @@test2 = [22.273400,22.194000,22.084700,22.174100,22.184000,22.134400,22.233700,22.432300,22.243600,22.293300,22.154200,22.392600,22.381600,22.610900,23.355800,24.051900,23.753000,23.832400,23.951600,23.633800,23.822500,23.872200,23.653700,23.187000,23.097600,23.326000,22.680500,23.097600,22.402500,22.172500]
    @@test2exp10 = [22.225,22.212,22.245,22.270,22.332,22.518,22.797,22.971,23.127,23.277,23.342,23.429,23.510,23.536,23.473,23.404,23.390,23.261,23.231,23.081,22.916]
    @@test2exp5 = [22.18204,22.17,22.19,22.27,22.26,22.27,22.23,22.29,22.32,22.42,22.73,23.17,23.36,23.52,23.66,23.65,23.71,23.76,23.73,23.55,23.40,23.37,23.14,23.13,22.89,22.65]
    @@test2macd = [0.0470976543,0.0207090423,0.0411813725,0.0481855907,0.0838281588,0.2110527014,0.3731265306,0.3936288296,0.3929859121,0.3868785078,0.311948499,0.2807625245,0.2542663855,0.1912978014,0.0746453736,-0.0070526399,-0.0165816994,-0.1185774471,-0.1038280096,-0.1948084371,-0.2674760377]
    
    @@test3 = Factory.get_col(4) #closings
    @@test3K = Factory.get_col(8)
    @@test3stoch = Factory.get_col(9)


    def testExpMovingAvg
        assert_equal @@test1exp4.map{|i| i.round(3)}, @@test1.exp_moving_average(4).map{|i| i.round(3)}
        assert_equal @@test1exp10.map{|i| i.round(3)}, @@test1.exp_moving_average(10).map{|i| i.round(3)}
        assert_equal @@test2exp10.map{|i| i.round(3)}, @@test2.exp_moving_average(10).map{|i| i.round(3)}
        assert_equal @@test2exp5.map{|i| i.round(2)}, @@test2.exp_moving_average(5).map{|i| i.round(2)}
    end
    
    def testHistoricalclass
        assert_not_nil @@googhist
    end

    def testMACD
        assert_instance_of Array, @@test1.macd(4,10), 'macd method did not return an array'
        assert_equal @@test1macd.map{|i| i.round(3)}, @@test1.macd(4,10).map{|i| i.round(3)}
        assert_equal @@test2macd.map{|i| i.round(2)}, @@test2.macd(5,10).map{|i| i.round(2)}
    end

    def testStochasticOscillator
        assert_instance_of Array, @@googhist.stochastic_oscillator
        assert_equal @@test3stoch.map{|i| i.round(3)}, @@googhist.stochastic_oscillator.map{|i| i.round(3)}
    end

    def testFind_K
        assert_instance_of Array, @@googhist.find_k
        assert_equal @@test3K.map{|i| i.round(3)}, @@googhist.find_k.map{|i| i.round(3)}
    end

end
