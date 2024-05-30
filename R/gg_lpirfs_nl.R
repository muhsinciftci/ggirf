
#' @title Plot impulse response of non-linear local projections in lpirfs package.
#' @param est_result estimation results from the lpirfs package
#' @param chart_title The chart title
#' @param xlab label on x axis
#' @param ylab label on y axis
#'
#' @return Returns a ggplot2 chart
#' @export
#' @import dplyr ggplot2
gg_lpirfs_nl <- function(
    est_result,
    chart_title = glue::glue("{est_result$specs$endog_data} to {est_result$specs$shock}"),
    xlab = NULL, ylab = NULL){

  # Avoid global variable warning
  Periods <- s1_low <- s1_mean <- s1_up <- s2_low <- s2_mean <- s2_up <- val_low <- val_mean <- val_up <- NULL

  data.frame(
    # State 1
    s1_mean = as.vector(est_result$irf_s1_mean),
    s1_low  = as.vector(est_result$irf_s1_low),
    s1_up   = as.vector(est_result$irf_s1_up),

    # State 2
    s2_mean = as.vector(est_result$irf_s2_mean),
    s2_low  = as.vector(est_result$irf_s2_low),
    s2_up   = as.vector(est_result$irf_s2_up)
  ) |>
    dplyr::mutate(Periods = 1:n()) |>
    ggplot2::ggplot(aes(x = Periods)) +
    ggplot2::geom_line(aes(y = s1_mean), linewidth = 1, color = gg_colors[1]) +
    ggplot2::geom_ribbon(aes(ymin = s1_low, ymax = s1_up), fill = gg_colors[1], alpha = 0.25) +
    ggplot2::geom_line(aes(y = s2_mean), linewidth = 1, color = gg_colors[2]) +
    ggplot2::geom_ribbon(aes(ymin = s2_low, ymax = s2_up), fill = gg_colors[2], alpha = 0.25) +
    ggplot2::geom_hline(yintercept = 0, linetype = 2) +
    ggplot2::labs(x = xlab, y = ylab, title = chart_title)
}

