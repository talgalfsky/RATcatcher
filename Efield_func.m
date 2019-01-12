function [pos, Efield, nval] = Efield_func(index,width,lambda,angle,steps,n_in,varargin)

% check if polarization is specified
if nargin > 5
    % set polarization
    polarization = varargin{1};
else
    % set default polarization
    polarization = 'TE';
end

lambda_res = length(lambda);
n_inp = n_in*ones(size(index(1,:)));

S = transfer_matrix([n_inp;index(1,:)], angle, n_inp, polarization);

Sright = zeros(2,2,length(width),length(lambda));

bj = zeros(length(width),length(lambda));

for j=1:length(width)
    % n_j*cos(theta_j)
    qj=sqrt(index(j,:).^2-(n_inp.^2)*(sin(angle))^2);
    % k for jth layer
    bj(j,:)=2*pi*qj./lambda;
    % propagator for jth layer
    Lj = propagator(lambda,width(j),index(j,:), n_inp, angle);
    % transfer matrix from layer j to layer j+1
    Ijk = transfer_matrix([index(j,:);index(j+1,:)], angle, n_inp, polarization);
    % total transfer matrix from the first to the jth layer
    Sright(:,:,j,:) = S(:,:,:);
    % for each wavelength
    for k=1:length(lambda)
        % transfer through the jth layer and into layer j+1
        S(:,:,k)=Ijk(:,:,k)*Lj(:,:,k)*S(:,:,k);
    end
end

% declare vector
% layerpos(k) is the position of the top of the kth layer
layerpos = zeros(1,length(width)+1);
for k=1:length(width)
    % postion of layer k+1 is the postion of kth + width of kth layer
    layerpos(k+1)=layerpos(k)+width(k);
end

% declare variables
% [1,steps] vector of the position along the entire structure
pos=linspace(0,layerpos(end),steps);
% nval(i,j) = refactive index at pos(i) and lambda(j)
nval = zeros(steps,lambda_res);
% reflection coefficient the entire structure for each lambda
r(1,1,1,:) = -S(2,1,:)./S(2,2,:);
% declare variable: Efield(i,j) = e-filed intensity at pos(i) and lambda(j)
Efield = zeros(steps,lambda_res);

% for each position
for k=1:steps
    % find the layer corresponding to pos(k)
    for j=1:length(width)
        % find layer in which pos(k) is located
        if pos(k)<layerpos(j+1)
            % j points to current layer
            break;
        end
    end
    %dj=width(j);
    % sets nval to the index of the layer
    nval(k,:) = index(j,:);
    % defines the depth from the beginning of the layer
    x=pos(k)-layerpos(j);
    % the amplitude of the forward traveling wave
    tpos = Sright(1,1,j,:)+r.*Sright(1,2,j,:);
    % the amplitude of the backward traveling wave
    tneg = Sright(2,1,j,:)+r.*Sright(2,2,j,:);
    % reshape them to have dimensions [1,lambda_res]
    tpos = reshape(tpos,1,lambda_res);
    tneg = reshape(tneg,1,lambda_res);
    % calculates the intensity
    Efield(k,:)=(abs(tpos.*exp(1i*bj(j,:)*x) + tneg.*exp(-1i*bj(j,:)*x))).^2;
end