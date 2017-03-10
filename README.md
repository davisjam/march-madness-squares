# March madness squares

The basic idea of [March Madness Squares](http://www.printyourbrackets.com/Ncaa100squares.html) is that instead of predicting winners and losers, you try to guess which final scores will be most common.
But instead of guessing the complete final score, you're only interested in the *ones places*.

The game is named "squares" because the pool can be described by a 10x10 grid of the numbers 0 to 9, with the higher seed's ones places as the rows and the lower seed's ones places as the columns.
Each player chooses one or more "squares" from this grid.
Each time a game ends with a score that falls in a person's square (a *hit*), they get a point.
The winner is the person whose square(s) have the most hits, perhaps weighted by the round in which their square(s) obtained hits.

# An improved prediction

This repository contains tools to help you choose "optimal" squares based on historical data.
See [my blog post](http://people.cs.vt.edu/~davisjam/blog-technical.html#march-madness-squares) for details.

## `extract-squares.pl`

Pretty self-explanatory.
Takes as input the names of one or more history files, extracts the squares and their frequency, and prints to stdout.
Prints the number of hits each square received (high seed ones place x low seed ones place).

Sample usage, using the data from the 2012-2013 through 2015-2016 tournaments (including play-in games):

```
$ ./extract-squares.pl `ls history/*.txt` | sort -k 3
...
squares[1][4] = 6
squares[1][6] = 7
squares[2][8] = 7
squares[4][1] = 7
squares[7][5] = 8
```

So, for the 2016-2017 tournament, given the choice you should pick the 7,5 square.

## history/

Historical data for the March Madness tournament, taken from [Fox Sports](http://www.foxsports.com/college-basketball/bracket?season=2016). I obtained these by highlighting the "First Four" and dragging to the bottom of the data". The format is consistent for each year I tried, starting with the 2012-2013 tournament.
