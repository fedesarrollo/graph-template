"""Estilo estándar de gráficas para matplotlib (y seaborn/pandas, que usan matplotlib).

Uso rápido:
    import estilo_graficas as eg
    eg.aplicar_estilo()
    ...
    eg.guardar(fig, "mi_grafica")

Los colores y la fuente (Inter) son los mismos de R/ y stata/.
"""

from pathlib import Path

import matplotlib as mpl
import matplotlib.pyplot as plt
from cycler import cycler
from matplotlib import font_manager
from matplotlib.colors import LinearSegmentedColormap, ListedColormap

# Inter viene incluida en el paquete (licencia SIL OFL, ver fuentes/OFL.txt)
FUENTE = "Inter"
CARPETA_FUENTES = Path(__file__).parent / "fuentes"

# ---------------------------------------------------------------------------
# Paleta (tono 1 = más claro, tono 5 = más intenso)
# ---------------------------------------------------------------------------
FAMILIAS = {
    "gris":     ["#F2F2F2", "#E0E0E0", "#CDCDCD", "#A8A8A8", "#969696"],
    "ambar":    ["#F5DBB4", "#F2D09E", "#EDBB71", "#EAB05A", "#E7A544"],
    "naranja":  ["#F8D0B6", "#F6C2A0", "#F1A675", "#EF985F", "#ED8A49"],
    "coral":    ["#F0BFB5", "#ECAC9F", "#E79889", "#DE715C", "#DA5E46"],
    "turquesa": ["#E4EAEB", "#C9E2E5", "#92D3DA", "#76CBD4", "#5BC3CE"],
}

# Colores principales con nombre (el tono más intenso de cada familia)
COLORES = {nombre: tonos[-1] for nombre, tonos in FAMILIAS.items()}

# Orden por defecto para series categóricas: primero los colores más distinguibles
CATEGORICA = ["#5BC3CE", "#DA5E46", "#E7A544", "#969696",
              "#ED8A49", "#92D3DA", "#E79889", "#EDBB71"]

# Divergente: turquesa (negativo) -> gris claro (centro) -> coral (positivo)
DIVERGENTE = ["#5BC3CE", "#92D3DA", "#C9E2E5", "#F2F2F2",
              "#F0BFB5", "#E79889", "#DA5E46"]

# Texto y ejes en negro; la cuadrícula en gris claro
TEXTO = "#000000"
TEXTO_SECUNDARIO = "#000000"
EJES = "#000000"
CUADRICULA = "#E0E0E0"
FONDO = "#FFFFFF"


def color(familia, tono=5):
    """Devuelve un color por familia y tono (1-5). Ej.: color("coral", 3)."""
    if familia not in FAMILIAS:
        raise ValueError(f"Familia desconocida: {familia!r}. Opciones: {', '.join(FAMILIAS)}.")
    if tono not in range(1, 6):
        raise ValueError(f"El tono debe estar entre 1 y 5; se pidió {tono}.")
    return FAMILIAS[familia][tono - 1]


def categorica(n=None):
    """Primeros n colores de la paleta categórica."""
    if n is None:
        return list(CATEGORICA)
    if n > len(CATEGORICA):
        raise ValueError(f"La paleta categórica tiene {len(CATEGORICA)} colores; se pidieron {n}.")
    return CATEGORICA[:n]


def secuencial(familia="turquesa", n=None):
    """Colormap secuencial de una familia. Con n devuelve una lista de n colores."""
    cmap = LinearSegmentedColormap.from_list(f"paleta_{familia}", FAMILIAS[familia])
    if n is None:
        return cmap
    return [mpl.colors.to_hex(cmap(i / max(n - 1, 1))).upper() for i in range(n)]


def divergente(n=None):
    """Colormap divergente turquesa-gris-coral. Con n devuelve una lista de n colores."""
    cmap = LinearSegmentedColormap.from_list("paleta_divergente", DIVERGENTE)
    if n is None:
        return cmap
    return [mpl.colors.to_hex(cmap(i / max(n - 1, 1))).upper() for i in range(n)]


def _registrar_colormaps():
    """Registra los colormaps para usarlos por nombre: cmap="paleta_coral"."""
    mapas = {f"paleta_{f}": secuencial(f) for f in FAMILIAS}
    mapas["paleta_divergente"] = divergente()
    mapas["paleta_categorica"] = ListedColormap(CATEGORICA, name="paleta_categorica")
    for nombre, cmap in mapas.items():
        if nombre not in mpl.colormaps:
            mpl.colormaps.register(cmap, name=nombre)


def _registrar_fuentes():
    """Registra en matplotlib los archivos de Inter incluidos en el paquete."""
    for archivo in sorted(CARPETA_FUENTES.glob("*.ttf")):
        font_manager.fontManager.addfont(str(archivo))


def aplicar_estilo(tamano_fuente=11, fuente=FUENTE):
    """Aplica el estilo estándar a todas las gráficas que se creen después.

    tamano_fuente: tamaño base del texto.
    fuente: por defecto Inter (incluida en el paquete). Puede ser el nombre de otra
        fuente instalada, o None para usar la fuente por defecto de matplotlib.
    """
    _registrar_colormaps()
    _registrar_fuentes()
    parametros = {
        # Colores
        "axes.prop_cycle": cycler(color=CATEGORICA),
        "image.cmap": "paleta_turquesa",
        "figure.facecolor": FONDO,
        "axes.facecolor": FONDO,
        "savefig.facecolor": FONDO,
        "text.color": TEXTO,
        "axes.labelcolor": TEXTO,
        "axes.edgecolor": EJES,
        "xtick.color": TEXTO_SECUNDARIO,
        "ytick.color": TEXTO_SECUNDARIO,
        # Texto
        "font.size": tamano_fuente,
        "axes.titlesize": tamano_fuente + 3,
        "axes.titleweight": "bold",
        "axes.titlelocation": "left",
        "axes.titlepad": 12,
        "axes.labelsize": tamano_fuente,
        "xtick.labelsize": tamano_fuente - 1,
        "ytick.labelsize": tamano_fuente - 1,
        "legend.fontsize": tamano_fuente - 1,
        # Ejes y cuadrícula: solo líneas horizontales suaves
        "axes.spines.top": False,
        "axes.spines.right": False,
        "axes.spines.left": False,
        "axes.linewidth": 0.8,
        "axes.grid": True,
        "axes.grid.axis": "y",
        "axes.axisbelow": True,
        "grid.color": CUADRICULA,
        "grid.linewidth": 0.8,
        "xtick.major.size": 3,
        "ytick.major.size": 0,
        # Marcas
        "lines.linewidth": 2.2,
        "lines.markersize": 6,
        "patch.edgecolor": FONDO,
        # Leyenda
        "legend.frameon": False,
        # Figura y exportación
        "figure.figsize": (8, 4.5),
        "figure.dpi": 100,
        "savefig.dpi": 300,
        "savefig.bbox": "tight",
        # Incrusta la fuente en PDF/PS como TrueType (texto editable)
        "pdf.fonttype": 42,
        "ps.fonttype": 42,
    }
    if fuente:
        parametros["font.family"] = fuente
    mpl.rcParams.update(parametros)


def leyenda_arriba(ax, ncol=None):
    """Pone la leyenda arriba del gráfico, en una fila y alineada a la izquierda.

    Llamarla después de ax.set_title(): sube el título para dejar espacio a la leyenda.
    """
    handles, etiquetas = ax.get_legend_handles_labels()
    leyenda = ax.legend(handles, etiquetas, loc="lower left", bbox_to_anchor=(0, 1.01),
                        ncol=ncol or len(etiquetas), borderaxespad=0,
                        handlelength=1.5, columnspacing=1.5)
    titulo = ax.get_title(loc="left")
    if titulo:
        espacio = mpl.rcParams["axes.titlepad"] + 2.4 * mpl.rcParams["legend.fontsize"]
        ax.set_title(titulo, loc="left", pad=espacio)
    return leyenda


def fuente_nota(fig, texto):
    """Agrega una nota/fuente en la esquina inferior izquierda de la figura."""
    fig.text(0.01, -0.02, texto, ha="left", va="top",
             fontsize=mpl.rcParams["font.size"] - 2, color=TEXTO_SECUNDARIO)


def guardar(fig, nombre, carpeta=".", formatos=("png", "pdf")):
    """Guarda la figura en uno o varios formatos. Devuelve las rutas creadas."""
    carpeta = Path(carpeta)
    carpeta.mkdir(parents=True, exist_ok=True)
    rutas = []
    for formato in formatos:
        ruta = carpeta / f"{nombre}.{formato}"
        fig.savefig(ruta)
        rutas.append(ruta)
    return rutas


def muestra_paleta():
    """Dibuja todas las familias de la paleta (útil para revisar los colores)."""
    fig, ax = plt.subplots(figsize=(8, 3.5))
    for fila, (familia, tonos) in enumerate(FAMILIAS.items()):
        for col, hexa in enumerate(tonos):
            ax.add_patch(plt.Rectangle((col, -fila), 1, 0.9, color=hexa))
            ax.text(col + 0.5, -fila + 0.45, hexa, ha="center", va="center", fontsize=8)
        ax.text(-0.1, -fila + 0.45, familia, ha="right", va="center")
    ax.set_xlim(-1.2, 5)
    ax.set_ylim(-len(FAMILIAS) + 0.9, 1)
    ax.axis("off")
    return fig
