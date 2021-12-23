# https://ggplot2.tidyverse.org/reference/benchplot.html

library(dplyr)
library(bench)

## simulate some data
# N = 1e3
N = 1e5
dat = bind_rows(
  tibble(x = rnorm(N, sd = 1), y = rnorm(N, sd = 10), group = "foo"),
  tibble(x = rnorm(N, mean = 1, sd = .5), y = rnorm(N, mean = 7, sd = 5), group = "bar"))

## plots
p_base = ggplot(data = dat, mapping = aes(x = x, y = y))
p_nn = p_base + geom_pointdensity(method = "default")
p_kde = p_base + geom_pointdensity(method = "kde2d")
p_bin = p_base + geom_pointbin()

## becnhmark
marks = bench::mark(
  nn = benchplot(p_nn),
  kde = benchplot(p_kde),
  bin = benchplot(p_bin),
  check = FALSE)

