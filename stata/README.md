# Guía de Stata

Paquete `paleta`: un scheme y el comando `paleta_colores`. Para la paleta, el contraste y las reglas generales, vea el [README principal](../README.md).

## 1. Instalar Inter

Stata solo usa fuentes instaladas en el sistema, así que hay que instalar Inter una vez por computador:

- **macOS:** descargue el ZIP de [rsms.me/inter](https://rsms.me/inter/download/), abra la carpeta `extras/ttf` y haga doble clic en `Inter-Regular.ttf` y `Inter-Bold.ttf` → *Instalar*. También sirve `brew install --cask font-inter`.
- **Windows:** el mismo ZIP; clic derecho sobre los `.ttf` → *Instalar para todos los usuarios*.

Después de instalarla, reinicie Stata.

## 2. Instalar el paquete

Una vez por computador:

```stata
net install paleta, from("https://raw.githubusercontent.com/fedesarrollo/graph-template/main/stata") replace
```

Para actualizar, vuelva a correr el mismo comando.

## 3. Aplicar el estilo

Al inicio de cada do-file:

```stata
set scheme paleta
paleta_colores
```

- `set scheme paleta` aplica el fondo blanco, la cuadrícula horizontal, el texto y los ejes en negro, la leyenda abajo y los colores de las series en orden: `p1` = coral, `p2` = turquesa, `p3` = ámbar, `p4` = gris. Para no tener que escribirlo cada vez, corra una sola vez `set scheme paleta, permanently`.
- `paleta_colores` fija Inter como fuente de las gráficas y crea los colores como globales (ver abajo).

**Máximo cuatro series por gráfica.** Desde la quinta, Stata usa colores que no son de la paleta. Con más series use `by()` o agrupe categorías.

## 4. Usar los colores por nombre

`paleta_colores` crea globales con cada color en formato RGB:

```stata
* $coral, $turquesa, $ambar, $naranja, $gris   -> tono 5
* $coral1 ... $coral5                          -> tonos de cada familia (1 = claro, 5 = oscuro)
* $cat1 ... $cat4                              -> paleta categórica
* $div1 ... $div7                              -> paleta divergente
```

Se usan dentro de `color()`, entre comillas:

```stata
twoway (line valor anio if grupo == "Región A", lcolor("$coral")) ///
       (line valor anio if grupo == "Región B", lcolor("$turquesa")), ///
    title("Índice por región", position(11) span) ///
    note("Fuente: datos ilustrativos.", span)
graph export "salida/mi_grafica.png", replace width(2400)
```

Barras con un dato resaltado: use `"$gris4"` para el resto y `"$coral"` para el destacado.

## 5. Consejos

- `title(..., position(11) span)` alinea el título a la izquierda, como en Python y R.
- `graph export ..., width(2400)` da una resolución equivalente a 300 dpi para una gráfica de 8 pulgadas.
- El texto dentro de la gráfica (etiquetas de barras con `blabel()`, etiquetas de puntos con `mlabel()`, `text()`) sale en negro.
- Para mapas de calor o mapas, `heatplot` y `spmap` aceptan los globales en `colors()`. Por ejemplo, `colors("$div1" "$div2" "$div3" "$div4" "$div5" "$div6" "$div7", ipolate(21))` (requiere `ssc install heatplot`, `palettes` y `colrspace`).

## 6. Ejemplo completo

[ejemplos/ejemplo_stata.do](../ejemplos/ejemplo_stata.do) produce las tres gráficas de ejemplo. Requiere `ssc install labutil` (y `heatplot` para el mapa de calor). Desde la raíz del repositorio:

```stata
cd "ruta/a/graph-template"
do ejemplos/ejemplo_stata.do
```
