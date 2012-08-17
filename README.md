pbyf
====

Someone help me make this readme look pretty. Pretty please?

Basic Documentation
===================
First install the gem and have require 'pbyf' in your app

Right now you get access to two classes, PBYF and HistoricalQuote

# PBYF methods
    PBYF.get_quote str_of_stocks, str_of_options
This method must be passed two strings, one being a correctly formatted string of Yahoo Finance stock symbols ('GOOG,BUD' will give google and budweiser stock arrays back). The second is a correctly formatted string of options ('nsl1op' should do something I think). Options are (here)[http://code.google.com/p/yahoo-finance-managed/wiki/enumQuoteProperty]. You will receive back an array of arrays with the data.

    PBYF.get_hist_quote str_of_stock, from_date, to_date, interval
Similar to above method, but can only do one stock at a time. Interval is like day, week, month. Dates should be string format like '4-22-2012'

# HistoricalQuote object
HistoricalQuote is an object that is instantiated with 'HistoricalQuote.new(str_of_stock, from_date, to_date, interval = d)' similar to the method above

## Methods
    get_hist_column(column)
returns an array of a column of the data

    stochastic_oscillator
returns an array of the stocastic oscillator for the data set, beginning 3 days from the from_date the object was initialized with

    find_k
returns an array of %K, which is used to calc the stochastic oscillator. Not sure if its useful for other things so it is a public method

# New Array methods
Some methods have been added to the Array class as well
    macd(short, long)
returns the Moving Average Convergence Divergence, using the exponential moving average of the data. This is set to using closing data by default if you leave out the column parameter.

    exp_moving_average(interval)
When performed on an array it will return an array with the Exponential Moving Averages for that array, starting with array[interval]. i.e. choosing an interval of 5 will return an array which has 5 fewer elements than the original

    moving_average(interval)
Like the above but for simple moving averages

    average
This returns an average of all elements in the array as a float