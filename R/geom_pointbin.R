StatPointBin = ggproto("StatPointBin", Stat,
  required_aes = c("x", "y"),
  default_aes = aes(color = stat(dens)),

  compute_group = function(data, scales, params, nbin = 64, nsamples = 0) {
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
    if(nsamples == 0) {
      data$dens = out$z[ii]
    } else {
      data$dens = out$z[ii]
      data$bin = paste(ix, iy, sep = "-")

      data = data %>% 
        group_split(bin) %>% 
        lapply(function(split) {
            if(nrow(split) > nsamples) {
                split = mutate(split, row = seq(n()))
                sel = sample(split$row, nsamples, replace = FALSE)
                # v1
                split = split[sel, ]
                # v2
                # split = mutate(split, dens = ifelse(row %in% sel, dens, NA))
                # split = select(split, -row)
            } 
            split
        }) %>%
        bind_rows
    }

    data
  }
)

geom_pointbin = function(
  mapping = NULL, data = NULL, 
  stat = "pointbin", position = "identity",
  na.rm = FALSE, show.legend = NA, inherit.aes = TRUE, 
  nbin = 64, nsamples = 0, ...)
{
  layer(stat = StatPointBin,
    data = data, mapping = mapping,
    geom = GeomPoint,
    position = position,
    show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(nbin = nbin, nsamples = nsamples, na.rm = na.rm, ...)
  )
}
