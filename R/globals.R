
# Avoid global variable warning

# vars
#' @export
utils::globalVariables( c('Periods', 'var_irf', 'ir_mean', 'ir_ub', 'ir_lb', 'shock', 'endo_var',
                          'impulse_mean', 'impulse_lb', 'impulse_ub' ))

# linear local projections
#' @export
utils::globalVariables(c('Shock', 'variables', 'low', 'up'))

