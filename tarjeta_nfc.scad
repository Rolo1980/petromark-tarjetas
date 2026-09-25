// Tarjeta NFC impresa en 3D — Petromark
// Bolsillo interno para tag "coin" NTAG21x. Exportar STL desde OpenSCAD (F6 → F7).
// Imprimir con pausa en la capa donde se cierra el bolsillo (ver README.md).

/* ====== PARÁMETROS ====== */
ancho        = 85.6;   // mm (tamaño tarjeta de crédito)
alto         = 54.0;   // mm
espesor      = 3.0;    // mm total
radio_esq    = 3.0;    // mm, redondeo de esquinas

tag_diam     = 25.0;   // mm, diámetro del tag coin
tag_esp      = 0.4;    // mm, espesor del tag (los coin de 25 mm suelen ser 0.3–0.5)
holgura_diam = 0.6;    // mm extra al diámetro del bolsillo
holgura_esp  = 0.2;    // mm extra de altura del bolsillo
piso         = 1.2;    // mm de material debajo del tag
tag_x        = 0;      // desplazamiento del tag desde el centro (mm)
tag_y        = 0;

texto        = "petromark";
texto_alto   = 9;      // mm de altura de letra
texto_prof   = 0.6;    // mm de bajorrelieve (0 = sin texto)
fuente       = "Liberation Sans:style=Bold";

marca_lado   = true;   // muesca en la cara inferior para saber dónde está el tag

/* ====== MODELO ====== */
$fn = 96;

bolsillo_alto = tag_esp + holgura_esp;
bolsillo_diam = tag_diam + holgura_diam;
capa_pausa    = piso + bolsillo_alto;   // altura donde el slicer debe pausar

echo(str("PAUSAR el slicer en Z = ", capa_pausa, " mm (con capas de 0.2 → capa ", ceil(capa_pausa/0.2), ")"));

module cuerpo() {
    linear_extrude(height = espesor)
        offset(r = radio_esq) offset(delta = -radio_esq)
            square([ancho, alto], center = true);
}

module bolsillo() {
    translate([tag_x, tag_y, piso])
        cylinder(d = bolsillo_diam, h = bolsillo_alto);
}

module grabado() {
    if (texto_prof > 0)
        translate([0, alto/2 - 12, espesor - texto_prof])
            linear_extrude(height = texto_prof + 0.01)
                text(texto, size = texto_alto, font = fuente, halign = "center", valign = "center");
}

module muesca() {
    if (marca_lado)
        translate([tag_x, tag_y - bolsillo_diam/2 - 3, -0.01])
            cylinder(d = 2, h = 0.4);
}

difference() {
    cuerpo();
    bolsillo();
    grabado();
    muesca();
}
