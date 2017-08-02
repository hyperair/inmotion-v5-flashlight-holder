use <MCAD/array/along_curve.scad>
use <MCAD/array/mirror.scad>
use <MCAD/shapes/2Dshapes.scad>
include <MCAD/units/metric.scad>

handle_width = 30.5;
handle_thickness = 16.1;

mount_length = 30;
mount_width = 36;
mount_radius = 3;

flashlight_angle = -20;

$fs = 0.4;
$fa = 1;

module flashlight_shape ()
{
    render ()
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
    handle_orbit_r = 250;

    render ()
    rotate (-90, Z)
    translate ([0, 0, -handle_orbit_r])
    rotate (90, X)
    rotate (10, Z)
    intersection () {
        rotate_extrude ()
        translate ([handle_orbit_r, 0])
        hull ()
        mcad_linear_multiply (no = 2, center = true, axis = Y,
                              separation = handle_width - handle_thickness)
        circle (d = handle_thickness);

        linear_extrude (height = handle_width * 2, center = true)
        pieSlice (size = handle_orbit_r + 10, start_angle = 0, end_angle = 90);
    }
}

module place_flashlight ()
{
    translate ([0, -mount_length / 2, 60])
    rotate (flashlight_angle, X)
    rotate (-90, X)
    children ();
}

module mount_shape ()
{
    linear_extrude (height = 40)
    offset (delta = mount_radius, chamfer = true)
    offset (-mount_radius)
    square ([mount_width, mount_length], center = true);
}

module chamfered_cylinder (d, h, center = false, chamfer_size = 0)
{
    off = 2 * chamfer_size * (1 - 1 / sqrt (2));
    inner_h = h - off  * 2;

    cylinder (d = d, h = inner_h, center = center);

    if (off > 0) {
        translate ([0, 0, center ? 0 : h / 2])
        mcad_mirror_duplicate (Z)
        translate ([0, 0, inner_h / 2])
        cylinder (d1 = d, d2 = d - off * 2, h = off);
    }
}

render ()
difference () {
    union () {
        mount_shape ();

        intersection () {
            hull () {
                place_flashlight ()
                cylinder (d = mount_width, h = 100, center = true);

                translate ([0, 0, 20])
                ccube ([mount_width, mount_length, epsilon], center = X + Y);
            }

            scale ([1, 1, 5])
            mount_shape ();
        }

        hull () {
            d = handle_thickness + 3;

            mcad_linear_multiply (no = 2, separation = mount_width - d,
                                  axis = X, center = true)
            rotate (-90, X)
            chamfered_cylinder (d = d, h = mount_length, center = true,
                                chamfer_size = mount_radius);
        }
    }

    #handle_shape ();

    #place_flashlight ()
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

    /* velcro attachment spot */
    translate ([0, 0, 15])
    ccube ([100, 15, 3], center = X + Y);
}
