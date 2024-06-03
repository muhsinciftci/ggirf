
library(vars)
library(ggirf)
library(ggplot2)
sysfonts::font_add_google("Zilla Slab", "pf", regular.wt = 500)

var_estimation <- vars::VAR(Canada, p = 2, type = "const")
var_irf        <- vars::irf(var_estimation)

ggirf_image <-
  gg_vars(irf_result = var_irf, var_shock = 'e', var_endo = 'e') +
  gg_theme_irf() +
  scale_x_continuous(minor_breaks = NULL, n.breaks = 6) +
  theme(
    panel.background = element_rect(fill = 'gold'),
    strip.background = element_rect(fill = 'gold', colour = 'gold'),
    plot.background = element_rect(fill = 'gold', colour = 'gold'),
    strip.text   = element_text(colour = 'gold')
  )

# Manually save to avoid numbers showing up in the logo
ggirf_image

hexSticker::sticker(
  subplot = ggirf_image,
  package = 'ggirf',
  s_width = 1.2,
  s_height = 1.2,
  s_x = 0.9,
  s_y = 1,
  p_size = 18,
  h_fill = 'gold',
  h_color = '#407EC9',
  h_size = 1.5,
  p_color = '#407EC9',
  filename = here::here('man', 'figures', 'logo.png')
)

usethis::use_logo(img = here::here('man', 'figures', 'logo.png'))

rstudioapi::restartSession()
