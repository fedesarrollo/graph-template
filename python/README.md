# Guía de Python

**matplotlib (sirve también para pandas y seaborn)** · [← Volver al inicio](../README.md)

Tres pasos: instalar una vez, activar el estilo en cada script y hacer la gráfica como siempre.

## Paso 1. Instalar (una sola vez por computador)

Desde la terminal:

```bash
pip install git+https://github.com/fedesarrollo/graph-template
```

En un notebook de Jupyter, use `%pip install git+https://github.com/fedesarrollo/graph-template` y reinicie el kernel.

Esto instala también matplotlib y la fuente Inter. **No hay que instalar nada más.**

## Paso 2. Activar el estilo (al inicio de cada script)

```python
import matplotlib.pyplot as plt
import estilo_graficas as eg

eg.aplicar_estilo()
```

## Paso 3. Hacer la gráfica

Copie este ejemplo, córralo y use la gráfica como punto de partida:

```python
import matplotlib.pyplot as plt
import estilo_graficas as eg

eg.aplicar_estilo()

anios = [2021, 2022, 2023, 2024, 2025]
fig, ax = plt.subplots()
ax.plot(anios, [100, 104, 109, 113, 118], label="Región A")
ax.plot(anios, [92, 96, 99, 100, 107], label="Región B")
ax.set_title("Índice por región, 2021-2025")
eg.leyenda_abajo(ax)                                 # leyenda abajo
eg.fuente_nota(fig, "Fuente: datos ilustrativos.")   # siempre al final
eg.guardar(fig, "mi_grafica")                        # crea mi_grafica.png y mi_grafica.pdf
```

Los colores salen solos, en orden: coral, turquesa, ámbar, gris.

![](../ejemplos/salida/python_lineas.png)

## Antes de entregar una gráfica

- [ ] `eg.aplicar_estilo()` al inicio del script.
- [ ] Máximo **4 series** por gráfica. Si dibuja más, matplotlib repite los colores **sin avisar**.
- [ ] `eg.leyenda_abajo(ax)` para la leyenda.
- [ ] `eg.fuente_nota(fig, "Fuente: ...")` **al final**, después de la leyenda.
- [ ] Guardar con `eg.guardar(fig, "nombre")`.

## Recetas

### Resaltar un dato

```python
colores = [eg.color("gris", 4)] * len(df)
colores[-1] = eg.COLORES["coral"]
ax.barh(df["grupo"], df["valor"], color=colores)
```

### Poner números o texto dentro de la gráfica

Todo texto sale en negro por defecto:

```python
barras = ax.bar(df["grupo"], df["valor"])
ax.bar_label(barras, fmt="%.1f")
ax.annotate("Pandemia", xy=(2020, 93))
```

### Mapas de calor y mapas

```python
ax.imshow(tabla, cmap="paleta_divergente", vmin=-limite, vmax=limite)
# seaborn:   sns.heatmap(tabla, cmap="paleta_coral", annot=True, annot_kws={"color": "black"})
# geopandas: gdf.plot(column="valor", cmap="paleta_turquesa")
```

Colormaps disponibles: `paleta_gris`, `paleta_ambar`, `paleta_naranja`, `paleta_coral`, `paleta_turquesa`, `paleta_divergente`. En los divergentes use límites simétricos (`vmin=-x, vmax=x`) para que el cero quede en el color del centro.

### Más de 4 series

Divida en paneles:

```python
fig, (ax1, ax2) = plt.subplots(1, 2, sharey=True, figsize=(10, 4.5))
```

### Otro tamaño de letra o de figura

```python
eg.aplicar_estilo(tamano_fuente=13)
fig, ax = plt.subplots(figsize=(6, 4))   # en pulgadas
```

## Problemas comunes

| Si pasa esto | Haga esto |
|---|---|
| `ModuleNotFoundError: No module named 'estilo_graficas'` | El paquete se instaló en otro Python. En un notebook, corra `%pip install git+https://github.com/fedesarrollo/graph-template` en una celda y reinicie el kernel. |
| Dos series salieron del mismo color | Tiene más de 4 series. Divídalas en paneles o agrupe categorías. |
| La nota de fuente se monta sobre la leyenda | Llame `eg.fuente_nota(...)` después de `eg.leyenda_abajo(ax)`. |
| No veo los cambios de una versión nueva | Actualice con `pip install --upgrade git+https://github.com/fedesarrollo/graph-template`. |

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

Para usarlos en Python:

```python
eg.COLORES["coral"]        # '#DA5E46' (tono 5)
eg.color("turquesa", 3)    # '#92D3DA'
eg.categorica(3)           # los 3 primeros colores categóricos (error si pide más de 4)
eg.secuencial("ambar", 4)  # 4 colores de la familia ámbar, de claro a oscuro
eg.divergente(7)           # 7 colores de turquesa a coral
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

Todas las gráficas usan [Inter](https://rsms.me/inter/) (licencia SIL Open Font License). Viene **incluida en el paquete**: no hay que instalarla. Los PDF guardan el texto como texto editable. Para usar otra fuente instalada: `eg.aplicar_estilo(fuente="Arial")`.

### Así se ven

![](../ejemplos/salida/python_lineas.png)

![](../ejemplos/salida/python_barras.png)

![](../ejemplos/salida/python_calor.png)

### Ejemplo completo del repositorio

[ejemplos/ejemplo_python.py](../ejemplos/ejemplo_python.py) produce las tres gráficas de arriba. Requiere además `pandas`. Desde la raíz del repositorio:

```bash
python ejemplos/ejemplo_python.py
```
