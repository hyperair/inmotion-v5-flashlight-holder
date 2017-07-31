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
    cylinder (d = 28.6, h = 52.61);

    translate ([0, 0, 52.61 - epsilon])
    intersection () {
        cylinder (d = 26.52, h = 18);
        cube ([24.35, 30, 1000], center = true);
    }

    translate ([0, 0, 52.61 + 18 - epsilon * 2])
    cylinder (d = 28.6, h = 3);
}

module flashlight_stub ()
{
    render ()
    difference () {
        translate ([0, 0, -36])
        flashlight_shape ();

        *mirror (Z)
        cylinder (d = 50, h = 100);
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

module flashlight_clamp ()
{
    *render ()
    difference () {
        minkowski () {
            flashlight_stub ();
            cylinder (d = 10, h = epsilon);
        }

        flashlight_stub ();

        cylinder (d = 50, h = 5);
    }

    od = 31;

    render ()
    difference () {
        hull () {
            cylinder (d = od, h = mount_length);

            *translate ([0, -epsilon - od / 2])
            ccube ([od, epsilon, mount_length], center = X);
        }

        translate ([0, 0, -epsilon])
        flashlight_stub ();

        translate ([0, -od * 0.2])
        mirror (Y)
        ccube ([od, 50, mount_length], center = X);
    }
}

render ()
difference () {
    mount_width = 34;

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
    flashlight_stub ();

    /* bottom cutout */
    translate ([0, 0, -handle_width * 0.2])
    mirror (Z)
    ccube (100, center = X + Y);

    /* top cutout */
    translate ([0, 0, 60 + 7])
    rotate (flashlight_angle, X)
    ccube (100, center = X + Y);

}

*place_flashlight ()
flashlight_clamp ();
