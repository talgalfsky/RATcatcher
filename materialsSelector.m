function data_out = materialsSelector
    f = figure('Position',[500 500 700 300],'Name','Materials Database');
    %f = figure;
    
    
    data_init = {'Ag' true 'dispersive' 0 'Ag_Palik.txt';...
             'Air' true 'non-dispersive' 0 ' ';...
             'SiO2' true 'non-dispersive' 0 ' ';};
    load('data_m_select.mat');        %load last configuration
    myData=data;
    num_materials=length(data(:,1));   %find number of materials in file
    
    columnformat = {'char','logical',{'non-dispersive' 'dispersive'},'numeric','char'};
    
    row_name=cell(1,num_materials); %set row names
    for cur=1:num_materials
        row_name{cur}=['material' ' ' num2str(cur)];
    end
    
    
    t = uitable('Parent',f,...
                'Position', [25 60 632 200], ...
                'Data',myData,...
                'ColumnName',{'name', 'select', 'type', 'index', 'file'},...
                'RowName',row_name,...
                'ColumnFormat', columnformat,...
                'ColumnWidth', {80 60 100 60 220},...
                'ColumnEditable', [true true true true false], ...
                'CellSelectionCallback',@selectfile, ...
                'CellEditCallback',@table_out);  %'CellEditCallback',@table_out,
    
    %getpos=get(t,'position');
    %getext=get(t,'Extent');
    %set(t,'Position',[getpos(1:2), getext(3:4)])
    set(gcf, 'MenuBar', 'None');
    
    btn1 = uicontrol('Parent',f,...
           'Position',[30 270 100 25],...
           'String','Add Material',...
           'Callback',@addmaterial);
   
    btn3 = uicontrol('Parent',f,...
           'Position',[30 10 100 25],...
           'String','Delete material(s)',...
           'Callback',@delmaterial);
    
    btn4 = uicontrol('Parent',f,...
           'Position',[600 10 70 25],...
           'String','Close',...
           'Callback',@closebutton);
    
    txtbox = uicontrol(f,'Style','edit',...
                'String',' ',...
                'Position',[135 12 60 21]);    
   
              
   %%% Functions     
        function selectfile (hObject,eventdata)
             y=eventdata.Indices;
             if numel(y)==0;
             else    
                if y(2) == 5     %if user select 5th column open user selection dialog plotOrFile
                    x=plotOrFile;
                    %based on user decision plot or file, 1 = plot, 2 =
                    %open new file, 3 = delete
                    switch x
                       case 1   %plot file
                       f_sub=figure;
                       material_dispersion = importdata(data{y(1),y(2)});
                       plot(material_dispersion(:,1),[material_dispersion(:,2),material_dispersion(:,3)]);
                       set(gca,'fontsize',12);
                       title(['Optical Constants of',' ',data{y(1),1}],'Fontsize',14);
                       legend('n','k');
                       xlabel('Wavelength(nm)','Fontsize',14);
                                          
                        case 2  %load file name
                        material_name=data{y(1),1};
                        h = msgbox({['Select index file for',' ', material_name ,':'],...
                            ' ','accepted file format - "lam(nm) n k" no header'});
                        uiwait(h);
                        filename = uigetfile('*.*');
                        data{y(1),5}=filename;        %set the cell to new file name
                        set(t,'Data',data);
                        
                        case 3  %delete file name
                        data{y(1),5}=' ';
                        set(t,'Data',data);
                    end
                                       
                end
             end
        end
    
        function table_out(hObject,eventdata)
             data = get(hObject,'Data');      
        end
        
        %add material function
        add={' ' false 'non-dispersive' 0 ' '};
        function addmaterial(hObject,callbackdata)
             oldData = get(t,'Data');   %get data from table
             newData = [oldData; add];
             set(t,'Data',newData);
             old_row_name = get(t,'RowName');
             for ind=1:length(newData(:,1))
                row_name{ind}=['material' ' ' num2str(ind)];
             end
             set(t,'RowName',row_name);
             
              
        end
    
    
        function delmaterial(hObject,callbackdata)
            text = get(txtbox,'String');   %get row numbers as text
            idx = str2num(text);                 %convert to indicies
            data = get(t,'Data');             %get table data
            old_row_name = get(t,'RowName');     %get table row name
            data(idx,:) = [];           %delete desired rows
            row_name=cell(1,length(data(:,1))); %set row names
            for dex=1:length(data(:,1))
                row_name{dex}=['material' ' ' num2str(dex)];
            end
            set(t,'RowName',row_name);  %set new row numbers
            set(t,'Data',data);
            data = get(t,'Data'); 
        end
            
        
        function closebutton(hObject,callbackdata) 
            data = get(t,'Data'); 
            delete(gcf);
        end
    
    uiwait(f);
   
   
    %only retreive selected materials
    data_store=data;
    ind = find([data{:,2}] == 1);      %find what materials are selected
    data_out=data(ind,:);
    save('data_m_select.mat','data')
    
        
    
end