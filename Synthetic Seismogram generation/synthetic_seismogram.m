clear
close 
clc

%Input Parameters : F(Hz), No. p, sT(sec), No. L, sD(m), hO(m)
prompt = {'Ricker Wavelet Frequency (in Hz)','Number of points','sampling time (in sec)','Number of Layers','Source Depth (in meter)','Horizontal Offset (in meter)','1: Displacement type, 2: Velocity type, 3: Acceleration type'};
dlg_title = 'Synthetic Seismogram Parameter';
input = {'20','100','0.001','3','3','7','1'};
check=1;
while(check)
    input = inputdlg(prompt,dlg_title,[1 69],input);
    if(isnan(str2double(input{1})))
         prompt{1,1}='Enter Valid frequency(Hz) value';
    elseif (isnan(str2double(input{2})))
         prompt{1,2}='Enter Valid No. of points';
    elseif (isnan(str2double(input{3})))
         prompt{1,3}='Enter Valid Sampling time (in sec)';
    elseif (isnan(str2double(input{4})))
         prompt{1,4}='Enter Valid no. of Layers';
    elseif (isnan(str2double(input{5})))
         prompt{1,5}='Enter Valid Source Depth(m)';
    elseif (isnan(str2double(input{6})))
         prompt{1,6}='Enter Valid Horizontal Offset(m)';
    elseif (isnan(str2double(input{7})) || ~isreal(str2double(input{7})) || ~rem(str2double(input{7}),1)==0 || str2double(input{7})<1 || str2double(input{7})>3)
         prompt{1,7}='Enter Valid Wavetype "1: Displacement, 2: Velocity, 3: Acceleration"';
    else
        check=0;
        frequency=str2double(input{1});
        noOfPoints=str2double(input{2});
        samplingTime=str2double(input{3});
        noOfLayers=str2double(input{4});
        sourceDepth=str2double(input{5});
        horizontalOffset=str2double(input{6});
        waveType=str2double(input{7});
    end    
end

%Generating & storing Ricker Wavelet amplitudes and cooresponfing time value
[amplitude,time]=ricker(frequency,noOfPoints,samplingTime,waveType);

%Layer parameters :t(m), pV(m/s), sV(m/s),d(g/cc),cA
prompt = {'thickness(in m)','P wave velocity(in m/sec)','S wave velocity(in m/sec)(optional)','density(in g/cc)'};
input = {'0','0','0','0'};
layerParameters=zeros(noOfLayers,5);
nthlayer=1;

while(nthlayer<=noOfLayers)
    input = inputdlg(prompt,strcat(num2str(nthlayer),' layer parameters'),[1 50],input);
    if(nthlayer~=noOfLayers && isnan(str2double(input{1})))
         prompt{1,1}='Enter Valid thickness(m) value';
    elseif (isnan(str2double(input{2})))
         prompt{1,2}='Enter Valid P wave velocity(in m/sec)';
    elseif (isnan(str2double(input{3})))
         prompt{1,3}='Enter Valid S wave velocity(in m/sec)(optional)';
    elseif (isnan(str2double(input{4})))
         prompt{1,4}='Enter Valid density(in g/cc)';
    else
        if(nthlayer==1)
            layerParameters(nthlayer,1)=str2double(input(1));
        elseif(nthlayer~=noOfLayers)
            layerParameters(nthlayer,1)=layerParameters(nthlayer-1,1)+str2double(input(1));
        end
        layerParameters(nthlayer,2)=str2double(input(2));
        if(str2double(input(3))~=0)
            layerParameters(nthlayer,3)=str2double(input(3));
        else 
            layerParameters(nthlayer,3)=(1/1.7)*layerParameters(nthlayer,2);
        end    
        layerParameters(nthlayer,4)=str2double(input(4));
        if(nthlayer~=1)
            layerParameters(nthlayer,5)=asind(layerParameters(nthlayer-1,2)/layerParameters(nthlayer,2));
        end
        nthlayer=nthlayer+1;
    end 
end


%Declaring layer matrix
layer=zeros(layerParameters(noOfLayers-1,1),horizontalOffset);
layerindex=1;

for i=1:1:layerParameters(noOfLayers-1,1)
    layer(i,:)=layerindex;
    if(i==layerParameters(layerindex,1))
        layerindex=layerindex+1;
    end    
end

[a,t] = madHEYsia(noOfPoints,noOfLayers,sourceDepth,horizontalOffset,layer,layerParameters,amplitude,time);

str=strcat('Synthetic Seismogram considering ',{' '},num2str(f),'Hz ricker wavelet');
plot(t,a);
title(str);
xlabel('Time in seconds');
ylabel('Amplitude ');