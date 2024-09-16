Hello World: My First R Markdown Blog Post
================
2023-06-15

## Hello, World!

This is my first blog post using R Markdown. Let’s explore some basic R
operations and create a simple graph.

### Basic R Operations

First, let’s perform some simple calculations:

``` r
2 + 2
```

    ## [1] 4

``` r
sqrt(16)
```

    ## [1] 4

``` r
pi
```

    ## [1] 3.141593

library(ggplot2)

# Create some dummy data

set.seed(123) data \<- data.frame( x = rnorm(100), y = rnorm(100) )

# Create the plot

ggplot(data, aes(x = x, y = y)) + geom_point(color = “blue”, alpha =
0.7) + geom_smooth(method = “lm”, se = FALSE, color = “red”) +
theme_minimal() + labs(title = “Scatter Plot with Trend Line”, x = “X
Axis”, y = “Y Axis”)
