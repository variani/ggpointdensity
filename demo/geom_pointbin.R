library(ggplot2)
library(dplyr)
library(bench)

data(diamonds, package = "ggplot2")

## plots
p_base = ggplot(diamonds, aes(x = carat, y = price))
p_nn = p_base + geom_pointdensity(method = "default")
p_kde = p_base + geom_pointdensity(method = "kde2d")
p_bin = p_base + geom_pointbin()

## becnhmark
marks = bench::mark(
  nn = benchplot(p_nn),
  kde = benchplot(p_kde),
  bin = benchplot(p_bin),
  check = FALSE, iterations = 1)
