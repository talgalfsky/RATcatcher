function P = propagator(lambda,width,index,nair,angle)
% creates propagator matrix
% input argumants: wavelength (lambda) width of layer (width), index of
% current layer (index), index of air (nair), angle of incidence (angle)

% n_i*cos(theta_i)
q=sqrt(index.^2-(nair.^2)*(sin(angle))^2);
% perpendicular component of k
b=2*pi*q./lambda;

% creates propagator matrix P
P(1,1,:)=exp(i*b.*width);
P(1,2,:)=0;
P(2,1,:)=0;
P(2,2,:)=exp(-i*b.*width);