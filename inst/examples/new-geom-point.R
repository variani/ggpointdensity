library(ggplot2)

GeomSimplePoint <- ggproto("GeomSimplePoint", Geom,
  required_aes = c("x", "y"),
  default_aes = aes(shape = 19, colour = "black"),
  draw_key = draw_key_point,

  draw_panel = function(data, panel_params, coord) {
    coords <- coord$transform(data, panel_params)
    col_point = rnorm(length(coords$x))
    grid::pointsGrob(
      coords$x, coords$y,
      pch = coords$shape,
      gp = grid::gpar(
        col = col_point)
    )
  }
)

geom_simple_point <- function(mapping = NULL, data = NULL, stat = "identity",
                              position = "identity", na.rm = FALSE, show.legend = NA, 
                              inherit.aes = TRUE, ...) {
  layer(
    geom = GeomSimplePoint, mapping = mapping,  data = data, stat = stat, 
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

ggplot(mpg, aes(displ, hwy)) + 
  geom_simple_point()
