function [rw,t] = ricker(f,n,dt,waveType)
    
    T = dt*(n-1);
    t = -0.5*T:dt:0.5*T;
    u=2*pi*f*t;   %Angular Velocity 'u'
    t=t+0.5*T;      %shifting negative part time
    
    %Ricker Wavelet formulas source: "Transient Waves in Ricker Media -N.H. Ricker"
    
    str=strcat('Ricker Wavelet of',{' '},num2str(f),'Hz - Displacement type');
    displacement = (sqrt(pi)/2)*(u/2).*exp(-(u.^2)/4);
    subplot(1,3,1);
    plot(t,displacement);
    title(str);
    xlabel('time in seconds');
    ylabel('Amplitude ');

    str=strcat('Ricker Wavelet of',{' '},num2str(f),'Hz - Velocity type');
    velocity = (sqrt(pi)/2)*((u.^2)/4 -(1/2)).*exp(-(u.^2)/4);
    subplot(1,3,2);
    plot(t,velocity);
    title(str);
    xlabel('time in seconds');
    ylabel('Amplitude ');
    
    str=strcat('Ricker Wavelet of',{' '},num2str(f),'Hz - Acceleration type');
    acceleration = (sqrt(pi)/2)*(1/8)*(u.*(6-u.^2)).*exp(-(u.^2)/4);
    subplot(1,3,3);
    plot(t,acceleration);
    title(str);
    xlabel('time in seconds');
    ylabel('Amplitude ');
    
    if (waveType==1)
        rw = displacement;
    elseif (waveType==2)
        rw = velocity;
    else
        rw = acceleration;
    end    
end