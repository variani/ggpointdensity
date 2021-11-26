
# Geom `geom_pointbin`

The geom `geom_pointdensity` from the
[ggpointdensity](https://github.com/variani/ggpointdensity) package
implements two methods for 2D density estimation, nearest neighbors
(`method="default"`) and `kde2d` (`method="kde2d"`) from the MASS
package.

``` r
library(ggpointdensity)

library(ggplot2)
library(dplyr)
library(viridis)

library(cowplot)
theme_set(theme_cowplot(12))
```

``` r
N = 1e3
dat = bind_rows(
  tibble(x = rnorm(N, sd = 1), y = rnorm(N, sd = 10), group = "foo"),
  tibble(x = rnorm(N, mean = 1, sd = .5), y = rnorm(N, mean = 7, sd = 5), group = "bar"))
```

``` r
p_base = ggplot(data = dat, mapping = aes(x = x, y = y))

p_nn = p_base + 
  geom_pointdensity(method = "default") +
  scale_color_viridis()

p_kde = p_base + 
  geom_pointdensity(method = "kde2d") +
  scale_color_viridis()

p_bin = p_base + 
  geom_pointbin() +
  scale_color_viridis()

p_bin2 = p_base + 
  geom_pointbin(nbin = 16) +
  scale_color_viridis()

plot_grid(
  p_nn + labs(subtitle = 'geom_pointdensity(method = "default")'),
  p_kde + labs(subtitle = 'geom_pointdensity(method = "kde2d")'),
  p_bin + labs(subtitle = 'geom_pointbin()'),
  p_bin2 + labs(subtitle = 'geom_pointbin(nbin = 16)'))
```

<img src="img/README-pointbin-plot_pointdensity_vs_pointbin-1.png" width="100%" />
