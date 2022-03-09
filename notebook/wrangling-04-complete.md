Wrangling 04 - Group By and Summarize - Completed Version
================
Chirsty Garcia, Ph.D. and Christopher Prener, Ph.D.
(March 09, 2022)

## Introduction

This notebook introduces some final techniques for data wrangling using
`dplyr` known as “grouped summaries.”

## Dependencies

This notebook requires a new dependency - `gapminder`:

``` r
install.packages("gapminder")
```

This notebook requires several other packages, including some
`tidyverse` packages:

``` r
# tidyverse packages
library(dplyr)      # data wrangling
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
# other packages
library(gapminder)  # life expectancy data
```

## Load Data

This notebook requires some data on life expectancy by country during
the post-war period:

``` r
mortality <- gapminder
```

## Basics of Grouped Summaries

The basic idea of grouped summaries is that there are “grouping
variables” within some data sets that you can aggregate data based on.
These are typically categorical or ordinal variables. For instance,
within the `mortality` data:

``` r
str(mortality)
```

    ## tibble [1,704 × 6] (S3: tbl_df/tbl/data.frame)
    ##  $ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
    ##  $ year     : int [1:1704] 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
    ##  $ lifeExp  : num [1:1704] 28.8 30.3 32 34 36.1 ...
    ##  $ pop      : int [1:1704] 8425333 9240934 10267083 11537966 13079460 14880372 12881816 13867957 16317921 22227415 ...
    ##  $ gdpPercap: num [1:1704] 779 821 853 836 740 ...

Within `mortality`, we could group our data by two categorical
variables, `country` and `continent`, as well as an ordinal variable
`year`. Each of these variables has a small but predictable set of
values, each of which appears in multiple observations. This is the
typical use case for grouped summaries.

We group in a pipeline using two `dplyr` functions, `group_by()` and
`summarise()` (`summarize()` works as well). For instance, we can group
our `mortality` data by `continent`, and calculate the number
observations (country-year combinations, like Afghanistan in 1952) per
continent:

``` r
mortality %>%
  group_by(continent) %>%
  summarise(records = n())
```

    ## # A tibble: 5 × 2
    ##   continent records
    ##   <fct>       <int>
    ## 1 Africa        624
    ## 2 Americas      300
    ## 3 Asia          396
    ## 4 Europe        360
    ## 5 Oceania        24

`group_by()` always returns the grouping variable, and whatever new
variables are created in `summarise()`. In this case, we can see that
out of the 1704 total observations in `mortality`, 624 are in Africa,
300 in the Americas, and so on.

If all we need to do is produce these types of counts, there is a
shortcut - `count()`:

``` r
mortality %>%
  count(continent)
```

    ## # A tibble: 5 × 2
    ##   continent     n
    ##   <fct>     <int>
    ## 1 Africa      624
    ## 2 Americas    300
    ## 3 Asia        396
    ## 4 Europe      360
    ## 5 Oceania      24

Now, you try - calculate the number of records present in the data set
*per year*:

``` r
mortality %>%
  count(year)
```

    ## # A tibble: 12 × 2
    ##     year     n
    ##    <int> <int>
    ##  1  1952   142
    ##  2  1957   142
    ##  3  1962   142
    ##  4  1967   142
    ##  5  1972   142
    ##  6  1977   142
    ##  7  1982   142
    ##  8  1987   142
    ##  9  1992   142
    ## 10  1997   142
    ## 11  2002   142
    ## 12  2007   142

Here (and rather un-interestingly), we can see that each year as an
equal number of observations. While boring, this is helpful to know as
we go through the data wrangling process.

## Window Functions

We can do more than just count, however. For instance, we could
calculate the average life expectancy for each continent between 1952
and 2007. We do this with what `dplyr` refers to as “window” functions,
like `mean()`, `median()`, `min()`, `max()`, `sd()`, and `var()`:

``` r
mortality %>%
  group_by(continent) %>%
  summarise(avg_lifeExp = mean(lifeExp))
```

    ## # A tibble: 5 × 2
    ##   continent avg_lifeExp
    ##   <fct>           <dbl>
    ## 1 Africa           48.9
    ## 2 Americas         64.7
    ## 3 Asia             60.1
    ## 4 Europe           71.9
    ## 5 Oceania          74.3

If you were to get output that had `NA` values for your new variable,
add `na.rm = TRUE` to your window function call
(i.e. `mean(lifeExp, na.rm = TRUE))`.

Now, try this at the country level, calculating the mean life expectancy
*per country* between 1952 and 2007:

``` r
mortality %>%
  group_by(country) %>%
  summarise(avg_lifeExp = mean(lifeExp))
```

    ## # A tibble: 142 × 2
    ##    country     avg_lifeExp
    ##    <fct>             <dbl>
    ##  1 Afghanistan        37.5
    ##  2 Albania            68.4
    ##  3 Algeria            59.0
    ##  4 Angola             37.9
    ##  5 Argentina          69.1
    ##  6 Australia          74.7
    ##  7 Austria            73.1
    ##  8 Bahrain            65.6
    ##  9 Bangladesh         49.8
    ## 10 Belgium            73.6
    ## # … with 132 more rows

We can calculate multiple new variables per `summarise()` call by
separating each expression with a comma. For instance, we can calculate
not just the mean life expectancy per continent but the median and
standard deviation as well as obtaining a count of the total number of
records:

``` r
mortality %>%
  group_by(continent) %>%
  summarise(
    records = n(),
    avg_lifeExp = mean(lifeExp),
    med_lifeExp = median(lifeExp),
    sd_lifeExp = sd(lifeExp)
  )
```

    ## # A tibble: 5 × 5
    ##   continent records avg_lifeExp med_lifeExp sd_lifeExp
    ##   <fct>       <int>       <dbl>       <dbl>      <dbl>
    ## 1 Africa        624        48.9        47.8       9.15
    ## 2 Americas      300        64.7        67.0       9.35
    ## 3 Asia          396        60.1        61.8      11.9 
    ## 4 Europe        360        71.9        72.2       5.43
    ## 5 Oceania        24        74.3        73.7       3.80

Now, you try the same functionality but *per country* instead of *per
continent*:

``` r
mortality %>%
  group_by(country) %>%
  summarise(
    records = n(),
    avg_lifeExp = mean(lifeExp),
    med_lifeExp = median(lifeExp),
    sd_lifeExp = sd(lifeExp)    
  )
```

    ## # A tibble: 142 × 5
    ##    country     records avg_lifeExp med_lifeExp sd_lifeExp
    ##    <fct>         <int>       <dbl>       <dbl>      <dbl>
    ##  1 Afghanistan      12        37.5        39.1       5.10
    ##  2 Albania          12        68.4        69.7       6.32
    ##  3 Algeria          12        59.0        59.7      10.3 
    ##  4 Angola           12        37.9        39.7       4.01
    ##  5 Argentina        12        69.1        69.2       4.19
    ##  6 Australia        12        74.7        74.1       4.15
    ##  7 Austria          12        73.1        72.7       4.38
    ##  8 Bahrain          12        65.6        67.3       8.57
    ##  9 Bangladesh       12        49.8        48.5       9.03
    ## 10 Belgium          12        73.6        73.4       3.78
    ## # … with 132 more rows

## Combining with Other Functions

One helpful thing we can do is add an `arrange()` call on to our
pipeline, which allows us to ask questions of our data like “which
continents have the lowest mean life expectancy over this period” and
“which continents have the highest”. To sort our data from low to high,
we use the `arrange()` function:

``` r
mortality %>%
  group_by(continent) %>%
  summarise(
    records = n(),
    avg_lifeExp = mean(lifeExp),
    med_lifeExp = median(lifeExp),
    sd_lifeExp = sd(lifeExp)
  ) %>%
  arrange(avg_lifeExp)
```

    ## # A tibble: 5 × 5
    ##   continent records avg_lifeExp med_lifeExp sd_lifeExp
    ##   <fct>       <int>       <dbl>       <dbl>      <dbl>
    ## 1 Africa        624        48.9        47.8       9.15
    ## 2 Asia          396        60.1        61.8      11.9 
    ## 3 Americas      300        64.7        67.0       9.35
    ## 4 Europe        360        71.9        72.2       5.43
    ## 5 Oceania        24        74.3        73.7       3.80

We can see that Africa has the lowest mean life expectancy, followed by
Asia and then the Americas.

If we want to sort our data from high to low, we combine `arrange()`
with `desc()`:

``` r
mortality %>%
  group_by(continent) %>%
  summarise(
    records = n(),
    avg_lifeExp = mean(lifeExp),
    med_lifeExp = median(lifeExp),
    sd_lifeExp = sd(lifeExp)
  ) %>%
  arrange(desc(avg_lifeExp))
```

    ## # A tibble: 5 × 5
    ##   continent records avg_lifeExp med_lifeExp sd_lifeExp
    ##   <fct>       <int>       <dbl>       <dbl>      <dbl>
    ## 1 Oceania        24        74.3        73.7       3.80
    ## 2 Europe        360        71.9        72.2       5.43
    ## 3 Americas      300        64.7        67.0       9.35
    ## 4 Asia          396        60.1        61.8      11.9 
    ## 5 Africa        624        48.9        47.8       9.15

Now we see our data in the opposite order - Oceania is first followed by
Europe and then the Americas.

The return on investment isn’t great here since we only have five values
in `continent`, but with `country` we have 142 total values and so
`arrange()` is far more useful. You try the same functionality but *per
country* instead of *per continent*. First, sort low to high:

``` r
mortality %>%
  group_by(country) %>%
  summarise(
    records = n(),
    avg_lifeExp = mean(lifeExp),
    med_lifeExp = median(lifeExp),
    sd_lifeExp = sd(lifeExp)    
  ) %>%
  arrange(avg_lifeExp)
```

    ## # A tibble: 142 × 5
    ##    country           records avg_lifeExp med_lifeExp sd_lifeExp
    ##    <fct>               <int>       <dbl>       <dbl>      <dbl>
    ##  1 Sierra Leone           12        36.8        37.6       3.94
    ##  2 Afghanistan            12        37.5        39.1       5.10
    ##  3 Angola                 12        37.9        39.7       4.01
    ##  4 Guinea-Bissau          12        39.2        38.4       4.94
    ##  5 Mozambique             12        40.4        42.3       4.60
    ##  6 Somalia                12        41.0        41.5       4.50
    ##  7 Rwanda                 12        41.5        43.7       6.31
    ##  8 Liberia                12        42.5        42.4       2.42
    ##  9 Equatorial Guinea      12        43.0        42.8       5.60
    ## 10 Guinea                 12        43.2        41.8       7.74
    ## # … with 132 more rows

We see see that several African countries have the lowest mean life
expectancy over this period (as well as Afghanistan).

Then, sort high to low:

``` r
mortality %>%
  group_by(country) %>%
  summarise(
    records = n(),
    avg_lifeExp = mean(lifeExp),
    med_lifeExp = median(lifeExp),
    sd_lifeExp = sd(lifeExp)    
  ) %>%
  arrange(desc(avg_lifeExp))
```

    ## # A tibble: 142 × 5
    ##    country     records avg_lifeExp med_lifeExp sd_lifeExp
    ##    <fct>         <int>       <dbl>       <dbl>      <dbl>
    ##  1 Iceland          12        76.5        76.6       3.03
    ##  2 Sweden           12        76.2        75.9       3.00
    ##  3 Norway           12        75.8        75.6       2.42
    ##  4 Netherlands      12        75.6        75.6       2.49
    ##  5 Switzerland      12        75.6        75.8       4.01
    ##  6 Canada           12        74.9        75.0       3.95
    ##  7 Japan            12        74.8        76.2       6.49
    ##  8 Australia        12        74.7        74.1       4.15
    ##  9 Denmark          12        74.4        74.7       2.22
    ## 10 France           12        74.3        74.4       4.30
    ## # … with 132 more rows

We see that Iceland has the highest mean life expectancy over this
period, followed by several other European countries.

We can also add in a `filter()` statement to zero in on a ten-year
period that contains three waves of data collection (1997, 2002, 2007)
by using `filter()` prior to `group_by()`:

``` r
mortality %>%
  filter(year >= 1997 & year <= 2007) %>%
  group_by(continent) %>%
  summarise(
    records = n(),
    avg_lifeExp = mean(lifeExp),
    med_lifeExp = median(lifeExp),
    sd_lifeExp = sd(lifeExp)
  ) %>%
  arrange(avg_lifeExp)
```

    ## # A tibble: 5 × 5
    ##   continent records avg_lifeExp med_lifeExp sd_lifeExp
    ##   <fct>       <int>       <dbl>       <dbl>      <dbl>
    ## 1 Africa        156        53.9        52.5       9.40
    ## 2 Asia           99        69.3        70.8       8.14
    ## 3 Americas       75        72.4        72.4       4.76
    ## 4 Europe         90        76.6        77.3       3.10
    ## 5 Oceania         6        79.5        79.7       1.32

Now, you try with countries over the first forty years in the data (from
1952 to 1992), which correspond to the cold war period:

``` r
mortality %>%
  filter(year >= 1952 & year <= 1992) %>%
  group_by(country) %>%
  summarise(
    records = n(),
    avg_lifeExp = mean(lifeExp),
    med_lifeExp = median(lifeExp),
    sd_lifeExp = sd(lifeExp)
  ) %>%
  arrange(avg_lifeExp)
```

    ## # A tibble: 142 × 5
    ##    country           records avg_lifeExp med_lifeExp sd_lifeExp
    ##    <fct>               <int>       <dbl>       <dbl>      <dbl>
    ##  1 Sierra Leone            9        35.3        35.4       3.35
    ##  2 Afghanistan             9        35.8        36.1       4.74
    ##  3 Angola                  9        36.7        37.9       3.88
    ##  4 Guinea-Bissau           9        37.1        36.5       3.61
    ##  5 Mozambique              9        39.1        40.3       4.56
    ##  6 Somalia                 9        39.3        39.7       3.79
    ##  7 Guinea                  9        39.7        38.8       5.13
    ##  8 Gambia                  9        39.9        38.3       7.91
    ##  9 Mali                    9        40.5        40.0       5.00
    ## 10 Equatorial Guinea       9        40.7        40.5       4.42
    ## # … with 132 more rows

Finally, change your sort to see which country had the *most* variation
(using the `sd_lifeExp` variable):

``` r
mortality %>%
  filter(year >= 1952 & year <= 1992) %>%
  group_by(country) %>%
  summarise(
    records = n(),
    avg_lifeExp = mean(lifeExp),
    med_lifeExp = median(lifeExp),
    sd_lifeExp = sd(lifeExp)
  ) %>%
  arrange(desc(sd_lifeExp))
```

    ## # A tibble: 142 × 5
    ##    country            records avg_lifeExp med_lifeExp sd_lifeExp
    ##    <fct>                <int>       <dbl>       <dbl>      <dbl>
    ##  1 Oman                     9        53.2        52.1      12.2 
    ##  2 Saudi Arabia             9        54.4        53.9      10.5 
    ##  3 West Bank and Gaza       9        56.3        56.5       9.72
    ##  4 China                    9        58.4        63.1       9.69
    ##  5 Vietnam                  9        52.4        50.3       9.38
    ##  6 Libya                    9        54.8        52.8       9.33
    ##  7 Gabon                    9        49.0        48.7       9.26
    ##  8 Jordan                   9        56.0        56.5       9.23
    ##  9 Tunisia                  9        56.6        55.6       9.06
    ## 10 Indonesia                9        49.6        49.2       8.94
    ## # … with 132 more rows

These are areas where there has been a significant shift over this time
period.

## More Complex Summaries

To really dig into that shift, we can calculate percent change over a
time period. We filter based on the years of interest, and then create a
variable for each `country` value that has the life expectancy for the
first row per country and the last row per continent. Since the data
have been sorted by year within countries, the first row is for 1952 and
the last is for 2007. When we `filter()`, that order remains.

We use `first()` to pull out the value in the first row and `last()` to
pull out the value in the last row. We can then use those values to
calculate percent change:

1.  Subtract the original value from the most recent value,
2.  divide by the original value,
3.  and multiple by 100.

We’ll start by ordering the data from high to low to explore countries
that have seen the most increases in life expectancy, and then click
through our data to see what countries had the most decreases in life
expectancy:

``` r
mortality %>%
  filter(year >= 1997 & year <= 2007) %>%
  group_by(country) %>%
  summarise(
    lifeExp97 = first(lifeExp),
    lifeExp07 = last(lifeExp),
    pct_change = (last(lifeExp)-first(lifeExp))/first(lifeExp)*100
  ) %>%
  arrange(desc(pct_change))
```

    ## # A tibble: 142 × 4
    ##    country          lifeExp97 lifeExp07 pct_change
    ##    <fct>                <dbl>     <dbl>      <dbl>
    ##  1 Rwanda                36.1      46.2      28.1 
    ##  2 Uganda                44.6      51.5      15.6 
    ##  3 Niger                 51.3      56.9      10.8 
    ##  4 Somalia               43.8      48.2       9.96
    ##  5 Burundi               45.3      49.6       9.39
    ##  6 Mali                  49.9      54.5       9.15
    ##  7 Congo, Dem. Rep.      42.6      46.5       9.10
    ##  8 Guinea                51.5      56.0       8.85
    ##  9 Eritrea               53.4      58.0       8.73
    ## 10 Tanzania              48.5      52.5       8.36
    ## # … with 132 more rows

Now, you try this, but over the cold war period from 1952 through 1992:

``` r
mortality %>%
  filter(year >= 1952 & year <= 1992) %>%
  group_by(country) %>%
  summarise(
    lifeExp97 = first(lifeExp),
    lifeExp07 = last(lifeExp),
    pct_change = (last(lifeExp)-first(lifeExp))/first(lifeExp)*100
  ) %>%
  arrange(desc(pct_change))
```

    ## # A tibble: 142 × 4
    ##    country            lifeExp97 lifeExp07 pct_change
    ##    <fct>                  <dbl>     <dbl>      <dbl>
    ##  1 Oman                    37.6      71.2       89.5
    ##  2 Gambia                  30        52.6       75.5
    ##  3 Saudi Arabia            39.9      68.8       72.5
    ##  4 Yemen, Rep.             32.5      55.6       70.8
    ##  5 Vietnam                 40.4      67.7       67.4
    ##  6 Indonesia               37.5      62.7       67.3
    ##  7 Gabon                   37.0      61.4       65.8
    ##  8 Myanmar                 36.3      59.3       63.3
    ##  9 West Bank and Gaza      43.2      69.7       61.5
    ## 10 India                   37.4      60.2       61.1
    ## # … with 132 more rows

Only one country had a decrease over this period, which was Rwanda (as a
consequence of the genocide in the early 1990s there).
