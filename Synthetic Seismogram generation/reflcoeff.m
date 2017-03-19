function a = reflcoeff(p1,p2,s1,s2,theta1,theta2,d1,d2)
    %p wave Velocity
    p=(p1+p2)/2;
    dp=p2-p1;
    
    %s wave veocity
    s=(s1+s2)/2;
    ds=s2-s1;
    
    %density
    d=(d1+d2)/2;
    dd=d2-d1;
    
    %Average angle
    theta=(theta1+theta2)/2;
    
    %reflection coefficient
    a=(0.5-2*((s/p)^2)*((sind(theta))^2))*(dd/d)+0.5*((secd(theta))^2)*(dp/p)-4*((s/p)^2)*((sind(theta))^2)*(ds/s);
    %Wang et.al. 1990 'Approximations to the Zoeppritz equations and their use in AVO analysis', Geophysics Journal
end