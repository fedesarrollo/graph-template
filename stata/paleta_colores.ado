*! paleta_colores 0.3.0
*! Crea globales con los colores de la paleta en formato RGB "R G B"
*! y fija Inter como fuente de las gráficas (debe estar instalada en el sistema).
*! Uso:  paleta_colores   y luego   color("$coral")  o  color("$turquesa3")
*! Tono 1 = más claro, tono 5 = más intenso. El nombre sin número es el tono 5.
program define paleta_colores
    version 14

    global gris1       "242 242 242"   // #F2F2F2
    global gris2       "224 224 224"   // #E0E0E0
    global gris3       "205 205 205"   // #CDCDCD
    global gris4       "168 168 168"   // #A8A8A8
    global gris5       "150 150 150"   // #969696
    global gris        "150 150 150"   // #969696

    global ambar1      "245 219 180"   // #F5DBB4
    global ambar2      "242 208 158"   // #F2D09E
    global ambar3      "237 187 113"   // #EDBB71
    global ambar4      "234 176 90"   // #EAB05A
    global ambar5      "231 165 68"   // #E7A544
    global ambar       "231 165 68"   // #E7A544

    global naranja1    "248 208 182"   // #F8D0B6
    global naranja2    "246 194 160"   // #F6C2A0
    global naranja3    "241 166 117"   // #F1A675
    global naranja4    "239 152 95"   // #EF985F
    global naranja5    "237 138 73"   // #ED8A49
    global naranja     "237 138 73"   // #ED8A49

    global coral1      "240 191 181"   // #F0BFB5
    global coral2      "236 172 159"   // #ECAC9F
    global coral3      "231 152 137"   // #E79889
    global coral4      "222 113 92"   // #DE715C
    global coral5      "218 94 70"   // #DA5E46
    global coral       "218 94 70"   // #DA5E46

    global turquesa1   "228 234 235"   // #E4EAEB
    global turquesa2   "201 226 229"   // #C9E2E5
    global turquesa3   "146 211 218"   // #92D3DA
    global turquesa4   "118 203 212"   // #76CBD4
    global turquesa5   "91 195 206"   // #5BC3CE
    global turquesa    "91 195 206"   // #5BC3CE

    * Paleta categórica (mismo orden que el scheme y que Python/R)
    global cat1       "91 195 206"   // #5BC3CE
    global cat2       "218 94 70"   // #DA5E46
    global cat3       "231 165 68"   // #E7A544
    global cat4       "150 150 150"   // #969696
    global cat5       "237 138 73"   // #ED8A49
    global cat6       "146 211 218"   // #92D3DA
    global cat7       "231 152 137"   // #E79889
    global cat8       "237 187 113"   // #EDBB71

    * Paleta divergente: turquesa (negativo) -> gris claro -> coral (positivo)
    global div1       "91 195 206"   // #5BC3CE
    global div2       "146 211 218"   // #92D3DA
    global div3       "201 226 229"   // #C9E2E5
    global div4       "242 242 242"   // #F2F2F2
    global div5       "240 191 181"   // #F0BFB5
    global div6       "231 152 137"   // #E79889
    global div7       "218 94 70"   // #DA5E46

    global texto            "0 0 0"   // #000000
    global texto_secundario "0 0 0"   // #000000
    global ejes             "0 0 0"   // #000000
    global cuadricula       "224 224 224"   // #E0E0E0

    * Fuente Inter para pantalla, PNG, PDF, SVG y EPS
    capture graph set window fontface "Inter"
    local error_fuente = _rc
    capture graph set svg fontface "Inter"
    capture graph set eps fontface "Inter"
    capture graph set ps  fontface "Inter"

    display as text "Colores de la paleta cargados como globales (coral, turquesa3, cat1-cat8, div1-div7, ...)."
    if `error_fuente' {
        display as error "No se pudo fijar la fuente Inter. Instálela desde https://rsms.me/inter/"
    }
    else {
        display as text "Fuente de las gráficas: Inter."
    }
end
