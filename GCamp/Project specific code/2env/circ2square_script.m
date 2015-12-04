%% circle to square play around script

%% Just playing around here
kc = 15; % cm
ks = pi()*kc/2; % cm

theta = -pi():pi()/100:3*pi()/2;

R_c = kc;

% Get square radius
for j = 1:length(theta)
    if theta(j) < -3*pi/4 || (-pi/4 < theta(j) & theta(j) < pi/4) || (3*pi/4 < theta(j) & theta(j) < 5*pi/4)
        R_s(j) = ks*sqrt(1 + tan(theta(j))^2);
    else
        R_s(j) = ks*sqrt(1 + 1/tan(theta(j))^2);
    end
    
end

x = R_s.*cos(theta);
y = R_s.*sin(theta);

figure
plot(x,y); xlim([-30 30])

%% Take session from circle and make it a circle if it is distorted

true_rad = 28.66;

[f, x] = ecdf(x_adj_cm);
xspan = x(find(f > 0.95,1,'first')) - x(find(f < 0.05,1,'last'));
[f, y] = ecdf(y_adj_cm);
yspan = y(find(f > 0.95,1,'first')) - y(find(f < 0.05,1,'last'));

x_use = x_adj_cm*true_rad/xspan;
y_use = y_adj_cm*true_rad/yspan;

%% Run transformation

% convert x and y to polar coordinates

