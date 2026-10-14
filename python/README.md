# Guía de Python

Paquete `estilo_graficas` para matplotlib (sirve también para pandas y seaborn, que usan matplotlib). Para la paleta, el contraste y las reglas generales, vea el [README principal](../README.md).

## 1. Instalar

Una vez por computador, desde la terminal (o con `!pip install ...` en un notebook). Instala también `matplotlib` y la fuente Inter, que viene incluida:

```bash
pip install git+https://github.com/fedesarrollo/graph-template
```

Para actualizar a la última versión:

```bash
pip install --upgrade git+https://github.com/fedesarrollo/graph-template
```

## 2. Aplicar el estilo

En cada script o notebook, antes de graficar:

```python
import matplotlib.pyplot as plt
import estilo_graficas as eg

eg.aplicar_estilo()   # todas las gráficas que se creen después usan el estilo
```

`aplicar_estilo()` acepta `tamano_fuente=11` y `fuente="Inter"` (puede poner otra fuente instalada, o `None` para la de matplotlib). Los PDF guardan el texto como texto editable.

## 3. Gráfica de líneas

Las series toman los colores de la paleta categórica en orden (coral, turquesa, ámbar, gris); no hace falta indicarlos.

```python
fig, ax = plt.subplots()
for grupo, d in datos.groupby("grupo"):
    ax.plot(d["anio"], d["valor"], label=grupo)
ax.set_title("Índice por región, 2015-2025")
eg.leyenda_abajo(ax)                                  # leyenda abajo, fuera del gráfico
eg.fuente_nota(fig, "Fuente: datos ilustrativos.")    # al final: queda debajo de la leyenda
eg.guardar(fig, "mi_grafica", carpeta="salida")       # crea salida/mi_grafica.png y .pdf
```

**Máximo cuatro series por gráfica.** Si dibuja más, matplotlib vuelve a empezar por coral sin avisar y dos series quedan del mismo color. Con más series use paneles (`plt.subplots(1, 2)`) o agrupe categorías.

## 4. Elegir colores a mano

```python
eg.COLORES["coral"]        # '#DA5E46' (tono 5)
eg.color("turquesa", 3)    # '#92D3DA'
eg.categorica(3)           # los 3 primeros colores categóricos (error si pide más de 4)
eg.secuencial("ambar", 4)  # 4 colores de la familia ámbar, de claro a oscuro
eg.divergente(7)           # 7 colores de turquesa a coral
```

Barras con un dato resaltado:

```python
colores = [eg.color("gris", 4)] * len(df)
colores[-1] = eg.COLORES["coral"]
ax.barh(df["grupo"], df["valor"], color=colores)
```

## 5. Texto dentro de la gráfica

Todo texto sale en negro por defecto, también las anotaciones y las etiquetas de valores:

```python
barras = ax.bar(df["grupo"], df["valor"])
ax.bar_label(barras, fmt="%.1f")          # etiquetas en negro
ax.annotate("Pandemia", xy=(2020, 93))    # anotación en negro
```

## 6. Mapas de color (heatmaps, mapas)

Al aplicar el estilo quedan registrados los colormaps `paleta_gris`, `paleta_ambar`, `paleta_naranja`, `paleta_coral`, `paleta_turquesa`, `paleta_divergente` y `paleta_categorica`:

```python
ax.imshow(tabla, cmap="paleta_divergente", vmin=-limite, vmax=limite)
# Con seaborn:   sns.heatmap(tabla, cmap="paleta_coral", annot=True)   # números en negro
# Con geopandas: gdf.plot(column="valor", cmap="paleta_turquesa")
```

Para escalas divergentes, use límites simétricos (`vmin=-x, vmax=x`) para que el cero quede en el color central.

## 7. Ejemplo completo

[ejemplos/ejemplo_python.py](../ejemplos/ejemplo_python.py) produce las tres gráficas de ejemplo. Requiere además `pandas`. Desde la raíz del repositorio:

```bash
python ejemplos/ejemplo_python.py
```
