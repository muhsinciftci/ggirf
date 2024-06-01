
#' @title Plot impulse response of linear local projections in lpirfs package.
#' @param lp_lin estimation results from the lpirfs package
#' @param chart_title The chart title
#' @param shock_lp  Which shock in the local projections
#' @param endo_lp   Which endogenous variables to plot? Default is all variables
#' @param scale_option Provide scaling options. Options are free_x, free_y and free. For details refer to ggplot2 facet_wrap
#' @param line_color Provide the line color of impulse response (mean value)
#' @param shade_color Provide the shade color of impulse response (confidence interval)
#' @param alpha_trans Transparency of shade colors
#' @param xlab label on x axis
#' @param ylab label on y axis
#' @param num_col Number of columns when faceting charts
#' @param return_only_data Should return only the resulting data instead of ggplot2 chart? Useful for post processing and comparison with other methods
#' @return Returns a ggplot2 chart
#' @export
#' @import dplyr tidyr ggplot2 lpirfs
gg_lpirfs_lin <- function(
    lp_lin,
    shock_lp,
    endo_lp = lp_lin$specs$column_names,
    line_color = 'black',
    shade_color = '#009CDE',
    alpha_trans = 0.5,
    scale_option = 'free',
    chart_title = NULL,
    xlab = NULL,
    ylab = NULL,
    num_col = NULL,
    return_only_data = FALSE
    ){

  shock_lp_num  <- which(lp_lin$specs$column_names == shock_lp)

  lp_irf_means <-
    lp_lin$irf_lin_mean[, , shock_lp_num] |>
    t() |>
    tibble::as_tibble(.name_repair = 'minimal') |>
    stats::setNames(lp_lin$specs$column_names) |>
    dplyr::mutate(Shock = shock_lp) |>
    tidyr::pivot_longer(!Shock, names_to = 'variables', values_to = 'mean') |>
    dplyr::mutate(Periods = 1:n(), .by = variables)

  lp_irf_low <- lp_lin$irf_lin_low[, , shock_lp_num] |>
    base::t() |>
    tibble::as_tibble(.name_repair = 'minimal') |>
    stats::setNames(lp_lin$specs$column_names) |>
    dplyr::mutate(Shock = shock_lp) |>
    tidyr::pivot_longer(!Shock, names_to = 'variables', values_to = 'low') |>
    dplyr::mutate(Periods = 1:n(), .by = variables)

  lp_irf_up <-
    lp_lin$irf_lin_up[, , shock_lp_num] |>
    base::t() |>
    tibble::as_tibble(.name_repair = 'minimal') |>
    stats::setNames(lp_lin$specs$column_names) |>
    dplyr::mutate(Shock = shock_lp) |>
    tidyr::pivot_longer(!Shock, names_to = 'variables', values_to = 'up') |>
    dplyr::mutate(Periods = 1:n(), .by = variables)

  tibble_lp_final <-
    lp_irf_low |>
    dplyr::left_join(lp_irf_means, by = c('Shock', 'variables', 'Periods')) |>
    dplyr::left_join(lp_irf_up,    by = c('Shock', 'variables', 'Periods')) |>
    dplyr::filter(Shock == shock_lp) |>
    dplyr::filter(variables %in% endo_lp)

  if (return_only_data) {
    return( tibble_lp_final )
  } else {
    tibble_lp_final |>
      ggplot2::ggplot(aes(x = Periods)) +
      ggplot2::geom_line(aes(y = mean), color = line_color) +
      ggplot2::geom_hline(yintercept = 0, color = 'gray50', linetype = 2) +
      ggplot2::geom_ribbon(aes(ymin = low, ymax = up),
                           fill = shade_color, alpha = alpha_trans) +
      ggplot2::facet_wrap(~variables, scales = scale_option, ncol = num_col) +
      ggplot2::labs(x = xlab, y = ylab)
  }

}
