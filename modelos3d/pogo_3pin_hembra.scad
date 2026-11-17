// =====================================================
//  Conector magnético Pogo Pin 3 pines — HEMBRA (contactos planos)
//  Montaje: con cables (colas traseras para soldar)
//  Derivada del plano del macho "3Pin spacing 2.54mm":
//  misma cara de acople, imanes con polaridad invertida (S izq., N der.)
//  Ejes: X = largo (contactos alineados en X), Y = ancho, Z = alto
//  Origen: centro de la base; cara de acople en Z = alto_cuerpo
//  Unidades: milímetros
// =====================================================

// ================= VARIABLES GLOBALES =================

// --- 1. Cuerpo (óvalo / estadio) ---
largo_cuerpo    = 15;
ancho_cuerpo    = 4;
alto_cuerpo     = 4;

// --- 2. Pestaña perimetral ---
largo_pestana   = 17;
pestana_z0      = 0.9;
pestana_esp     = 0.9;

// --- 3. Imanes (S a la izquierda, N a la derecha) ---
sep_imanes      = 11;
d_iman          = 3;
alto_iman       = 2;

// --- 4. Contactos planos ---
n_pines         = 3;
paso            = 2.54;
d_contacto      = 1.51;  // mismo Ø que el alojamiento del pin macho
rebaje_contacto = 0.1;   // leve hundimiento para que el contacto se distinga en el STEP
d_cola          = 0.7;
largo_cola      = 1.5;

// --- Calidad / tolerancias ---
eps = 0.01;
$fn = 32;


// ================= UTILIDADES =================
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

// Asientos de los contactos (hundidos rebaje_contacto en la cara de acople)
module rebajes() {
    for (i = [0 : n_pines - 1])
        translate([x_pin(i), 0, alto_cuerpo - rebaje_contacto])
            cylinder(d = d_contacto, h = rebaje_contacto + 1, $fn = 24);
}


// ================= 3. IMANES =================
module imanes() {
    for (x = [-sep_imanes / 2, sep_imanes / 2])
        translate([x, 0, alto_cuerpo - alto_iman])
            cylinder(d = d_iman, h = alto_iman);
}


// ================= 4. CONTACTOS =================
// Disco de contacto + cola trasera para soldar el cable
module contacto() {
    translate([0, 0, alto_cuerpo - rebaje_contacto - 1])
        cylinder(d = d_contacto - 0.2, h = 1, $fn = 24);   // queda dentro del asiento
    translate([0, 0, -largo_cola])
        cylinder(d = d_cola, h = largo_cola + eps, $fn = 16);
}

module contactos() {
    for (i = [0 : n_pines - 1])
        translate([x_pin(i), 0, 0]) contacto();
}


// ================= ENSAMBLE =================
module pogo_hembra() {
    color("#1c1c1c") difference() { carcasa(); rebajes(); }
    color("#9a9a9a") imanes();
    color("#d4af37") contactos();
}

pogo_hembra();
