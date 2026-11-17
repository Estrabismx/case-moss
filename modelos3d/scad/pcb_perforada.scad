// =====================================================
//  PCB perforada (perfboard) de 40 × 60 mm
//  Grilla de 14 × 20 agujeros, paso 2,54 mm, centrada en la placa
//  4 agujeros de montaje en las esquinas
//  Ejes: X = ancho (40), Y = largo (60), Z = espesor
//  Origen: esquina inferior izquierda de la cara inferior
//  Unidades: milímetros
// =====================================================

// ================= VARIABLES GLOBALES =================

// --- 1. Placa ---
ancho_x   = 40;
largo_y   = 60;
espesor_z = 1.6;     // FR4 estándar

// --- 2. Grilla de perforaciones ---
paso      = 2.54;    // 0,1"
cols_x    = 14;
filas_y   = 20;
d_agujero = 1.0;

// --- 3. Agujeros de montaje ---
d_montaje      = 2.0;
margen_montaje = 2.0;   // distancia del borde al centro del agujero

// --- Calidad / tolerancias ---
eps = 0.1;
$fn = 16;

// Esquina de la grilla (centro del primer agujero) para que quede centrada
grilla_x0 = (ancho_x - (cols_x  - 1) * paso) / 2;   // 3,49 mm
grilla_y0 = (largo_y - (filas_y - 1) * paso) / 2;   // 5,87 mm


// ================= 1. SUSTRATO =================
module sustrato() {
    cube([ancho_x, largo_y, espesor_z]);
}


// ================= 2. PERFORACIONES =================
module agujero(d) {
    translate([0, 0, -eps]) cylinder(d = d, h = espesor_z + 2 * eps);
}

module perforaciones() {
    for (i = [0 : cols_x - 1], j = [0 : filas_y - 1])
        translate([grilla_x0 + i * paso, grilla_y0 + j * paso, 0])
            agujero(d_agujero);
}


// ================= 3. AGUJEROS DE MONTAJE =================
module agujeros_montaje() {
    for (x = [margen_montaje, ancho_x - margen_montaje],
         y = [margen_montaje, largo_y - margen_montaje])
        translate([x, y, 0]) agujero(d_montaje, $fn = 24);
}


// ================= ENSAMBLE =================
module pcb_perforada() {
    color("#c8a24a")   // FR4 / baquelita
    difference() {
        sustrato();
        perforaciones();
        agujeros_montaje();
    }
}

pcb_perforada();
