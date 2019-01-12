%%%%%%%%% 'Reflectance, Absorbance, Transmittance catcher' %%%%%%%%%%%%%%%
% Copyright 2016 T. Galfsky, V. Menon, City College of the City University
% of New York

%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

% This code calculates the Reflectance, Transmission, and Absorption of a
% multilayer thin-film using dispersive or non-dispersive materials.

% The function RAT catcher outputs:
% 1) Selected polarization: "TE" or "TM"
% 2) R,T,A = Reflection, Transmission, Absorption matrix data

% 3) lambda and angles, lambda is the y-axis: wavelength vector in nm
% and angles is the x-axis: angles in deg, for the R,T,A matrix data.

% The materials to be used for the multilayer structure can be defined 
% inside the "Select Materials" tab as either non-disperesive (enter 
% a number for refractive index) or as dispersive (load index from file - 
% Row 1: wavelength in nm, Row 2: n, Row 3: k).
% 
% At this point in time (3.21.16) the code does not accept dispersive
% materials for the input medium.

function [pol,R,T,A,lambda,angles_in] = RATcatcher
    
    f = figure('Position',[500 150 700 620],'Name','R.A.T Catcher');
    set(f,'Visible','off');  %turn off visibility for figure until done building
    movegui(f,'center')
    
   %%%% toolbar part
    tb = uitoolbar(f);
    [X map] = imread('save.gif');
    % Convert indexed image and colormap to truecolor
    save_icon = ind2rgb(X,map);
    % Create a uipushtool in the toolbar
    hpt = uipushtool(tb,'CData',save_icon,...
                 'TooltipString','Save to file',...
                 'ClickedCallback',...
                 @savebutton);
    [X map] = imread('fileOpenIcon.gif');   
    load_icon = ind2rgb(X,map);
    hpt = uipushtool(tb,'CData',load_icon,...
                 'TooltipString','Open file',...
                 'ClickedCallback',...
                 @loadbutton);
       %%%% end of toolbar part
    
      
    load('data_select.mat');                 %load materials selected in materials selector - var name: data  
    load('data_RAT.mat');                  %load last snapshot of the figure
    %%% wavelength selection table
         %lam_init =    {300;800;0.5;};              %initialize wavelength selection
    t_lam = uitable('Parent',f,...
                'Position', [25 555 173 76], ...
                'Data',lam_out,...
                'ColumnName',{'wavelength (nm)'},...
                'RowName',{'start', 'end', 'step'},...
                'ColumnFormat', {'numeric'},...
                'ColumnEditable', [true], ...
                'ColumnWidth', {105}, ...
                'CellEditCallback',@out_lam);
        
    %%% Angle selection table
        %angle_init = {0; 90; 0.5;};
    t_angle = uitable('Parent',f,...
                'Position', [250 555 173 76], ...
                'Data',angle_out,...
                'ColumnName',{'angle (deg)'},...
                'RowName',{'start', 'end', 'step'},...
                'ColumnFormat', {'numeric'},...
                'ColumnEditable', [true], ...
                'ColumnWidth', {105}, ...
                'CellEditCallback',@out_angle);        
            
    %%% input and output medium table initialization
    %medium_name={'Air' ; 'SiO2'};
    in_out = medium_out;
    
    t_up = uitable('Parent',f,...
                'Position', [25 460 250 58], ...
                'Data',in_out,...
                'ColumnName',{'material name'},...
                'RowName',{'input medium', 'output medium'},...
                'ColumnFormat', {materials_out},...
                'ColumnEditable', [true], ...
                'ColumnWidth', {105}, ...
                'RowStriping', 'off', ...
                'CellEditCallback',@out_mediums);
    
    %%% thickness table
    % initialize layers for thickness table
    %%% setup section
    
    %data = {'mat1' 'from file' 0 false;...
    %        'mat2' 'non-dispersive' 1 false;...
    %        'mat3' 'non-dispersive' 1.45 false;};
    %num_materials=3;
    
    
    
%     layer_name=repmat({' '},101,1);
%     layer_thickness=num2cell(zeros(101,1));
%     layer_select=false;
%     layer_select=cell(101,1);  %set selector cells
%     
%     row_name=cell(1,101); %set row names
%     for ind=1:101
%         row_name{ind} = ['layer' ' ' num2str(ind)];
%         layer_select{ind} = false; 
%     end
%     
%     layer = [layer_name layer_thickness layer_select];   %intialized data for table
%     
    columnformat = {materials_out,'numeric','logical'};
    
    t = uitable('Parent',f,...
                'Position', [25 25 330 400], ...
                'Data',layers_out,...        %can use layer instead of layers_out to initialize 
                'ColumnName',{'material name', 'thickness(nm)',' '},...
                'RowName',row_name_out,...
                'ColumnFormat', columnformat,...
                'ColumnEditable', [true true true], ...
                'ColumnWidth', {100, 80, 30}, ...
                'CellEditCallback',@out_thickness);
    
    set(gcf, 'MenuBar', 'None');   %hide menu bar
    
    
    %buttons
    %%%polarization selector
    txtbox_pol = uicontrol('Parent',f,...
           'Style','text',...
           'HorizontalAlignment', 'left',...
           'BackgroundColor', [0.8 0.8 0.8],...
           'Position',[460 612 80 15],...
           'String','Polarization');
   
    id_init = id;   %1; %init selection value (1 or 2)
    popup1 = uicontrol('Parent',f,...
           'Style','popup',...
           'Position',[460 585 80 25],...
           'String',{'TM';'TE';},...
           'Callback',@save_pol);     
    set(popup1,'Value',id_init);
    %%%end of polarization selector
       
    btn1 = uicontrol('Parent',f,...
           'Position',[625 10 70 25],...
           'String','Close',...
           'Callback','delete(gcf)');
       
    btn2 = uicontrol('Parent',f,...    %%%% Generate graphs
           'Position',[570 355 80 50],...
           'String','Plot','Fontsize',12,...
           'Callback',@plot_new);    
    
    btn3 = uicontrol('Parent',f,...    %%%% Select materials
           'Position',[380 10 125 25],...
           'String','Select Materials',...
           'Callback',@call_materials_selector);  
    
    btn4 = uicontrol('Parent',f,...    %%%% Generate multilayers
           'Position',[380 345 125 25],...
           'String','Multiply selected by:',...
           'Callback',@multilayer);
    
    efield_button = uicontrol('Parent',f,...    %%%% Generate graphs
           'Position',[570 250 80 50],...
           'String','Plot E-Field','Fontsize',10,...
           'Callback',@plot_efield);       
       
       
    %txt box for multiplier
    txtbox_btn4 = uicontrol(f,'Style','edit',...
                'String','4',...
                'Position',[380 325 125 21]); 
       
    btn5 = uicontrol('Parent',f,...
           'Position',[380 380 125 25],...
           'String','Delete selected',...
           'Callback',@delete_rows);
       
    btn6 = uicontrol('Parent',f,...
           'Position',[380 290 125 25],...
           'String','DBR',...
           'Callback',@make_DBR);
       
    btn7 = uicontrol('Parent',f,...
           'Position',[380 255 125 25],...
           'String','Cavity',...
           'Callback',@make_cavity);    
    
    %%% delete rows   
    btn8 = uicontrol('Parent',f,...
           'Position',[380 200 125 25],...
           'String','Delete rows:',...
           'Callback',@del_rows);
    
    delbox = uicontrol(f,'Style','edit',...
                'String',' ',...
                'Position',[380 180 60 21]);    
    %%% end of delete rows     
       
       
    %%% callback functions 
    %initializations
    row_name = row_name_out;
    layer = layers_out;
    materials = materials_out;    %initialize materials output
    data_lam = lam_out;    %initialize wavelength output
    data_angle = angle_out; 
    data_mediums = medium_out;  %initialize mediums output   
    data_layers = layers_out;  %initialize thickness output
    table_data = layer;   %initialize table_data for multi
    idx_plot = idx_plot_out;    % 0 = RAT not yet calculated, 1 = RAT calculated for current config
    n_in = n_in_out;      %initialize n_in for graph_image
    lam_sel_init = '620';  %initialize selected lambda for E-field
    angle_sel_init = '0';  %initialize selected angle for E-field
    steps_sel_init = '20000';  %initialize steps for E-field
    %%%%%%%%%%%%%%%% functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        function out_lam(hObject,callbackdata)
             data_lam = get(hObject,'Data');
             idx_plot = 0;
        end
 
        function out_angle(hObject,callbackdata)
             data_angle = get(hObject,'Data');
             idx_plot = 0;
        end
    
        function out_thickness(hObject,callbackdata)
             data_layers = get(hObject,'Data');
             idx_plot = 0;
        end
    
        function out_mediums(hObject,callbackdata)
             data_mediums = get(hObject,'Data');
             idx_plot = 0;
        end
    
        function save_pol(hObject,callbackdata)
             id = get(hObject,'Value');
             idx_plot = 0;
        end
    
        function plot_new(hObject,callbackdata)
            %get polarization data
            id = get(popup1,'Value');
            popup_items = get(popup1,'String');
            pol = char(popup_items(id,:));
            %get wavelength, mediums, and layers data
            data_lam = get(t_lam,'Data');
            data_mediums = get(t_up,'Data');
            data_layers = get(t,'Data');
            data_angle = get(t_angle,'Data');
            lambda = [data_lam{1}:data_lam{3}:data_lam{2}];
            angles_in = [data_angle{1}:data_angle{3}:data_angle{2}];
            
            if idx_plot == 1
               graph_image(lambda,angles_in,R,T,A,n_in) 
            else            
                %%%graph_RAT is a function of: (1) selected wavelength range, (2) in/out mediums,...
                %%%(3) layers thickness, and (4) data is the database file of selected materials
                %%% funtion input (wavelength vector, input and output mediums,
                %%% layers, thickness, data=database of selected materials,
                %%% angles vector)
                %f_sub=figure;
                [R,T,A,n_in]=graph_RAT(lambda,data_mediums,data_layers,data,angles_in,pol);
                idx_plot = 1; %set plot index to 1 to indicate RAT was calculated for current setup
            end        
        end
    
        function plot_efield(hObject,callbackdata)
            %create pop-up box to select wavelength and angle
            prompt = {'Select wavelength:','Select angle:','Steps:'};
            dlg_title = 'Input';
            num_lines = 1;
            defaultans = {lam_sel_init,angle_sel_init,steps_sel_init};
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
            
            lambda_sel = str2num(answer{1}); %get selected wavelength
            angle_sel = str2num(answer{2}); %get selected angle
            lam_sel_init = answer{1};
            angle_sel_init = answer{2};
            steps_sel_init = answer{3};
            id = get(popup1,'Value');
            popup_items = get(popup1,'String');
            pol = char(popup_items(id,:));
            %get wavelength, mediums, and layers data
            data_mediums = get(t_up,'Data');
            data_layers = get(t,'Data');                      
            steps=str2num(answer{3});
            [width,index,nin]=index_and_thickness_vectors(lambda_sel,data_mediums,data_layers,data);
            index;
            [pos, Efield, nval] = Efield_func(index,width,lambda_sel,angle_sel,steps,nin,pol);
            figure;
            [Ax, H1, H2] = plotyy(pos, Efield, pos, nval);
            set(Ax(1),'XLim',[pos(1) pos(end)]);
            xlabel('Position(nm)', 'fontsize', 20);
            ylabel('Electric field(a. u.)', 'fontsize', 20);
            set(Ax(1), 'XTick', pos(1):500:pos(end));
            set(Ax(1), 'XTickLabel', pos(1):500:pos(end), 'Fontsize', 15);
            set(Ax(1), 'YTick', 0:10:40);
            set(Ax(1), 'YTickLabel', 0:10:40, 'Fontsize', 15);
            
            set(Ax(2),'XLim',[pos(1) pos(end)]);
            %set(Ax(2),'YLim',[1.4 1.8]);
            set(get(Ax(2), 'Ylabel'), 'String', 'Refractive index', 'fontsize', 20);
            set(Ax(2), 'XTick', pos(1):500:pos(end));
            set(Ax(2), 'XTickLabel', pos(1):500:pos(end), 'Fontsize', 15);
            %set(Ax(2), 'YTick', 1.4:.1:1.8);
            %set(Ax(2), 'YTickLabel', 1.4:.1:1.8, 'Fontsize', 15);
        end    
    
    
    
        function call_materials_selector(hObject,callbackdata)
            data = materialsSelector;
            materials = data(:,1)';
            set(t,'ColumnFormat',{materials,'numeric'});
            set(t_up,'ColumnFormat',{materials,'numeric'});
            idx_plot = 0;
        end
        
        function multilayer(hObject,callbackdata)
            text = get(txtbox_btn4,'String');   %get multiplier
            p = str2num(text)-1;           %number of periods-1 (because first period already exists)
            table_data = get(t,'Data');   %get data from thickness table
            dex = find([table_data{:,3}] == 1);  %find the indices of selected layers
            n_layers = length(dex);              %number of selected layers
            for cnt=1:ceil(p)      %counter from 1 to rounded down number of periods
                table_data(dex(end)+1:end+n_layers,:)=table_data(dex(1):end,:);   %copy the table shifted by number of selected cells
            end
            dif = ceil(p)*n_layers-round(p*n_layers);    %get number remainder layers
            loc_del = dex(1)+n_layers*(ceil(p)+1)-dif;       %location of first layer to be deleted
            table_data(loc_del:loc_del+dif-1,:)=[];      %delete remainder
            
            % now fix row_name and clear selection
            row_name=cell(1,length(table_data(:,1))); %set row names
            for ind=1:length(table_data(:,1))
                row_name{ind}=['layer' ' ' num2str(ind)];
                table_data{ind,3} = false;
            end
            
            set(t,'Data',table_data,'RowName',row_name);
            data_layers = get(t,'Data');
            idx_plot = 0;
        end
        
        %click delete rows button to delete rows from table "t"
        function delete_rows(hObject,callbackdata)
            layer = get(t,'Data');             %get table data
            idx = find([layer{:,3}] == 1);     %find the indices of selected layers
            layer(idx,:) = [];                 %delete selected layers by setting them to empty array
            row_name=cell(1,length(layer(:,1))); %set row names
            for ind=1:length(layer(:,1))
                row_name{ind}=['layer' ' ' num2str(ind)];
            end
            set(t,'RowName',row_name);  %set new row numbers
            set(t,'Data',layer);        %set new layer data in table
            data_layers = get(t,'Data');
            idx_plot = 0;
        end
    
        function make_DBR(hObject,callbackdata)
            %%% collect user data
            prompt = {'Center wavelength (nm):','Layer thickness = lam/(n*div), select div:',...
                      'Number of periods:'};
            dlg_title = 'DBR menu';
            num_lines = 1;
            defaultans = {'620','4','8'};
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
            lam_center=str2num(answer{1});
            div=str2num(answer{2});
            p = str2num(answer{3})-1;
            
            %%% make DBR
            table_data = get(t,'Data');   %get data from thickness table
            dex = find([table_data{:,3}] == 1);  %find the indices of selected layers
            names=table_data(dex,1);    %names of selected materials
            get_index = return_index(names,data,lam_center);  % get refractive index of selected materials
            for m=1:length(dex);
                table_data{dex(m),2}=lam_center/(get_index(m)*div);   % set thickness
            end
            n_layers = length(dex);              %number of selected layers
            for cnt=1:ceil(p)      %counter from 1 to rounded down number of periods
                table_data(dex(end)+1:end+n_layers,:)=table_data(dex(1):end,:);   %copy the table shifted by number of selected cells
            end
            dif = ceil(p)*n_layers-round(p*n_layers);    %get number remainder layers
            loc_del = dex(1)+n_layers*(ceil(p)+1)-dif;       %location of first layer to be deleted
            table_data(loc_del:loc_del+dif-1,:)=[];      %delete remainder
            
            % now fix row_name and clear selection
            row_name=cell(1,length(table_data(:,1))); %set row names
            for ind=1:length(table_data(:,1))
                row_name{ind}=['layer' ' ' num2str(ind)];
                table_data{ind,3} = false;
            end
            
              set(t,'Data',table_data,'RowName',row_name);
              data_layers = get(t,'Data');
              idx_plot = 0;
        end

        
        function make_cavity(hObject,callbackdata)
            %%% collect user data
            prompt = {'Center wavelength (nm):','Layer thickness = lam/(n*div), select div:'};
            dlg_title = 'Cavity menu';
            num_lines = 1;
            defaultans = {'620','2'};
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
            lam_center=str2num(answer{1});
            div=str2num(answer{2});                   
            %%% make cavity
            table_data = get(t,'Data');   %get data from thickness table
            dex = find([table_data{:,3}] == 1);  %find the indices of selected layers
            name=table_data(dex,1);    %names of selected materials
            get_ind = return_index(name,data,lam_center);  % get refractive index of selected materials
            table_data{dex,2}=lam_center/(get_ind*div);   % set thickness
            table_data{dex,3} = false;                    % clear selection
            set(t,'Data',table_data,'RowName',row_name);
            data_layers = get(t,'Data');
            idx_plot = 0;
        end
    
    
    
        function del_rows(hObject,callbackdata)
            text = get(delbox,'String');   %get row numbers as text
            idx = str2num(text);                 %convert to indicies
            data_layers = get(t,'Data');             %get table data
            old_row_name = get(t,'RowName');     %get table row name
            data_layers(idx,:) = [];           %delete desired rows
            row_name=cell(1,length(data_layers(:,1))); %set row names
            for dex=1:length(data_layers(:,1))
                row_name{dex}=['layer' ' ' num2str(dex)];
            end
            set(t,'RowName',row_name);  %set new row numbers
            set(t,'Data',data_layers);
            data_layers = get(t,'Data');
            idx_plot = 0;
        end
    
    
    %%% toolbar functions
        function savebutton(hObject,callbackdata)
            data_lam = get(t_lam,'Data');
            data_mediums = get(t_up,'Data');
            data_layers = get(t,'Data');
            data_angle = get(t_angle,'Data');
            id = get(popup1,'Value');
            materials_out = materials;
            layers_out = data_layers;
            medium_out = data_mediums;
            row_name_out = row_name;
            lam_out = data_lam;
            angle_out = data_angle;
            data=data;
                    
            
            [file,path] = uiputfile('*.mat','Save Panel As');
            if isequal(file,0) || isequal(path,0)
                disp('User selected Cancel')
            else
                disp(['Saved data to:',fullfile(path,file)])    
                save([path file],'layers_out','medium_out','lam_out','materials_out','row_name_out','angle_out','id','data');
            end
            
        end
    
    
        function loadbutton(hObject,callbackdata)            
            [FileName,PathName] = uigetfile('*.mat','Select the panel file');            
            if isequal(FileName,0) || isequal(PathName,0)
                disp('User selected Cancel')
            else
                disp(['Loading: ',fullfile(PathName,FileName)])
                S = load([PathName FileName]);
                set(t_lam,'Data',S.lam_out);
                set(t_up,'Data',S.medium_out);
                set(t,'Data',S.layers_out);
                set(t_angle,'Data',S.angle_out);
                set(popup1,'Value',S.id);
                set(t,'ColumnFormat',{S.materials_out,'numeric'});
                set(t_up,'ColumnFormat',{S.materials_out,'numeric'});
                data=S.data;
                id=S.id;
                disp('done')
            end     
        end
    
    
    
    
    
    set(f,'Visible','on');     %turn on visibility for figure
    uiwait(f);
    
    %%% get values of menus
    materials_out = materials;
    layers_out = data_layers;
    medium_out = data_mediums;
    row_name_out = row_name;
    lam_out = data_lam;
    angle_out = data_angle;
    idx_plot_out = idx_plot;
    n_in_out = n_in;    
    %lam_out = [data_lam{1}:data_lam{3}:data_lam{2}];       %sends wavelength as vector between lam_start and lam_end
    save('data_select.mat','data');    %save materials selected in materials selector - var name: data 
    save('data_RAT.mat','layers_out','medium_out','lam_out','materials_out','row_name_out','angle_out','id','idx_plot_out','R','T','A','n_in_out'); %save all the data in the figure
    
    
end