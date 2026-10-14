# Guía de R

Paquete `estilograficas` para ggplot2. Para la paleta, el contraste y las reglas generales, vea el [README principal](../README.md).

## 1. Instalar

Una vez por computador. Instala también `ragg` y `showtext`, que el paquete usa para respetar los colores exactos y la fuente Inter (incluida) al exportar:

```r
install.packages("remotes")
remotes::install_github("fedesarrollo/graph-template", subdir = "R")
```

Para actualizar, vuelva a correr la segunda línea.

## 2. Aplicar el estilo

En cada script:

```r
library(estilograficas)   # también carga ggplot2
aplicar_estilo()          # tema, fuente y colores por defecto para toda la sesión
```

Si prefiere no cambiar la sesión, agregue el tema y las escalas a cada gráfica:

```r
ggplot(datos, aes(anio, valor, color = grupo)) +
  geom_line() +
  scale_color_paleta() +
  theme_paleta()
```

## 3. Gráfica de líneas

```r
g <- ggplot(datos, aes(anio, valor, color = grupo)) +
  geom_line() +
  labs(title = "Índice por región, 2015-2025",
       x = NULL, y = "Índice",
       caption = "Fuente: datos ilustrativos.")

guardar_grafica(g, "mi_grafica", carpeta = "salida")   # PNG y PDF, 8 x 4.5 pulgadas
```

Use `guardar_grafica()` en lugar de `ggsave()`: es la que garantiza que la fuente y los colores salgan bien. Acepta `formatos`, `ancho`, `alto` (en pulgadas) y `dpi`. En el panel de gráficas de RStudio la fuente puede verse distinta; el archivo guardado es el que vale.

**Máximo cuatro series por gráfica.** Con cinco o más grupos, ggplot da un error que lo indica. Use `facet_wrap()` o agrupe categorías.

## 4. Escalas disponibles

| Uso | Color (líneas, puntos) | Relleno (barras, áreas, mapas) |
|---|---|---|
| Categórica | `scale_color_paleta()` | `scale_fill_paleta()` |
| Secuencial | `scale_color_paleta_c("coral")` | `scale_fill_paleta_c("coral")` |
| Divergente | `scale_color_paleta_div(centro = 0)` | `scale_fill_paleta_div(centro = 0)` |

## 5. Elegir colores a mano

```r
paleta_colores[["coral"]]     # "#DA5E46"
paleta_color("turquesa", 3)   # "#92D3DA"
paleta_cat(3)                 # 3 primeros colores categóricos (error si pide más de 4)
paleta_sec(4, "ambar")        # 4 colores de la familia ámbar, de claro a oscuro
paleta_div(7)                 # 7 colores de turquesa a coral
```

Barras con un dato resaltado:

```r
ggplot(df, aes(valor, reorder(grupo, valor), fill = valor == max(valor))) +
  geom_col() +
  scale_fill_manual(values = c(`FALSE` = paleta_color("gris", 4),
                               `TRUE`  = paleta_colores[["coral"]]),
                    guide = "none")
```

## 6. Texto dentro de la gráfica

Con `aplicar_estilo()`, `geom_text()` y `geom_label()` salen en negro y con Inter:

```r
ggplot(df, aes(grupo, valor)) +
  geom_col() +
  geom_text(aes(label = round(valor, 1)), vjust = -0.5)   # etiquetas en negro
```

Si usa `annotate()`, agregue `family = paleta_fuente` para que también salga en Inter.

## 7. Ejemplo completo

[ejemplos/ejemplo_r.R](../ejemplos/ejemplo_r.R) produce las tres gráficas de ejemplo. Desde la raíz del repositorio:

```bash
Rscript ejemplos/ejemplo_r.R
```
