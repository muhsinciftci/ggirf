
#' @title  This function applies a custom theme to ggplot2 plots.
#' @return A ggplot2 theme object.
#' @export
gg_theme_irf <- function(){
  theme_bw() +
    theme(
      plot.title   = element_text(hjust = 0.5, vjust = 2, face = 'bold'),
      axis.title   = element_text(),
      axis.title.x = element_text(hjust = 0.5),
      axis.title.y = element_text(hjust = 0.5),
      axis.line    = element_line(colour = 'black', linewidth = 0.15),
      strip.text   = element_text(hjust = 0.5, colour = 'black'),
      strip.background = element_rect(fill = 'white', color = 'white'),
      panel.border = element_rect(colour = NA),
      panel.grid.major = element_line(linewidth = 0.075, colour = 'gray87'),
      #  element_line(linewidth = rel(0.25), colour = 'gray90'),
      panel.grid.minor = element_blank(),
      legend.title = element_blank(),
      legend.position = 'bottom',
      axis.ticks = element_blank()
    )
}
