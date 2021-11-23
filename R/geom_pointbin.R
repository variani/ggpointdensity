StatPointBin = ggproto("StatPointBin", Stat,
  required_aes = c("x", "y"),
  default_aes = aes(color = stat(dens)),

  compute_group = function(data, scales) {
    nbin = 64
    if(length(nbin) == 1) {
      nbin = rep(nbin, 2)
    }
    stopifnot(length(nbin) == 2)
    stopifnot(require("ash"))
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

geom_pointbin = function(
  mapping = NULL, data = NULL, 
  stat = "pointbin", position = "identity",
  na.rm = FALSE, show.legend = NA, inherit.aes = TRUE, ...)
{
  layer(stat = StatPointBin,
    data = data, mapping = mapping,
    geom = GeomPoint,
    position = position,
    show.legend = show.legend, inherit.aes = inherit.aes
  )
}
