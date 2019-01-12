function [width,index,nin] = index_and_thickness_vectors(lambda,mediums,layers,data) 

%lambda = [data_lam{1}:data_lam{3}:data_lam{2}]; %define wavelengths vector

%%%%Generate local data base, n(lambda), of refractive indices for all materials for selected wavelength range
    n_materials = length(data(:,1));
    n = cell(n_materials,3);              %intialize refractive index matrix for all materials
     
        for cnt=1:n_materials
            if strcmp(data{cnt,3}, 'dispersive')==1; %if material is dispersive (load from file)
                material_name=data{cnt,1};
                filename = data{cnt,5};                 %filename containing n,k values
                n{cnt,1} = material_name;
                n{cnt,3} = filename;                    %store file name for reference                        
                A = importdata(filename);              %import data lam,n,k data from file
                n{cnt,2} = interp1(A(:,1),A(:,2),lambda,'spline')...    %interpolate for selected wavelength range
                +1i*interp1(A(:,1),A(:,3),lambda, 'spline');
                
            else strcmp(data{cnt,2}, 'non-dispersive')==1;   %if material is non-dispersive set same index for all lambdas
                material_name=data{cnt,1};
                n{cnt,1} = material_name;
                n{cnt,2}=data{cnt,4}*ones(1, length(lambda));
            end
        end

%%%%Generate layers' thickness vector        
    ind = find([layers{:,2}] == 0,1,'first'); %find the last index of non-zero elements [syntex: find(what,how many, where)]
    width = [layers{1:ind-1,2}]; % generate thickness vector of layers from input to output (input and output have infinite thickness)

%%%% Generate refractive index vector (length must match "width") and n_in (refractive index of input medium) 
    idx = ismember(n(:,1), mediums{1});    %find input medium in index array (n)
    n_in=n{idx,2};                         %set refractive index of input medium
    
    index=[]; %initalize index array
    for cnt=1:length(width)         %for all layers after input medium
        idx = ismember(n(:,1), layers{cnt,1});    %find material in index array (n)
        index=[index; n{idx,2};];                       %add index to index vector
    end
    
    idx = ismember(n(:,1), mediums{2});    %find output medium in index array (n)
    n_out=n{idx,2};
    index=[index; n_out];
    

    
    
nin=n_in(1); %output to RAT catcher


end