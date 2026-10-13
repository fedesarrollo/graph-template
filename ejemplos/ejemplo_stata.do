* Ejemplo: las tres gráficas estándar en Stata.
*
* Requiere el paquete instalado (ver README).
* Ejecutar desde la raíz del repositorio (cd a la carpeta graph-template):
*   do ejemplos/ejemplo_stata.do

clear all
set scheme paleta
paleta_colores

import delimited "ejemplos/datos_ejemplo.csv", clear encoding("utf-8")
encode grupo, gen(g)

* 1. Líneas: cada serie toma un color del scheme automáticamente
separate valor, by(g) veryshortlabel
twoway line valor1 valor2 valor3 valor4 anio, ///
    title("Índice por región, 2015-2025", position(11) span) ///
    ytitle("Índice (2015 = 100 en Región A)") xtitle("") ///
    xlabel(2015(2)2025) legend(rows(1)) ///
    note("Fuente: datos ilustrativos.", span)
graph export "ejemplos/salida/stata_lineas.png", replace width(2400)

* 2. Barras: gris para todas, coral para destacar la más alta
preserve
keep if anio == 2025
sort valor
gen posicion = _n
labmask posicion, values(grupo)   // requiere: ssc install labutil
gen destacar = valor == valor[_N]
twoway (bar valor posicion if !destacar, horizontal barwidth(0.7) color("$gris4")) ///
       (bar valor posicion if  destacar, horizontal barwidth(0.7) color("$coral")), ///
    ylabel(1/4, valuelabel noticks) ytitle("") xtitle("") legend(off) ///
    title("Índice por región, 2025", position(11) span) ///
    note("Fuente: datos ilustrativos.", span)
graph export "ejemplos/salida/stata_barras.png", replace width(2400)
restore

* 3. Mapa de calor divergente: variación anual (%)
*    (requiere: ssc install heatplot, ssc install palettes, ssc install colrspace)
sort g anio
by g: gen variacion = (valor / valor[_n-1] - 1) * 100
capture which heatplot
if _rc == 0 {
    heatplot variacion i.g anio if anio > 2015, discrete ///
        colors("$div1" "$div2" "$div3" "$div4" "$div5" "$div6" "$div7", ipolate(21)) ///
        cuts(-10(1)10) ///
        title("Variación anual del índice (%)", position(11) span) ///
        ytitle("") xtitle("")
    graph export "ejemplos/salida/stata_calor.png", replace width(2400)
}
else {
    display as text "heatplot no está instalado; se omite el mapa de calor."
}
