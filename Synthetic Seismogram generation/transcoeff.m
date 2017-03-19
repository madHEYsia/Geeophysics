function a= transcoeff(p1,p2,theta1,theta2,density1,density2)
    %p wave Velocity
    p=(p1+p2)/2;
    dp=p2-p1;
    
    %Average angle
    theta=(theta1+theta2)/2;
    
    %density 
    dd=density2-density1;
    d=(density1+density2)/2;
    
    %transmission coefficient    
    a=1-0.5*(dd/d)+0.5*((tand(theta))^2)*(dp/p);
%    a=1-((5/8)-(1/2)*tan(theta))*dp/p;
    
    %Wang et.al. 1990 'Approximations to the Zoeppritz equations and their use in AVO analysis', Geophysics Journal
end