
#' @title Plot impulse response of linear local projections in lpirfs package.
#' @param est_result estimation results from the lpirfs package
#' @param chart_title The chart title
#' @param xlab label on x axis
#' @param ylab label on y axis
#'
#' @return Returns a ggplot2 chart
#' @export
#' @import dplyr ggplot2
gg_lpirfs_lin <- function(
    est_result,
    chart_title = glue::glue("{est_result$specs$endog_data} to {est_result$specs$shock}"),
    xlab = NULL, ylab = NULL
    ){

  # Avoid global variable warning
  Periods <- val_low <- val_mean <- val_up <- NULL

  data.frame(val_mean = as.vector(est_result$irf_panel_mean),
             val_low  = as.vector(est_result$irf_panel_low),
             val_up   = as.vector(est_result$irf_panel_up)) |>
    dplyr::mutate(Periods = 1:n()) |>
    ggplot2::ggplot(aes(x = Periods)) +
    ggplot2::geom_line(aes(y = val_mean), linewidth = 1, color = gg_colors[1]) +
    ggplot2::geom_ribbon(aes(ymin = val_low, ymax = val_up), fill = gg_colors[3], alpha = 0.25) +
    ggplot2::geom_hline(yintercept = 0, linetype = 2, linewidth = 0.5, color = 'gray70') +
    ggplot2::labs(x = xlab, y = ylab, title = chart_title)
}
