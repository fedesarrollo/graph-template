# Mantenimiento

Para quien administra el repositorio. Si solo quiere hacer gráficas, vaya al [inicio](README.md) y elija su lenguaje.

## Contenido del repositorio

```
graph-template/
├── README.md                # Portada: enlaces a las guías
├── MANTENIMIENTO.md         # Este archivo
├── paleta.json              # Fuente única de los colores (referencia)
├── paleta.jpeg              # Imagen original de la paleta
├── pyproject.toml           # Hace instalable el paquete de Python
├── docs/                    # Botones de la portada
├── python/                  # Paquete "fedesarrollo_estilo_graficas" + guía (README.md)
├── R/                       # Paquete "fedesarrollo.estilo.graficas" + guía (README.md)
├── stata/                   # Paquete "fedesarrollo_estilo_graficas" (net install) + guía (README.md)
└── ejemplos/                # Datos, scripts de ejemplo y gráficas generadas
```

## Cambiar o agregar colores

`paleta.json` es la referencia. Si un color cambia, actualícelo en:

- `paleta.json`
- `python/fedesarrollo_estilo_graficas/__init__.py`
- `R/R/fedesarrollo_estilo_graficas.R`
- `stata/scheme-fedesarrollo_estilo_graficas.scheme` y `stata/fedesarrollo_estilo_graficas.ado` (en Stata los colores van en RGB, por ejemplo `#DA5E46` → `"218 94 70"`)
- La sección "Colores" de las tres guías (`python/README.md`, `R/README.md`, `stata/README.md`)

Si cambia la paleta categórica, vuelva a revisar que los colores se distingan entre sí, también con daltonismo, antes de publicarla.

## Publicar una versión nueva

1. Suba la versión en `pyproject.toml`, `R/DESCRIPTION` y `stata/fedesarrollo_estilo_graficas.ado`, y la fecha `Distribution-Date` en `stata/fedesarrollo_estilo_graficas.pkg`.
2. Regenere las gráficas de ejemplo (`python ejemplos/ejemplo_python.py` y `Rscript ejemplos/ejemplo_r.R`).
3. Haga push a `main` de `fedesarrollo/graph-template`.
4. Pida a los usuarios que vuelvan a correr el comando de instalación de su guía.
