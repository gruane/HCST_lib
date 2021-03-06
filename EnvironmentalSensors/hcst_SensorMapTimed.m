% C:\Users\ET\Documents\Grady_Sensors\hcst_SensorMapTimed.m
%
% saves a GIF and an Excel file of envi data over a period of time
% 
% 
% written by Grady Morrissey July 2019



function hcst_SensorMapTimed(interval,duration)

%categories of data to save
categories = ["Temperature" "Humidity" "Pressure" "Accel Y"];
%based on hcst_getEnviData() output
catindex = [1,2,3,5];

%in seconds
sensint = interval;
dur = duration;
currtime = 0;
starttime = TimeDisplay();

%for recording duration
while currtime < dur
    tic
    %get data from /now
    time = TimeDisplay();
    dat = hcst_getEnviData();
    %create cell array for adding data from current time
    datcell = table2cell(dat);
    %fill a column with the time
    timecell = cell(8,1);
    for SS = 1:8
        timecell{SS,1} = time;
    end
    %combine time and data
    datcell = horzcat(timecell,datcell);
    
    
    %empty array for sensor map
    datamap = zeros(2,4);
    
    %for each category of data
    for DD = 1:length(catindex)
        %for each sensor put data in sensor map
        for JJ = 1:8
            if JJ <= 4
                datamap(1,JJ) = dat{JJ,catindex(DD)};
            elseif JJ > 4
                datamap(2,JJ-4) = dat{JJ,catindex(DD)};
            end
        end
        
        %set up figure for GIF
        time = datetime('now');
        fig = figure('visible','off','color','w');
        imagesc(datamap);
        title(categories(DD) + " Map at " + string(time)+ " - Duration: " + dur + "s")
        colorbar
        set(gca,'xtick',[],'ytick',[])
        set(gca,'xticklabel',[],'yticklabel',[])
        
        %sets colorbar limits for each category
        if DD == 1
            caxis([20 25])
            colormap winter;
        elseif DD == 2
            caxis([10 16])
            colormap(hot(1024));
        elseif DD == 3
            caxis([980 990])
        elseif DD == 4
            caxis([-.5 3])
        end
        
        %sets up for saving
        frame = getframe(fig);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        close
        
        %save image to GIF
        filename = "C:\Users\ET\Documents\Grady_Sensors\SensorMapPlots\" + string(starttime) + "_" + string(categories(DD)) + ".gif";
        filename = convertStringsToChars(filename);
        if currtime == 0
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.01); 
            datfile = datcell;
        else
            imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.01); 
            datfile = vertcat(datfile, datcell);
        end
    end
  

    

    %handle duration,recording interval
    elap = toc;
    if sensint - elap > 0
        pause(sensint-elap)
    end
    
    currtime = currtime + sensint;
end


%matfilepath is for saving the table
matfilename = "EnviData"+"_" + starttime + ".xlsm";
matfilepath = "C:\Users\ET\Documents\Grady_Sensors\SensorMapPlots\matFiles_all\" + matfilename;


%customize table
datfile = cell2table(datfile);
catstr = "time,temp,humidity,pressure,accelX,accelY,accelZ,gyroX,gyroY,gyroZ,magX,magY,magZ";
keys = strsplit(catstr,',');
headers = cell(1,length(keys));
for FF = 1:length(keys)
    headers{FF} = char(keys{FF});
end
datfile.Properties.VariableNames = {headers{:,:}};

%save table
%save(matfilepath,'datfile')
writetable(datfile, matfilepath)
end