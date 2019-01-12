function indices = return_index(names,data,lambda) 

%lambda = [data_lam{1}:data_lam{3}:data_lam{2}]; %define wavelengths vector

%%%%Generate local data base, n(lambda), of refractive indices for all materials for selected wavelength range
    n_materials = length(data(:,1));
    n = cell(n_materials,3);              %intialize refractive index matrix for all materials
     
        for cnt=1:n_materials
            if strcmp(data{cnt,3}, 'dispersive')==1; %if material is dispersive (load from file)
                material_name=data{cnt,1};
                filename = data{cnt,5};                 %filename containing n,k values
                n{cnt,1} = material_name;
                n{cnt,3} = filename;                   %store file name for reference                        
                A = importdata(filename);              %import data lam,n,k data from file
                n{cnt,2} = interp1(A(:,1),A(:,2),lambda,'spline')...    %interpolate for selected wavelength range
                +1i*interp1(A(:,1),A(:,3),lambda, 'spline');
                
            else strcmp(data{cnt,2}, 'non-dispersive')==1;   %if material is non-dispersive set same index for all lambdas
                material_name=data{cnt,1};
                n{cnt,1} = material_name;
                n{cnt,2}=data{cnt,4}*ones(1, length(lambda));
            end
        end

%%%% Generate refractive index vector (length must match "width") and n_in (refractive index of input medium) 
        
    indices=[]; %initalize index array
    for cnt=1:length(names)         %for all layers after input medium
        idx = ismember(n(:,1), names{cnt,1});    %find material in index array (n)
        indices=[indices; n{idx,2};];                       %add index to index vector
    end
    
    
end