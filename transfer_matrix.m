function S = transfer_matrix(index,angle,nair,varargin)
% returns transfer matrix for current interface
% inupt arguments: index matrix (containing index of currenr and next
% layer), angle of incidence, and index of air

% check is polarization is defined
if nargin > 3
    switch lower(varargin{1})
        case {'s','te'}
            % defines terms used in transfer matrix
            qj=sqrt(index(1,:).^2-(nair.^2)*(sin(angle))^2);
            qk=sqrt(index(2,:).^2-(nair.^2)*(sin(angle))^2);
            % reflection and transmission coefficients
            rjk=(qj-qk)./(qj+qk);
            tkj=2*qk./(qj+qk);
        case {'p','tm'}
            % defines terms used in transfer matrix
            qj=index(1,:)./index(2,:).*sqrt(index(2,:).^2 - (nair.^2)*(sin(angle))^2);
            qk=index(2,:)./index(1,:).*sqrt(index(1,:).^2 - (nair.^2)*(sin(angle))^2);
            % reflection and transmission coefficients
            rjk=(qj-qk)./(qj+qk);
            tkj=2*qj./(qj+qk).*index(2,:)./index(1,:);
        otherwise
            % if polarization is unknown, display error message
            error(['''', varargin{1},'''', ' is not a valid polarization. ',...
                'Valid input arguments are ''TE'', ''S'', ''TM'', and ''P''.'])
    end
else
    % if polarization is undefined, use defualt (TE)
    % defines terms used in transfer matrix
    qj=sqrt(index(1,:).^2-(nair.^2)*(sin(angle))^2);
    qk=sqrt(index(2,:).^2-(nair.^2)*(sin(angle))^2);
    % reflection and transmission coefficients
    rjk=(qj-qk)./(qj+qk);
    tkj=2*qk./(qj+qk);
end


% creates transfer matrix
S(1,1,:)=1./tkj;
S(1,2,:)=-rjk./tkj;
S(2,1,:)=S(1,2,:);
S(2,2,:)=S(1,1,:);