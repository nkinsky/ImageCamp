% Pixel to Centimeter Conversion Factors

%% 201A

square_cm = 25.4;
square_sides_pix = [- mean([192.554,191.169]) + mean([423.896 428.052]) ...
    mean([346.8208,346.8208]) - mean([112.37 109.595])]; % From 5/21 G19 square arena calibration file
avg_square_side_pix = mean(square_sides_pix);
square_pix_to_cm = 639/1023*25.4/avg_square_side_pix;

rectangle_in = [25.4 12.0]; % From 5/30 G19 rectangle calibration file
rectangle_cm = 2.54*rectangle_in;
rectangle_sides_pix = [276.364 132.486]*2;
rectangle_pix_to_cm = 639/1023*rectangle_cm./rectangle_sides_pix;

triangle_cm = 15.2*2.54;
triangle_side_pix = 493.16 - 155;
triangle_pix_to_cm = 639/1023*triangle_cm/triangle_side_pix;

pix_to_cm_201A_mean = mean([triangle_pix_to_cm square_pix_to_cm rectangle_pix_to_cm]);


