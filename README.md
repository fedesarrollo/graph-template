# graph-template

Formato estándar de gráficas para **Python**, **R** y **Stata**, con la misma paleta de colores y la fuente **Inter** en los tres lenguajes. El objetivo es que una gráfica se vea igual sin importar en qué programa se hizo.

![Paleta](ejemplos/salida/paleta.png)

## Guías por lenguaje

| Lenguaje | Guía | Instalar (una vez) | Usar en cada script |
|---|---|---|---|
| **Python** | [python/README.md](python/README.md) | `pip install git+https://github.com/fedesarrollo/graph-template` | `import estilo_graficas as eg` y `eg.aplicar_estilo()` |
| **R** | [R/README.md](R/README.md) | `remotes::install_github("fedesarrollo/graph-template", subdir = "R")` | `library(estilograficas)` y `aplicar_estilo()` |
| **Stata** | [stata/README.md](stata/README.md) | `net install paleta, from("https://raw.githubusercontent.com/fedesarrollo/graph-template/main/stata") replace` | `set scheme paleta` y `paleta_colores` |

Para **actualizar** (por ejemplo, si cambia un color), vuelva a correr el comando de instalación. En Python agregue `--upgrade`.

## La paleta

Hay cinco familias de color. Cada una tiene cinco tonos, del **1 (más claro)** al **5 (más oscuro)**. Cuando se nombra una familia sin número (por ejemplo, "coral"), se refiere al tono 5.

| Familia    | 1         | 2         | 3         | 4         | 5         |
|------------|-----------|-----------|-----------|-----------|-----------|
| `gris`     | `#F2F2F2` | `#E0E0E0` | `#CDCDCD` | `#A8A8A8` | `#969696` |
| `ambar`    | `#F5DBB4` | `#F2D09E` | `#EDBB71` | `#EAB05A` | `#E7A544` |
| `naranja`  | `#F8D0B6` | `#F6C2A0` | `#F1A675` | `#EF985F` | `#ED8A49` |
| `coral`    | `#F0BFB5` | `#ECAC9F` | `#E79889` | `#DE715C` | `#DA5E46` |
| `turquesa` | `#E4EAEB` | `#C9E2E5` | `#92D3DA` | `#76CBD4` | `#5BC3CE` |

A partir de estas familias se definen tres paletas de uso:

- **Categórica** (para distinguir grupos): **coral → turquesa → ámbar → gris**, todos en el tono más oscuro (5). Las series toman los colores en ese orden. Son solo cuatro a propósito: ver [Contraste](#contraste).
- **Secuencial** (para valores de menor a mayor): los cinco tonos de una sola familia, de claro a oscuro.
- **Divergente** (para valores alrededor de un centro, como variaciones positivas y negativas): turquesa → gris claro → coral.

El texto (títulos, ejes, etiquetas y cualquier texto dentro de la gráfica) y los ejes van en **negro** (`#000000`). La cuadrícula va en gris claro (`#E0E0E0`).

## Contraste

Las combinaciones se revisaron midiendo la distancia perceptual entre colores (CAM02-UCS), con visión normal y simulando los tres tipos de daltonismo, y el contraste contra el fondo blanco y el texto negro (WCAG).

- **Texto negro sobre cualquier color de la paleta: siempre legible** (contraste de 5.7:1 o más). Por eso todo texto dentro de las gráficas (etiquetas de barras, valores en mapas de calor, anotaciones) va en negro.
- **Los 4 colores categóricos se distinguen entre sí en cualquier combinación**, también con daltonismo. Desde el quinto color la paleta no alcanza: ámbar y naranja se vuelven casi iguales con daltonismo, y los tonos claros se confunden con su versión oscura. Con más de cuatro series use paneles o agrupe categorías. R da un error si una gráfica tiene más de cuatro grupos; las guías de cada lenguaje explican qué pasa en Python y Stata.
- **Los colores son claros frente al fondo blanco.** Solo coral 4 y 5 superan el contraste de 3:1 que se recomienda para líneas y puntos. Por eso el estilo usa líneas gruesas, y los tonos 1 a 3 se reservan para rellenos de áreas grandes (barras, mapas, mapas de calor), nunca para líneas finas ni puntos.
- **Para resaltar un dato**, use gris 4 para el resto y coral para el destacado: se distinguen claramente, también con daltonismo.

## La fuente: Inter

Todas las gráficas usan [Inter](https://rsms.me/inter/) (licencia SIL Open Font License, que permite redistribuirla).

- **Python y R:** Inter viene **incluida en el paquete**. No hay que instalar nada más.
- **Stata:** Stata solo usa fuentes instaladas en el sistema, así que hay que **instalar Inter en el computador una vez**. Las instrucciones están en la [guía de Stata](stata/README.md#1-instalar-inter).

## Reglas del formato

1. Fuente Inter. Fondo blanco, sin recuadro alrededor de la gráfica.
2. Texto y ejes en **negro**, incluido el texto dentro de la gráfica. Solo líneas de cuadrícula horizontales, en gris claro. En Python y R no se dibuja la línea del eje vertical (en Stata sí, porque un scheme no permite quitar solo esa).
3. Título en negrita, alineado a la izquierda. La leyenda va abajo, sin título.
4. La fuente de los datos va en una nota abajo a la izquierda.
5. **Máximo cuatro colores por gráfica**, empezando por los más oscuros (coral, turquesa, ámbar, gris). Con más series, use paneles o agrupe.
6. Para resaltar un dato, ponga el resto en `gris` (tono 4) y el dato destacado en `coral`.
7. Exporte en PNG a 300 dpi para documentos y presentaciones, y en PDF cuando se necesite calidad vectorial.

## Ejemplos

Cada lenguaje tiene un script que produce las mismas tres gráficas (líneas, barras con un dato resaltado y mapa de calor divergente) a partir de [ejemplos/datos_ejemplo.csv](ejemplos/datos_ejemplo.csv). Cómo correrlos está en cada guía.

| Python | R |
|---|---|
| ![](ejemplos/salida/python_lineas.png) | ![](ejemplos/salida/r_lineas.png) |
| ![](ejemplos/salida/python_barras.png) | ![](ejemplos/salida/r_barras.png) |
| ![](ejemplos/salida/python_calor.png) | ![](ejemplos/salida/r_calor.png) |

## Contenido del repositorio

```
graph-template/
├── paleta.json              # Fuente única de los colores (referencia)
├── paleta.jpeg              # Imagen original de la paleta
├── pyproject.toml           # Hace instalable el paquete de Python
├── python/                  # Paquete de Python "estilo_graficas" + guía
├── R/                       # Paquete de R "estilograficas" + guía
├── stata/                   # Paquete de Stata "paleta" (net install) + guía
└── ejemplos/                # Datos, scripts de ejemplo y gráficas generadas
```

## Cambiar o agregar colores

`paleta.json` es la referencia. Si un color cambia, actualícelo en `paleta.json`, `python/estilo_graficas/__init__.py`, `R/R/estilo_graficas.R`, `stata/scheme-paleta.scheme` y `stata/paleta_colores.ado` (en Stata los colores van en RGB, por ejemplo `#DA5E46` → `"218 94 70"`). Si cambia la paleta categórica, vuelva a revisar el contraste entre los colores.

Luego suba la versión en `pyproject.toml`, `R/DESCRIPTION` y `stata/paleta_colores.ado`, y pida a los usuarios que vuelvan a correr el comando de instalación.
