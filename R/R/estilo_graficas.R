# Estilo estándar de gráficas para ggplot2.
#
# Uso rápido:
#   library(estilograficas)   # también carga ggplot2
#   aplicar_estilo()
#   ggplot(datos, aes(x, y, color = grupo)) + geom_line()
#
# Los colores y la fuente (Inter) son los mismos de python/ y stata/.

# -----------------------------------------------------------------------------
# Fuente: Inter viene incluida en el paquete (licencia SIL OFL, ver inst/fuentes/OFL.txt)
# -----------------------------------------------------------------------------
# Se registra con un nombre propio para no depender de la versión de Inter que
# haya (o no) en el computador: así las gráficas se ven igual en todos lados.
paleta_fuente <- "Inter Paleta"

.onLoad <- function(libname, pkgname) {
  carpeta <- system.file("fuentes", package = pkgname)
  archivos <- file.path(carpeta, c("Inter-Regular.ttf", "Inter-Bold.ttf",
                                   "Inter-Italic.ttf", "Inter-BoldItalic.ttf"))
  # Para PNG (ragg)
  if (!paleta_fuente %in% systemfonts::registry_fonts()$family) {
    systemfonts::register_font(paleta_fuente, plain = archivos[1], bold = archivos[2],
                               italic = archivos[3], bolditalic = archivos[4])
  }
  # Para PDF (showtext)
  sysfonts::font_add(paleta_fuente, regular = archivos[1], bold = archivos[2],
                     italic = archivos[3], bolditalic = archivos[4])
}

# -----------------------------------------------------------------------------
# Paleta (tono 1 = más claro, tono 5 = más intenso)
# -----------------------------------------------------------------------------
paleta_familias <- list(
  gris     = c("#F2F2F2", "#E0E0E0", "#CDCDCD", "#A8A8A8", "#969696"),
  ambar    = c("#F5DBB4", "#F2D09E", "#EDBB71", "#EAB05A", "#E7A544"),
  naranja  = c("#F8D0B6", "#F6C2A0", "#F1A675", "#EF985F", "#ED8A49"),
  coral    = c("#F0BFB5", "#ECAC9F", "#E79889", "#DE715C", "#DA5E46"),
  turquesa = c("#E4EAEB", "#C9E2E5", "#92D3DA", "#76CBD4", "#5BC3CE")
)

# Colores principales con nombre (el tono más intenso de cada familia)
paleta_colores <- vapply(paleta_familias, function(t) t[5], character(1))

# Orden por defecto para series categóricas: primero los colores más distinguibles
paleta_categorica <- c("#5BC3CE", "#DA5E46", "#E7A544", "#969696",
                       "#ED8A49", "#92D3DA", "#E79889", "#EDBB71")

# Divergente: turquesa (negativo) -> gris claro (centro) -> coral (positivo)
paleta_divergente <- c("#5BC3CE", "#92D3DA", "#C9E2E5", "#F2F2F2",
                       "#F0BFB5", "#E79889", "#DA5E46")

# Texto y ejes en negro; la cuadrícula en gris claro
paleta_texto            <- "#000000"
paleta_texto_secundario <- "#000000"
paleta_ejes             <- "#000000"
paleta_cuadricula       <- "#E0E0E0"
paleta_fondo            <- "#FFFFFF"

# Devuelve un color por familia y tono (1-5). Ej.: paleta_color("coral", 3)
paleta_color <- function(familia, tono = 5) {
  if (!familia %in% names(paleta_familias)) {
    stop("Familia desconocida: '", familia, "'. Opciones: ",
         paste(names(paleta_familias), collapse = ", "), ".")
  }
  if (!tono %in% 1:5) stop("El tono debe estar entre 1 y 5; se pidi\u00f3 ", tono, ".")
  paleta_familias[[familia]][tono]
}

# Primeros n colores de la paleta categórica
paleta_cat <- function(n = length(paleta_categorica)) {
  if (n > length(paleta_categorica)) {
    stop("La paleta categ\u00f3rica tiene ", length(paleta_categorica),
         " colores; se pidieron ", n, ".")
  }
  paleta_categorica[seq_len(n)]
}

# n colores interpolados de una familia (secuencial)
paleta_sec <- function(n, familia = "turquesa") {
  grDevices::colorRampPalette(paleta_familias[[familia]])(n)
}

# n colores interpolados de la paleta divergente
paleta_div <- function(n) {
  grDevices::colorRampPalette(paleta_divergente)(n)
}

# -----------------------------------------------------------------------------
# Tema
# -----------------------------------------------------------------------------
theme_paleta <- function(base_size = 11, base_family = paleta_fuente) {
  theme_minimal(base_size = base_size, base_family = base_family) +
    theme(
      text             = element_text(color = paleta_texto),
      plot.title       = element_text(face = "bold", size = rel(1.25), hjust = 0,
                                      margin = margin(b = 4)),
      plot.subtitle    = element_text(color = paleta_texto_secundario, hjust = 0,
                                      margin = margin(b = 10)),
      plot.caption     = element_text(color = paleta_texto_secundario, size = rel(0.8),
                                      hjust = 0, margin = margin(t = 10)),
      plot.title.position   = "plot",
      plot.caption.position = "plot",
      axis.text        = element_text(color = paleta_texto_secundario, size = rel(0.9)),
      axis.line        = element_line(color = paleta_ejes, linewidth = 0.4),
      axis.line.y      = element_blank(),
      axis.ticks       = element_line(color = paleta_ejes, linewidth = 0.4),
      axis.ticks.y     = element_blank(),
      axis.ticks.length.x = unit(3, "pt"),
      panel.grid.major.y = element_line(color = paleta_cuadricula, linewidth = 0.4),
      panel.grid.major.x = element_blank(),
      panel.grid.minor   = element_blank(),
      legend.position  = "top",
      legend.justification = "left",
      legend.title     = element_blank(),
      legend.text      = element_text(size = rel(0.9)),
      plot.background  = element_rect(fill = paleta_fondo, color = NA),
      panel.background = element_rect(fill = paleta_fondo, color = NA),
      strip.text       = element_text(face = "bold", hjust = 0),
      plot.margin      = margin(12, 12, 12, 12)
    )
}

# -----------------------------------------------------------------------------
# Escalas
# -----------------------------------------------------------------------------
# Discretas (categorías)
scale_color_paleta <- function(...) {
  discrete_scale("colour", palette = function(n) paleta_cat(n), ...)
}
scale_fill_paleta <- function(...) {
  discrete_scale("fill", palette = function(n) paleta_cat(n), ...)
}
scale_colour_paleta <- scale_color_paleta

# Continuas secuenciales (una familia)
scale_color_paleta_c <- function(familia = "turquesa", ...) {
  scale_color_gradientn(colours = paleta_familias[[familia]], ...)
}
scale_fill_paleta_c <- function(familia = "turquesa", ...) {
  scale_fill_gradientn(colours = paleta_familias[[familia]], ...)
}

# Continuas divergentes (centradas en `centro`)
scale_color_paleta_div <- function(centro = 0, ...) {
  scale_color_gradient2(low = paleta_divergente[1], mid = paleta_divergente[4],
                        high = paleta_divergente[7], midpoint = centro, ...)
}
scale_fill_paleta_div <- function(centro = 0, ...) {
  scale_fill_gradient2(low = paleta_divergente[1], mid = paleta_divergente[4],
                       high = paleta_divergente[7], midpoint = centro, ...)
}

# Fija el tema y los colores por defecto para toda la sesión, de modo que
# no haga falta agregar theme_paleta() ni scale_*_paleta() a cada gráfica.
aplicar_estilo <- function(base_size = 11, base_family = paleta_fuente) {
  theme_set(theme_paleta(base_size, base_family))
  options(
    ggplot2.discrete.colour   = paleta_categorica,
    ggplot2.discrete.fill     = paleta_categorica,
    ggplot2.continuous.colour = function(...) scale_color_paleta_c(...),
    ggplot2.continuous.fill   = function(...) scale_fill_paleta_c(...)
  )
  update_geom_defaults("line",  list(colour = paleta_categorica[1], linewidth = 0.9))
  update_geom_defaults("point", list(colour = paleta_categorica[1]))
  update_geom_defaults("text",  list(family = base_family, colour = paleta_texto))
  update_geom_defaults("label", list(family = base_family, colour = paleta_texto))
  update_geom_defaults("col",   list(fill = paleta_categorica[1]))
  update_geom_defaults("bar",   list(fill = paleta_categorica[1]))
  invisible(NULL)
}

# Guarda la gráfica en uno o varios formatos
guardar_grafica <- function(grafica, nombre, carpeta = ".", formatos = c("png", "pdf"),
                            ancho = 8, alto = 4.5, dpi = 300) {
  dir.create(carpeta, showWarnings = FALSE, recursive = TRUE)
  rutas <- file.path(carpeta, paste0(nombre, ".", formatos))
  for (ruta in rutas) {
    dispositivo <- NULL
    # PNG con ragg: respeta los colores exactos y usa la Inter incluida
    if (grepl("\\.png$", ruta)) {
      dispositivo <- ragg::agg_png
    }
    # PDF con showtext: dibuja el texto con la Inter incluida en cualquier sistema
    if (grepl("\\.pdf$", ruta)) {
      showtext::showtext_auto(TRUE)
      on.exit(showtext::showtext_auto(FALSE), add = TRUE)
      ggsave(ruta, grafica, device = grDevices::pdf, width = ancho, height = alto,
             bg = paleta_fondo)
      showtext::showtext_auto(FALSE)
      next
    }
    ggsave(ruta, grafica, device = dispositivo, width = ancho, height = alto,
           dpi = dpi, bg = paleta_fondo)
  }
  invisible(rutas)
}
