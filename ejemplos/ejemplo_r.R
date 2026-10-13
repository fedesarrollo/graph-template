# Ejemplo: las tres gráficas estándar con ggplot2.
#
# Requiere el paquete instalado (ver README). Ejecutar desde la raíz del repositorio:
#   Rscript ejemplos/ejemplo_r.R

library(estilograficas)
aplicar_estilo()

salida <- "ejemplos/salida"
datos <- read.csv("ejemplos/datos_ejemplo.csv", encoding = "UTF-8")

# 1. Líneas: cada grupo toma un color de la paleta categórica automáticamente
g1 <- ggplot(datos, aes(anio, valor, color = grupo)) +
  geom_line() +
  scale_x_continuous(breaks = seq(2015, 2025, 2)) +
  labs(title = "Índice por región, 2015-2025",
       x = NULL, y = "Índice (2015 = 100 en Región A)",
       caption = "Fuente: datos ilustrativos.")
guardar_grafica(g1, "r_lineas", salida, formatos = "png")

# 2. Barras: un solo color para una sola serie, y un color de acento para destacar
ultimo <- subset(datos, anio == 2025)
ultimo$destacar <- ultimo$valor == max(ultimo$valor)
g2 <- ggplot(ultimo, aes(valor, reorder(grupo, valor), fill = destacar)) +
  geom_col(width = 0.7) +
  scale_fill_manual(values = c(`FALSE` = paleta_color("gris", 4),
                               `TRUE` = paleta_colores[["coral"]]),
                    guide = "none") +
  labs(title = "Índice por región, 2025", x = NULL, y = NULL,
       caption = "Fuente: datos ilustrativos.") +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.major.x = element_line(color = paleta_cuadricula, linewidth = 0.4),
        axis.line.x = element_blank(), axis.ticks.x = element_blank())
guardar_grafica(g2, "r_barras", salida, formatos = "png")

# 3. Mapa de calor con escala divergente: variación anual (%)
datos <- datos[order(datos$grupo, datos$anio), ]
datos$variacion <- ave(datos$valor, datos$grupo,
                       FUN = function(v) c(NA, diff(v) / head(v, -1) * 100))
calor <- subset(datos, anio > 2015)
limite <- max(abs(calor$variacion))
g3 <- ggplot(calor, aes(factor(anio), grupo, fill = variacion)) +
  geom_tile(color = "white") +
  scale_fill_paleta_div(centro = 0, limits = c(-limite, limite),
                        name = "Variación anual (%)") +
  labs(title = "Variación anual del índice (%)", x = NULL, y = NULL) +
  theme(legend.position = "right", legend.title = element_text(size = rel(0.85)),
        panel.grid.major.y = element_blank(), axis.line.x = element_blank(), axis.ticks.x = element_blank())
guardar_grafica(g3, "r_calor", salida, formatos = "png")

cat("Gráficas guardadas en", salida, "\n")
