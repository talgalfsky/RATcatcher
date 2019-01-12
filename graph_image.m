function n = graph_image(lambda,angles,R,T,A,n_in)
    
%%%% Call function - multi_layer_in.m to calculate Reflection-Absorbance-Transmission

      
      %set(fig,'Colormap',mycmap);


f = figure('Visible','off','Position',[360,500,800,500],'Color','white');
set(f,'toolbar','figure')  %make toolbar available

% Construct the components.

hpanel = uipanel('Title','2D graphs','FontSize',11,...
             'BackgroundColor','white',...   
             'Position',[.74 .69 .2 .25]);    
    
hRAT = uicontrol('parent',hpanel,'Style','popupmenu',...
           'String',{'Reflectance','Transmission','Absorption'},...
           'Position',[10,75,100,25],...
           'Callback',@RAT2D_Callback);

htext  = uicontrol('parent',hpanel,'Style','text','String','Color Map',...
            'HorizontalAlignment', 'left',...
            'BackgroundColor','white',...
            'Fontsize',10,'Position',[10,45,60,20]);

cmaps = {'Jet' 'HSV' 'Hot' 'Cool' 'Spring' 'Summer' 'Autumn' 'Winter' 'Gray' 'Copper' 'TAL'};
hCmap = uicontrol('parent',hpanel,'Style','popupmenu',...
           'String',cmaps,...
           'Position',[10,20,100,25],...
           'Callback',@Cmaps_Callback);

       
%%% 1D graph area

hpanel2 = uipanel('Title','1D graphs','FontSize',11,...
             'BackgroundColor','white',...   
             'Position',[.74 .25 .24 .41]);   

hRAT1D = uicontrol('parent',hpanel2,'Style','popupmenu',...
           'String',{'Reflectance','Transmission','Absorption'},...
           'Position',[10,155,100,25],...
           'Callback',@RAT1D_Callback);

htext2  = uicontrol('parent',hpanel2,'Style','text','String','Select wavelengh(s):',...
            'HorizontalAlignment', 'left',...
            'BackgroundColor','white',...
            'Fontsize',10,'Position',[10,120,120,20]);

%wavelength selection box        
txtbox_fill_lam = uicontrol('parent',hpanel2,'Style','edit',...
                'String',' ',...
                'Position',[10 95 100 21]); 
            
btn_lam = uicontrol('parent',hpanel2,...
           'Position',[115 93 25 25],...
           'String','Go',...
           'Callback',@plot_wavelength);
                   
        
htext1  = uicontrol('parent',hpanel2,'Style','text','String','Select angle(s):',...
            'HorizontalAlignment', 'left',...
            'BackgroundColor','white',...
            'Fontsize',10,'Position',[10,65,120,20]);

%angle selection box        
txtbox_fill_ang = uicontrol('parent',hpanel2,'Style','edit',...
                'String',' ',...
                'Position',[10 40 100 21]);         
        
btn_ang = uicontrol('parent',hpanel2,...
           'Position',[115 38 25 25],...
           'String','Go',...
           'Callback',@plot_angle);        

       
       
%%% selection for y and x axis       
htext_y  = uicontrol('parent',f,'Style','text','String','Y-Axis:',...
            'HorizontalAlignment', 'left',...
            'BackgroundColor','white',...
            'Fontsize',10,'Position',[620,83,100,25]);
        
pop_y_ax = uicontrol('parent',f,'Style','popupmenu',...
           'String',{'Wavelength','Frequency','Energy'},...
           'Position',[683,85,100,25],...
           'Callback',@select_y);

htext_x  = uicontrol('parent',f,'Style','text','String','X-Axis:',...
            'HorizontalAlignment', 'left',...
            'BackgroundColor','white',...
            'Fontsize',10,'Position',[620,48,100,25]);
       
pop_x_ax = uicontrol('parent',f,'Style','popupmenu',...
           'String',{'Angle','n_eff'},...
           'Position',[683,50,100,25],...
           'Callback',@select_x);

       
       
       
load('MyColormaps','mycmap');       
       
ha = axes('Units','pixels','Position',[70,60,510,400],'Fontsize',12,'Color','none');     %this is the graph area



%align([hsurf,hmesh,hcontour,hpopup],'Center','None');

% Initialize the UI.
% Change units to normalized so components resize automatically.
set(f,'Units','normalized');
set(ha,'Units','normalized');
set(hRAT1D,'Units','normalized');
set(hpanel2,'Units','normalized');
set(htext2,'Units','normalized');
set(htext,'Units','normalized');
set(hRAT,'Units','normalized');
set(hCmap,'Units','normalized');
set(hpanel,'Units','normalized');
set(btn_lam,'Units','normalized');
set(pop_x_ax,'Units','normalized');
set(pop_y_ax,'Units','normalized');
set(htext_y,'Units','normalized');
set(htext_x,'Units','normalized');
set(txtbox_fill_lam,'Units','normalized');



% Assign the a name to appear in the window title.
set(f,'Name','RAT graphing interface');

% Move the window to the center of the screen.
movegui(f,'center')

% Make the window visible.
set(f,'Visible','on');


%%%%%%%%%%%%%%%%%%%%%%%% intialize for functions %%%%%%%%%%%%%%%%%%%%%%%%%%
val_1d=1;
freq = 2.998e+17./lambda;
energy = 1239.84193./lambda;
n_eff = sin(angles*pi/180)*n_in;
y_vector = lambda;
x_vector = angles;
name_y = 'Wavelength(nm)';
name_x = 'Angle (deg)';
indicator_y = 1;     %y axis indicator 1 = wavelength, 2 = frequency, 3 = energy
indicator_x = 1;     %x axis indicator 1 = angles, 2 = n_eff
fig_data = R';
dim = 2;    %dimension indicator, 2 = 2D, 11 = 1D x-axis angles, 12 = 1D x-axis wavelength 
fig_title = 'Reflectance';   %figure title

% Create a plot in the axes.
pcolor(x_vector,y_vector,fig_data);
shading interp;
set(gca,'YDir','reverse');
ylabel(name_y,'Fontsize',14);
xlabel(name_x,'Fontsize',14);
title(fig_title,'Fontsize',15);
colorbar;


%%% functions 
    function select_y(source,eventdata) 
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      switch str{val};
      case 'Wavelength' % User selects wavelength
          name_y = 'Wavelength(nm)';
          indicator_y = 1;
          y_vector = lambda;
      case 'Frequency' % User selects frequency
          name_y = 'Frequency(Hz)';
          indicator_y = 2;
          y_vector = freq;
      case 'Energy' % User selects frequency
          name_y = 'Energy(eV)';
          indicator_y = 3;
          y_vector = energy;      
      end
      switch dim %dimension indicator, 2 = 2D, 11 = 1D x-axis angles, 12 = 1D x-axis wavelength
          case 2
              pcolor(x_vector,y_vector,fig_data);
              title(fig_title,'Fontsize',15);
              shading interp;
              ylabel(name_y,'Fontsize',14);
              xlabel(name_x,'Fontsize',14);
              colorbar;
              switch indicator_y
                  case 1
                      set(gca,'YDir','reverse')
                  case 2 || 3
                      set(gca,'YDir','normal')
              end
          case 11
              plot(x_vector,fig_data)
              title(fig_title,'Fontsize',15);
              xlabel(name_x,'Fontsize',14);
          case 12
              plot(y_vector,fig_data)
              title(fig_title,'Fontsize',15);
              xlabel(name_y,'Fontsize',14);
      end
    end
    
    function select_x(source,eventdata) 
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      switch str{val};
      case 'Angle' % User selects wavelength
          name_x = 'Angle(deg)';
          indicator_x = 1;
          x_vector = angles;
      case 'n_eff' % User selects frequency
          name_x = 'Effective index k_x/k_0';
          indicator_x = 2;
          x_vector = n_eff;        
      end
      switch dim %dimension indicator, 2 = 2D, 11 = 1D x-axis angles, 12 = 1D x-axis wavelength
          case 2
              pcolor(x_vector,y_vector,fig_data);
              title(fig_title,'Fontsize',15);
              shading interp;
              ylabel(name_y,'Fontsize',14);
              xlabel(name_x,'Fontsize',14);
              colorbar;
              switch indicator_y
                  case 1
                      set(gca,'YDir','reverse')
                  case 2 || 3
                      set(gca,'YDir','normal')
              end
          case 11
              plot(x_vector,fig_data)
              title(fig_title,'Fontsize',15);
              xlabel(name_x,'Fontsize',14);              
          case 12
              plot(y_vector,fig_data)
              title(fig_title,'Fontsize',15);
              xlabel(name_y,'Fontsize',14);              
      end
    end
    
    
    function RAT2D_Callback(source,eventdata) 
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      dim=2;         %set the dimension to 2D
      fig_title = str{val};
      % Set current data to the selected data set.
      switch str{val};
      case 'Reflectance' % User selects Reflectance.
         fig_data = R';          
      case 'Transmission' % User selects Transmission.
         fig_data = T';          
      case 'Absorption' % User selects Absorption.
         fig_data = A';        
      end
      %plot the 2D graph
      pcolor(x_vector,y_vector,fig_data);
      title(fig_title,'Fontsize',15);
      shading interp;
      ylabel(name_y,'Fontsize',14);
      xlabel(name_x,'Fontsize',14);
      colorbar;
      switch indicator_y
          case 1
              set(gca,'YDir','reverse')
          case 2 || 3
              set(gca,'YDir','normal')
      end  
      
    end


    function RAT1D_Callback(source,eventdata)     
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      % Set current data to the selected data set.
      switch str{val};
      case 'Reflectance' % User selects Peaks.
         val_1d=1;
      case 'Transmission' % User selects Membrane.
         val_1d=2;
      case 'Absorption' % User selects Sinc.
         val_1d=3;         
      end
   end



   function Cmaps_Callback(source,eventdata) 
      % choose color map for contous graphs
      str = get(source, 'String');
      val = get(source,'Value');
      choice = char(str(val));
      if strcmp(choice,'TAL')==1 
          set(f,'Colormap',mycmap);
      else
          colormap(str{val});
      end
   end

  
  function plot_wavelength(source,eventdata) 
  % Display plot of selected element vs. angles
      dim = 11; %set dimension to 1D plot
      text = get(txtbox_fill_lam,'String');   %get multiplier
      lam_select = str2num(text);
      lam_int=[];     %index of selected lamdas
      for ind=1:length(lam_select);
      [c lam_index] = min(abs(lambda-lam_select(ind)));      %finds nearest lambdas
      lam_int=[lam_int lam_index];
      end
      
      %get legend rready for graphs
      legendmatrix=cell(length(lam_int),1);
        for k=1:length(lam_int)
        legendmatrix{k}=strcat(num2str(lambda(lam_int(k))),'nm');        
        end
      
      if find(lam_select==666)
          myicon = imread('av.m');
          h=msgbox('Unleashed Hell Mode','Success','custom',myicon);
          uiwait(h);
          pos=get(f,'Position');
          ba = axes('Units','pixels','Position',[0,0,700,700]);     
          uistack(ba,'bottom');
          I=imread('mrd.m');
          hi = imagesc(I);          
          set(ba,'handlevisibility','off', ...
              'visible','off')
          % Now we can use the figure, as required.
      end  
        
      switch val_1d;
      case 1 % User selects R
         fig_data = R(:,lam_int); 
         fig_title = 'Reflectance';                
      case 2 % User T
         fig_data = T(:,lam_int); 
         fig_title = 'Transmission';  
      case 3 % User selects A
         fig_data = A(:,lam_int); 
         fig_title = 'Absorption';          
      end
      
      plot(x_vector,fig_data)
      title(fig_title,'Fontsize',15);
      xlabel(name_x,'Fontsize',14);
      legend(legendmatrix);
  end

  function plot_angle(source,eventdata) 
  % Display plot of selected element vs. angles
      dim = 12; %set dimension to 1D plot
      text = get(txtbox_fill_ang,'String');   %get multiplier
      ang_select = str2num(text);
      ang_int=[];     %index of selected lamdas
      for ind=1:length(ang_select);
      [c ang_index] = min(abs(angles-ang_select(ind)));      %finds nearest lambdas
      ang_int=[ang_int ang_index];
      end
      
      %get legend rready for graphs
      legendmatrix=cell(length(ang_int),1);
        for k=1:length(ang_int)
        legendmatrix{k}=strcat(num2str(angles(ang_int(k))),'deg');        
        end
      
      switch val_1d;
      case 1 % User selects R
         fig_data = R(ang_int,:); 
         fig_title = 'Reflectance';          
      case 2 % User T
         fig_data = T(ang_int,:); 
         fig_title = 'Transmission';           
      case 3 % User selects Sinc.
         fig_data = A(ang_int,:); 
         fig_title = 'Absorption';        
      end 
      plot(y_vector,fig_data)
      title(fig_title,'Fontsize',15);
      xlabel(name_y,'Fontsize',14);
      legend(legendmatrix);
  end   %end of function plot_angle




end