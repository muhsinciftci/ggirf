
#' @title Plot impulse response from vars package.
#' @param irf_result impulse response from a var
#' @param var_shock  Which shock in the VAR
#' @param var_endo   Which endogenous variables to plot? Default is all variables
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
#' @import dplyr tidyr ggplot2 vars tibble
gg_vars <- function(
    irf_result,
    var_shock,
    var_endo = var_irf$response,
    line_color = 'black',
    shade_color = '#009CDE',
    alpha_trans = 0.5,
    scale_option = 'free',
    xlab = NULL,
    ylab = NULL,
    num_col = NULL,
    return_only_data = FALSE
    ){

  # Check the length of the shock vector
  if (length(var_shock) > 1) { stop('Please provide one shock each time') }

  ir_mean <- tibble::tibble()
  ir_lb   <- tibble::tibble()
  ir_ub   <- tibble::tibble()

  ir_mean = rbind(
    ir_mean, irf_result$irf[[var_shock]] |>
      tibble::as_tibble() |>
      dplyr::mutate(shock = var_shock)
    )

  ir_lb = rbind(
    ir_lb, irf_result$Lower[[var_shock]] |>
      tibble::as_tibble() |>
      dplyr::mutate(shock = var_shock)
    )

  ir_ub = rbind(
    ir_ub, irf_result$Upper[[var_shock]] |>
      tibble::as_tibble() |>
      dplyr::mutate(shock = var_shock)
    )

  # Long format
  ir_mean <-
    ir_mean |>
    tidyr::pivot_longer(!shock, names_to = 'endo_var', values_to = 'impulse_mean') |>
    dplyr::mutate(Periods = 1:n(), .by = c('shock', 'endo_var'))

  ir_lb <-
    ir_lb |>
    tidyr::pivot_longer(!shock, names_to = 'endo_var', values_to = 'impulse_lb') |>
    dplyr::mutate(Periods = 1:n(), .by = c('shock', 'endo_var'))

  ir_ub <-
    ir_ub |>
    tidyr::pivot_longer(!shock, names_to = 'endo_var', values_to = 'impulse_ub') |>
    dplyr::mutate(Periods = 1:n(), .by = c('shock', 'endo_var'))

  tibble_vars_final <-
    ir_mean |>
    dplyr::left_join(ir_lb, by = c('shock', 'endo_var', 'Periods')) |>
    dplyr::left_join(ir_ub, by = c('shock', 'endo_var', 'Periods')) |>
    dplyr::filter(shock == var_shock) |>
    dplyr::filter(endo_var %in% var_endo)

  if (return_only_data) {
    return(tibble_vars_final)
  } else{
    return(
      tibble_vars_final |>
        ggplot2::ggplot(aes(x = Periods)) +
        ggplot2::geom_line(aes(y = impulse_mean), color = line_color) +
        ggplot2::geom_hline(yintercept = 0, color = 'gray50', linetype = 2) +
        ggplot2::geom_ribbon(aes(ymin = impulse_lb, ymax = impulse_ub),
                             fill = shade_color, alpha = alpha_trans) +
        ggplot2::facet_wrap(~endo_var, scales = scale_option, ncol = num_col) +
        ggplot2::labs(x = xlab, y = ylab)
    )
  }
}
