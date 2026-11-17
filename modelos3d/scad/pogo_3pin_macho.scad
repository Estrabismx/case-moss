// =====================================================
//  Conector magnético Pogo Pin 3 pines — MACHO (pines retráctiles)
//  Montaje: con cables (colas traseras para soldar)
//  Fuente de cotas: plano del fabricante "3Pin spacing 2.54mm"
//  Ejes: X = largo (pines alineados en X), Y = ancho, Z = alto
//  Origen: centro de la base; cara de acople en Z = alto_cuerpo
//  Unidades: milímetros
// =====================================================

// ================= VARIABLES GLOBALES =================

// --- 1. Cuerpo (óvalo / estadio) ---
largo_cuerpo   = 15;     // cota 15,00
ancho_cuerpo   = 4;      // cota 4,00
alto_cuerpo    = 4;      // cota 4,00

// --- 2. Pestaña perimetral ---
largo_pestana  = 17;     // cota 17,00
pestana_z0     = 0.9;    // medido a escala (desde la base)
pestana_esp    = 0.9;    // medido a escala

// --- 3. Imanes (N a la izquierda, S a la derecha) ---
sep_imanes     = 11;     // cota 11,00 entre centros
d_iman         = 3;      // medido a escala
alto_iman      = 2;      // cota 2,00 (al ras de la cara de acople)

// --- 4. Pines ---
n_pines        = 3;
paso           = 2.54;   // cota 2,54
d_punta        = 0.9;    // cota Ø0,90
alto_punta     = 1;      // sobresale 1,00 (altura de trabajo 5,00)
d_cola         = 0.7;    // cota Ø0,70
largo_cola     = 1.5;    // cota 1,50

// --- Calidad / tolerancias ---
eps = 0.01;
$fn = 32;


// ================= UTILIDADES =================
// Óvalo (estadio) centrado de largo L, ancho A y alto H
module estadio(L, A, H) {
    hull()
        for (x = [-(L - A) / 2, (L - A) / 2])
            translate([x, 0, 0]) cylinder(d = A, h = H);
}

function x_pin(i) = (i - (n_pines - 1) / 2) * paso;


// ================= 1-2. CARCASA =================
module carcasa() {
    estadio(largo_cuerpo, ancho_cuerpo, alto_cuerpo);
    translate([0, 0, pestana_z0])
        estadio(largo_pestana, ancho_cuerpo, pestana_esp);
}


// ================= 3. IMANES =================
module imanes() {
    for (x = [-sep_imanes / 2, sep_imanes / 2])
        translate([x, 0, alto_cuerpo - alto_iman])
            cylinder(d = d_iman, h = alto_iman);
}


// ================= 4. PINES =================
// Punta retráctil con extremo semiesférico + cola para soldar el cable
module pin() {
    r = d_punta / 2;
    // Punta (parte de la base hundida eps para unirse al cuerpo)
    translate([0, 0, alto_cuerpo - eps]) {
        cylinder(d = d_punta, h = alto_punta - r + eps, $fn = 16);
        translate([0, 0, alto_punta - r + eps]) sphere(r = r, $fn = 16);
    }
    // Cola trasera
    translate([0, 0, -largo_cola])
        cylinder(d = d_cola, h = largo_cola + eps, $fn = 16);
}

module pines() {
    for (i = [0 : n_pines - 1])
        translate([x_pin(i), 0, 0]) pin();
}


// ================= ENSAMBLE =================
module pogo_macho() {
    color("#1c1c1c") carcasa();
    color("#9a9a9a") imanes();
    color("#d4af37") pines();
}

pogo_macho();
