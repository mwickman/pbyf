require 'test/unit'
require_relative 'pbyf'

#need more tests to make sure that these methods are returning the correct values, get some seed test data somehow
class Testgem < Test::Unit::TestCase
    #initialize test data
    @@googhist = HistoricalQuote.new('GOOG','7-15-2012','8-15-2012')
    @@hist = @@googhist
    @@test1 = [21,20,25,27,30,25,27,36,27,29,21,23,30,39,40,38,36,33,31,36,39,43,41,44,44,45,43,50,52,48,55,45,33,40,56]
    @@test1exp4 = [23.25,25.95,25.57,26.142,30.0852,28.85112,28.910672,25.7464032,24.64784192,26.788705152,31.6732230912,35.0039338547,36.2023603128,36.1214161877,34.8728497126,33.3237098276,34.3942258965,36.2365355379,38.9419213228,39.7651527937,41.4590916762,42.4754550057,43.4852730034,43.2911638021,45.9746982812,48.3848189687,48.2308913812,50.9385348287,48.5631208972,42.3378725383,41.402723523,47.2416341138]
    @@test1exp10 = [26.7,25.6636363636,25.179338843,26.0558226897,28.4093094734,30.516707751,31.8773063417,32.6268870068,32.6947257329,32.3865937814,33.0435767303,34.1265627793,35.7399150013,36.6962940919,38.0242406207,39.110742326,40.1815164486,40.6939680034,42.3859738209,44.1339785808,44.8368915661,46.6847294632,46.3784150153,43.9459759216,43.228525754,45.5506119806]
    @@test1simpavg4 = [23.25,25.5,26.75,27.25,29.5,28.75,29.75,28.25,25,25.75,28.25,33,36.75,38.25,36.75,34.5,34,34.75,37.25,39.75,41.75,43,43.5,44,45.5,47.5,48.25,51.25,50,45.25,43.25,43.5]
    @@test1macd = [2.210672,0.0827668364,-0.531496923,0.7328824623,3.2639136178,4.4872261038,4.3250539711,3.4945291809,2.1781239797,0.9371160461,1.3506491663,2.1099727586,3.2020063215,3.0688587017,3.4348510555,3.3647126797,3.3037565549,2.5971957987,3.5887244603,4.250840388,3.3939998152,4.2538053656,2.1847058819,-1.6081033833,-1.825802231,1.6910221332]
    @@hist.close = @@test1
    
    def testExpMovingAvg
        assert_equal @@test1exp4.map{|i| i.round(3)}, @@test1.exp_moving_average(4).map{|i| i.round(3)}
        assert_equal @@test1exp10.map{|i| i.round(3)}, @@test1.exp_moving_average(10).map{|i| i.round(3)}
    end
    
    def testHistoricalclass
        assert_not_nil @@googhist
    end

    def testMACD
        #puts @@hist.close.inspect
        assert_instance_of Array, @@googhist.macd(4,10), 'macd method did not return an array'
        assert_equal @@test1macd.map{|i| i.round(3)}, @@hist.macd(4,10).map{|i| i.round(3)}
    end

    def testStochasticOscillator
        assert_instance_of Array, @@googhist.stochastic_oscillator
    end

    def testFind_K
        assert_instance_of Array, @@googhist.find_k
    end

end
