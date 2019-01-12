%% Calculates the reflectance (R), transmittance (T), and absorbance (A)

%% Input parameters:
% lambda = [1,n] vector of wavelength
% width = [1,m] vector containing the width of each layer
%   width(1) = top layer, width(end) = bottom layer
%   units must be the same as lambda
% index = [m+1,n] matrix of the refractive indices of each layer
%   index(i,j) = index of the ith layer at lambda(j)
%   index(m+1,:) = refractive index of the substrate
% angles = [1,k] vector containing angles of incidence in degrees
% varargin = optional parameter for polarization
%   valid inputs are 'TE', 'TM', 'S', or 'P' default value = 'TE'
%
% Uses functions: propagator, and transfer_matrix
%%
function [R, T, A] = multi_layer(width, index, lambda, angles, n_in, varargin)

% check if polarization is specified
if nargin > 5
    % set polarization
    polarization = varargin{1};
else
    % set default polarization
    polarization = 'TE';
end

% define n_in
%n_in

% declare spectral variables
R = zeros(length(angles),length(lambda));
T = zeros(length(angles),length(lambda));
A = zeros(length(angles),length(lambda));

%%%% start calculations %%%%

% loop for each angle of incidence
h = waitbar(0,'Please wait...');
steps = length(angles);

for p=1:length(angles)
    % convert to radians
    angle = angles(p)*pi/180;
    
    % from air to first layer
    S = transfer_matrix([n_in;index(1,:)],angle,n_in,polarization);

    % all other layers
    for j=1:length(width)
        % propagation matrix jth layer
        Lj = propagator(lambda,width(j),index(j,:), n_in, angle);
        % tranfer matrix from layer j to (j+1)
        Ijk = transfer_matrix([index(j,:);index(j+1,:)], angle, n_in, polarization);
        
        % for each lambda
        for k=1:length(lambda)
            % transfer through layer j and into layer j+1
            S(:,:,k)=Ijk(:,:,k)*Lj(:,:,k)*S(:,:,k);
        end
    end
    
    % calculates R and T
    R(p,:)=abs((S(2,1,:)./S(2,2,:))).^2;
    % T = (n_subs*cos(theta_subs)/(n_1*cos(theta_1))*abs(t)^2
    T(p,:)=real(reshape(...
        abs(S(1,1,:)+S(1,2,:) .* (-S(2,1,:)./S(2,2,:))).^2, size(n_in)).*...
        sqrt(index(end,:).^2-(n_in*sin(angle)).^2) ./ (n_in*cos(angle)));

    % absorbance
    A(p,:)=1-R(p,:)-T(p,:);
    
    waitbar(p / steps)
end

close(h)