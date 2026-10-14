# Guía de Stata

**scheme y colores** · [← Volver al inicio](../README.md)

Tres pasos: instalar una vez, activar el estilo en cada script y hacer la gráfica como siempre.

## Paso 1. Instalar (una sola vez por computador)

**a) La fuente Inter.** Stata solo usa fuentes instaladas en el computador:

- **macOS:** descargue el ZIP de [rsms.me/inter](https://rsms.me/inter/download/), abra la carpeta `extras/ttf` y haga doble clic en `Inter-Regular.ttf` y `Inter-Bold.ttf` → *Instalar*.
- **Windows:** el mismo ZIP; clic derecho sobre los `.ttf` → *Instalar para todos los usuarios*.

Después reinicie Stata.

**b) El paquete.** En Stata:

```stata
net install fedesarrollo_estilo_graficas, from("https://raw.githubusercontent.com/fedesarrollo/graph-template/main/stata") replace
```

## Paso 2. Activar el estilo (al inicio de cada script)

```stata
fedesarrollo_estilo_graficas
```

Esta línea activa todo: el scheme (fondo, ejes, leyenda y colores de las series), los colores por nombre y la fuente Inter.

## Paso 3. Hacer la gráfica

Copie este ejemplo, córralo y use la gráfica como punto de partida:

```stata
fedesarrollo_estilo_graficas

sysuse auto, clear
twoway (scatter price mpg if foreign == 0) ///
       (scatter price mpg if foreign == 1), ///
    title("Precio y rendimiento", position(11) span) ///
    note("Fuente: auto.dta", span) ///
    legend(order(1 "Nacional" 2 "Extranjero"))
graph export "mi_grafica.png", replace width(2400)
```

Los colores salen solos, en orden: coral, turquesa, ámbar, gris. `position(11) span` deja el título a la izquierda y `width(2400)` da la calidad para documentos.

## Antes de entregar una gráfica

- [ ] Inter instalada en el computador (una sola vez).
- [ ] `fedesarrollo_estilo_graficas` al inicio del do-file.
- [ ] Máximo **4 series** por gráfica. Desde la quinta, Stata usa colores que no son de la paleta.
- [ ] Título con `position(11) span`, fuente de datos con `note("Fuente: ...", span)`.
- [ ] Exportar con `graph export "nombre.png", replace width(2400)`.

## Recetas

### Usar un color por nombre

`fedesarrollo_estilo_graficas` crea los colores como globales. Se usan dentro de `color()`, entre comillas:

```stata
twoway (line valor anio if grupo == "Región A", lcolor("$coral")) ///
       (line valor anio if grupo == "Región B", lcolor("$turquesa"))
```

### Resaltar un dato

Use `"$gris4"` para el resto y `"$coral"` para el destacado:

```stata
twoway (bar valor posicion if !destacar, horizontal color("$gris4")) ///
       (bar valor posicion if  destacar, horizontal color("$coral")), legend(off)
```

### Poner números o texto dentro de la gráfica

Las etiquetas de barras (`blabel()`), de puntos (`mlabel()`) y el texto con `text()` salen en negro.

### Mapas de calor y mapas

`heatplot` y `spmap` aceptan los globales en `colors()`:

```stata
heatplot variacion i.grupo anio, ///
    colors("$div1" "$div2" "$div3" "$div4" "$div5" "$div6" "$div7", ipolate(21))
```

Requiere `ssc install heatplot`, `ssc install palettes` y `ssc install colrspace`.

### Más de 4 series

Divida en paneles con `by(variable)`.

## Problemas comunes

| Si pasa esto | Haga esto |
|---|---|
| `command fedesarrollo_estilo_graficas is unrecognized` | Falta instalar el paquete: corra el `net install` del paso 1. |
| La gráfica no sale en Inter | Inter no está instalada en el computador, o no reinició Stata después de instalarla. |
| Desde la quinta serie aparecen colores raros | La paleta tiene 4 colores. Use `by()` o agrupe categorías. |
| No veo los cambios de una versión nueva | Vuelva a correr el `net install ... replace` del paso 1. |

---

## Referencia

### Colores

Hay cinco familias de color, cada una con cinco tonos, del **1 (más claro)** al **5 (más oscuro)**. Cuando se nombra una familia sin número (por ejemplo, "coral"), se refiere al tono 5.

![Paleta](../ejemplos/salida/paleta.png)

| Familia    | 1 (claro) | 2         | 3         | 4         | 5 (oscuro) |
|------------|-----------|-----------|-----------|-----------|------------|
| `gris`     | `#F2F2F2` | `#E0E0E0` | `#CDCDCD` | `#A8A8A8` | `#969696`  |
| `ambar`    | `#F5DBB4` | `#F2D09E` | `#EDBB71` | `#EAB05A` | `#E7A544`  |
| `naranja`  | `#F8D0B6` | `#F6C2A0` | `#F1A675` | `#EF985F` | `#ED8A49`  |
| `coral`    | `#F0BFB5` | `#ECAC9F` | `#E79889` | `#DE715C` | `#DA5E46`  |
| `turquesa` | `#E4EAEB` | `#C9E2E5` | `#92D3DA` | `#76CBD4` | `#5BC3CE`  |

Se usan de tres formas:

| Para qué | Colores | Cuándo |
|---|---|---|
| **Categórica** | coral → turquesa → ámbar → gris (tono 5) | Distinguir grupos o series. Máximo 4. |
| **Secuencial** | Los 5 tonos de una familia, de claro a oscuro | Valores de menor a mayor (mapas, mapas de calor). |
| **Divergente** | turquesa → gris claro → coral | Valores alrededor de un centro, como variaciones positivas y negativas. |

El texto y los ejes van en **negro** (`#000000`) y la cuadrícula en gris claro (`#E0E0E0`).

Para usarlos en Stata:

```stata
* $coral, $turquesa, $ambar, $naranja, $gris   -> tono 5
* $coral1 ... $coral5                          -> tonos de cada familia (1 = claro, 5 = oscuro)
* $cat1 ... $cat4                              -> paleta categórica
* $div1 ... $div7                              -> paleta divergente
```

### Reglas del formato

1. Fuente Inter. Fondo blanco, sin recuadro alrededor de la gráfica.
2. Texto y ejes en **negro**, incluido el texto dentro de la gráfica. Solo líneas de cuadrícula horizontales, en gris claro.
3. Título en negrita, alineado a la izquierda. La leyenda va abajo, sin título.
4. La fuente de los datos va en una nota abajo a la izquierda.
5. **Máximo cuatro colores por gráfica**, en este orden: coral, turquesa, ámbar, gris. Con más series, use paneles o agrupe.
6. Para resaltar un dato, ponga el resto en gris (tono 4) y el dato destacado en coral.
7. Exporte en PNG a 300 dpi para documentos y presentaciones, y en PDF cuando se necesite calidad vectorial.

### Contraste: por qué solo 4 colores

Las combinaciones se revisaron midiendo cuánto se distinguen los colores entre sí, con visión normal y simulando los tres tipos de daltonismo, y su contraste contra el fondo blanco y el texto negro.

- **Texto negro sobre cualquier color de la paleta: siempre se lee** (contraste de 5.7:1 o más). Por eso todo texto dentro de las gráficas va en negro.
- **Los 4 colores categóricos se distinguen en cualquier combinación**, también con daltonismo. Desde el quinto la paleta no alcanza: ámbar y naranja se vuelven casi iguales con daltonismo, y los tonos claros se confunden con su versión oscura.
- **Los colores son claros frente al fondo blanco.** Por eso las líneas son gruesas, y los tonos 1 a 3 se usan solo como relleno de áreas grandes (barras, mapas), nunca en líneas finas ni puntos.
- **Gris 4 y coral** se distinguen claramente, por eso son la combinación para resaltar un dato.

### Fuente: Inter

Todas las gráficas usan [Inter](https://rsms.me/inter/) (licencia SIL Open Font License). Hay que **instalarla en el computador** (ver el paso 1). `fedesarrollo_estilo_graficas` la fija como fuente de las gráficas y Stata recuerda ese ajuste.

### Ejemplo completo del repositorio

[ejemplos/ejemplo_stata.do](../ejemplos/ejemplo_stata.do) produce tres gráficas de ejemplo (líneas, barras y mapa de calor). Requiere `ssc install labutil` y `heatplot` para el mapa de calor. Desde la raíz del repositorio:

```stata
cd "ruta/a/graph-template"
do ejemplos/ejemplo_stata.do
```
