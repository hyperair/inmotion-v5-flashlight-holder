use <MCAD/array/along_curve.scad>
use <MCAD/shapes/2Dshapes.scad>
include <MCAD/units/metric.scad>

handle_width = 30.5;
handle_thickness = 16.1;

mount_length = 30;
mount_width = 35;

flashlight_angle = -20;

$fs = 0.4;
$fa = 1;

module flashlight_shape ()
{
    translate ([0, 0, -36]) {
        cylinder (d = 28.6, h = 52.61);

        translate ([0, 0, 52.61 - epsilon])
        intersection () {
            cylinder (d = 26.52, h = 18);
            cube ([24.35, 30, 1000], center = true);
        }

        translate ([0, 0, 52.61 + 18 - epsilon * 2])
        cylinder (d = 28.6, h = 3);
    }
}

module handle_shape ()
{
    linear_extrude (height = 30)
    hull ()
    mcad_linear_multiply (no = 2, separation = handle_width - handle_thickness,
                          center = true, axis = X)
    circle (d = handle_thickness);
}

module place_flashlight ()
{
    translate ([0, 0, 60])
    rotate (flashlight_angle, X)
    rotate (-90, X)
    children ();
}

render ()
difference () {
    union () {
        ccube ([mount_width, 30, 40], center = X);

        intersection () {
            hull () {
                place_flashlight ()
                cylinder (d = mount_width, h = 100, center = true);

                translate ([0, 0, 20])
                ccube ([mount_width, 30, epsilon], center = X);
            }

            ccube ([mount_width, 30, 100], center = X);
        }

        hull () {
            d = handle_thickness + 3;

            mcad_linear_multiply (no = 2, separation = mount_width - d,
                                  axis = X, center = true)
            rotate (-90, X)
            cylinder (d = d, h = mount_length);
        }
    }

    rotate (-90, X)
    handle_shape ();

    place_flashlight ()
    flashlight_shape ();

    /* bottom cutout */
    translate ([0, 0, -handle_width * 0.2])
    mirror (Z)
    ccube (100, center = X + Y);

    /* top cutout */
    translate ([0, 0, 7])
    place_flashlight ()
    rotate (90, X)
    ccube (100, center = X + Y);

}
