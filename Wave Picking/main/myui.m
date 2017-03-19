%Developed by Shubham Madheysia GPT IV year
function myui
    close all
    clear all
    clc

    [filename, pathname,FilterIndex] = uigetfile( ...
    {'*.xls;*.xsls',  'excel file(*.xsls,*.xls)'}, ...
       'Choose Datas');

    data=xlsread(strcat(pathname,filename));
    dataSize=size(data(:,1));
    dataSize=dataSize(1);
    maxAmplitude=max(data(:,3));
    minAmplitude=min(data(:,3));
    plot(data(:,1),data(:,3),'r');
    %datacursormode on
    axis([data(1,1),data(dataSize,1),minAmplitude,maxAmplitude])
    ylabel('Amplitude in V');
    xlabel('Time in sec');
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    hold on

    amplitude=0;
    time=0;
    nextAmplitude=0;
    pLine=0;
    sLine=0;
    ssLine=0;
    

    uicontrol('Style', 'popup',...
               'String', {'Select wave type','P wave','S wave','SS wave'},...
               'Position', [20 340 100 50],...
               'Callback', @setmap);

    function setmap(source,events)
        wavetype = get(source,'Value');
        if(wavetype==2)
            if(pLine)
                delete(pLine);
                delete(findall(gcf,'Tag','pWaveAnnotation'));
            end
            [time,amplitude]=ginput(1);
            pLine=line([time time], [minAmplitude maxAmplitude]); 
            nextHighest();
            str=strcat('P wave selected: ',num2str(amplitude),'mV ,',num2str(time),'sec');            
            strr=strcat('Next Highest Amplitude: ',num2str(nextAmplitude),'mV');
            annotation('textbox', [0.65,0.3,0.1,0.1],...
                'String', {str,strr},...
                'Tag' , 'pWaveAnnotation');
            elseif(wavetype==3)
            if(sLine)
                delete(sLine);
                delete(findall(gcf,'Tag','sWaveAnnotation'));
            end
            [time,amplitude]=ginput(1);
            sLine=line([time time], [minAmplitude maxAmplitude]); 
            nextHighest();
            str=strcat('S wave selected: ',num2str(amplitude),'mV ,',num2str(time),'sec');
            strr=strcat('Next Highest Amplitude: ',num2str(nextAmplitude),'mV');
            delete(findall(gcf,'Tag','sWaveAnnotation'));
            annotation('textbox', [0.65,0.2,0.1,0.1],...
                'String', {str,strr},...
                'Tag' , 'sWaveAnnotation');
        elseif(wavetype==4)
            if(ssLine)
                delete(ssLine);
                delete(findall(gcf,'Tag','ssWaveAnnotation'));
            end
            [time,amplitude]=ginput(1);
            ssLine=line([time time], [minAmplitude maxAmplitude]);
            nextHighest();
            str=strcat('SS wave selected: ',num2str(amplitude),'mV ,',num2str(time),'sec');
            strr=strcat('Next Highest Amplitude: ',num2str(nextAmplitude),'mV');
            delete(findall(gcf,'Tag','ssWaveAnnotation'));
            annotation('textbox', [0.65,0.1,0.1,0.1],...
               'String', {str,strr},...
                'Tag' , 'ssWaveAnnotation');
        end
        
        function nextHighest()
            for i=1:1:dataSize
                if(data(i,1)<time || data(i,3)<data((i+1),3))
                    continue
                else
                    nextAmplitude=data(i,3);
                    break
                end
            end
        end
    end
end