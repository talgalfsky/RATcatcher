function [choice] = plotOrFile

    d = dialog('Position',[800 500 350 120],'Name','Select');
    txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 65 250 40],...
           'String','Load material file, plot existing, or delete existing');
       
    btn1 = uicontrol('Parent',d,...
           'Position',[130 40 100 30],...
           'String','plot',...
           'Callback',@plot_callback);
       
    btn2 = uicontrol('Parent',d,...
           'Position',[25 40 100 30],...
           'String','file',...
           'Callback',@file_callback);
       
    btn3 = uicontrol('Parent',d,...
           'Position',[235 40 100 30],...
           'String','delete',...
           'Callback',@delete_callback);
       
%     btn3 = uicontrol('Parent',d,...
%            'Position',[89 20 70 25],...
%            'String','Close',...
%            'Callback','delete(gcf)');
       
    choice = 0;  %1 = plot file, 2 = open new file , 3 = delete file
    
       
    % Wait for d to close before running to completion
    uiwait(d);
   
       function plot_callback(btn,callbackdata)
          choice = 1;
          delete(gcf)
       end
   
       function file_callback(btn,callbackdata)
          choice = 2;
          delete(gcf)
       end
   
       function delete_callback(btn,callbackdata)
          choice = 3;
          delete(gcf)
       end
  
   
   
end