library(ggplot2)

StatPointDens = ggproto("StatPointDens", Stat,
  required_aes = c("x", "y"),
  default_aes = aes(color = stat(dens)),

  compute_group = function(data, scales) {
    nbin = 128
    if(length(nbin) == 1) {
      nbin = rep(nbin, 2)
    }
    stopifnot(length(nbin) == 2)
    out = ash::ash2(ash::bin2(
        cbind(data$x, data$y), 
        nbin = c(nbin, nbin)))

    ix = findInterval(data$x, out$x)
    iy = findInterval(data$y, out$y)
    ii = cbind(ix, iy)
    data$dens = out$z[ii]

    data
  }
)


geom_pointdens = function(
  mapping = NULL, data = NULL, 
  stat = "pointdens", position = "identity",
  na.rm = FALSE, show.legend = NA, inherit.aes = TRUE, ...)
{
  layer(stat = StatPointDens,
    data = data, mapping = mapping,
    geom = GeomPoint,
    position = position,
    show.legend = show.legend, inherit.aes = inherit.aes
  )
}

p = ggplot(mpg, aes(displ, hwy)) + 
  geom_pointdens()
  # stat_chull(geom = "point", size = 4, colour = "red") +

