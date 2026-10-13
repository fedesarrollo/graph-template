"""Ejemplo: las tres gráficas estándar con matplotlib.

Requiere el paquete instalado (ver README) y pandas. Ejecutar:
    python ejemplos/ejemplo_python.py
"""

from pathlib import Path

import estilo_graficas as eg
import matplotlib.pyplot as plt
import pandas as pd

RAIZ = Path(__file__).resolve().parents[1]

eg.aplicar_estilo()
SALIDA = RAIZ / "ejemplos" / "salida"
datos = pd.read_csv(RAIZ / "ejemplos" / "datos_ejemplo.csv")

# 1. Líneas: cada grupo toma un color de la paleta categórica automáticamente
fig, ax = plt.subplots()
for grupo, d in datos.groupby("grupo"):
    ax.plot(d["anio"], d["valor"], label=grupo)
ax.set_title("Índice por región, 2015-2025")
ax.set_xlabel("")
ax.set_ylabel("Índice (2015 = 100 en Región A)")
ax.legend(loc="upper left", ncol=4)
eg.fuente_nota(fig, "Fuente: datos ilustrativos.")
eg.guardar(fig, "python_lineas", SALIDA, formatos=("png",))

# 2. Barras: un solo color para una sola serie, y un color de acento para destacar
ultimo = datos[datos["anio"] == 2025].sort_values("valor")
colores = [eg.color("gris", 4)] * len(ultimo)
colores[-1] = eg.COLORES["coral"]  # destaca el valor más alto
fig, ax = plt.subplots()
ax.barh(ultimo["grupo"], ultimo["valor"], color=colores)
ax.grid(axis="y", visible=False)
ax.grid(axis="x", visible=True)
ax.set_title("Índice por región, 2025")
eg.fuente_nota(fig, "Fuente: datos ilustrativos.")
eg.guardar(fig, "python_barras", SALIDA, formatos=("png",))

# 3. Mapa de calor con escala divergente: variación anual (%)
datos["variacion"] = datos.groupby("grupo")["valor"].pct_change() * 100
tabla = datos.pivot(index="grupo", columns="anio", values="variacion").drop(columns=2015)
limite = abs(tabla).max().max()
fig, ax = plt.subplots()
im = ax.imshow(tabla, cmap="paleta_divergente", vmin=-limite, vmax=limite, aspect="auto")
ax.set_xticks(range(len(tabla.columns)), tabla.columns)
ax.set_yticks(range(len(tabla.index)), tabla.index)
ax.grid(False)
ax.spines[["left", "bottom"]].set_visible(False)
barra = fig.colorbar(im, ax=ax, label="Variación anual (%)")
barra.outline.set_visible(False)
ax.set_title("Variación anual del índice (%)")
eg.guardar(fig, "python_calor", SALIDA, formatos=("png",))

print(f"Gráficas guardadas en {SALIDA}")
