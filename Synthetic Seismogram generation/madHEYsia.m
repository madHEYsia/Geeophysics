function[a,t]= madHEYsia(noOfPoints,noOfLayers,sourceDepth,horizontalOffset,layer,layerParameters,amplitude,time)

    %Designing information Stack
    stack=zeros(1000,6+noOfPoints);
    stackindex=1000;
    stack(stackindex,7:6+noOfPoints)=amplitude;

    startY=sourceDepth;
    startX=0;

    rangeX = horizontalOffset-1;
    rangeY = layerParameters(layer(sourceDepth,1)-1,1);
    for i=1:1:rangeX
        stackindex=1000;
        stack(stackindex,1)=startY;
        stack(stackindex,2)=startX;
        stack(stackindex,3)=rangeY;
        stack(stackindex,4)=i;
        distance=sqrt((startingX-endingX)^2+(startingY-endingY)^2);
        stack(stackindex,5)=distance/layerParameters(layer(startY,startX),2);
        stack(stackindex,6)=atlayerand((i-startX)/(rangeY-startY));
        stack(stackindex,7:6+noOfPoints)=amplitude;
        tree(startX,startY,i,rangeY);
    end

    rangeX = floor((horizontalOffset+1-startX)*0.5);
    rangeY = layerParameters(layer(sourceDepth,startingX),1);
    for i=1:1:rangeX
        stackindex=1000;
        stack(stackindex,1)=startY;
        stack(stackindex,2)=startX;
        stack(stackindex,3)=rangeY;
        stack(stackindex,4)=i;
        distance=sqrt((startingX-endingX)^2+(startingY-endingY)^2);
        stack(stackindex,5)=distance/layerParameters(layer(startY,startX),2);
        stack(stackindex,6)=atand((i-startX)/(rangeY-startY));
        stack(stackindex,7:6+noOfPoints)=amplitude;
        tree(startX,startY,i,rangeY);
    end

    function tree(startingX, startingY,endingX,endingY)
        if(endingY==0 && endingX==horizontalOffset)
           superposition(stack(stackindex,8:7+noOfPoints)); 
        else    
            if(endingY<startingY)
                currentlayer=layer(startingY,startingX);
                p1=layerParameters(currentlayer,2);
                s1=layerParameters(currentlayer,3);
                theta1=stack(stackindex,6);
                d1=layerParameters(currentlayer,4);
                if(endingY>0 && endingX<horizontalOffset)
                    stackindex=stackindex-2;
                    stack(stackindex,1)=endingY;
                    stack(stackindex,2)=endingX;

                    if(currentlayer==1)
                        newY=0;
                    else    
                        %newY=endingY-(layerParameters(currentlayer-1,1)-layerParameters(currentlayer-2,1));
                    end
                    newX=round((endingY-newY)*tand(stack(stackindex+2,6)));
                    stack(stackindex,3)=newY;
                    stack(stackindex,4)=newX;

                    distance=sqrt((endingX-newX)^2+(endingY-newY)^2);
                    stack(stackindex,5)=stack(stackindex+2,5)+distance/layerParameters(layer(newY,newX),2);

                    stack(stackindex,6)=atand((newX-startingX)/(newY-startingY));

                    p2=layerParameters(currentlayer-1,2);
                    theta2=asind(p2*sind(theta1)/p1);    %snells law
                    RC=transcoeff(p1,p2,theta1,theta2); %function defined outside
                    stack(stackindex-2,7:6+noOfPoints)=conv(RC,stack(stackindex,7:6+noOfPoints));

                    tree(endingX,endingY,newX,newY);  
                end    
                if(endingY<layerParameters(size(layerParameters,1)-1,1) && endingX<horizontalOffset)
                    stackindex=stackindex+1;
                    stack(stackindex,1)=endingY;
                    stack(stackindex,2)=endingX;

                    if(currentlayer==1)
                        newY=0;
                    else    
                        %newY=endingY-(layerParameters(currentlayer-1,1)-layerParameters(currentlayer-2,1));
                    end
                    newX=round(newY*tand(stack(stackindex+2,6)));
                    stack(stackindex,3)=newY;
                    stack(stackindex,4)=newX;

                    distance=sqrt((endingX-newX)^2+(endingY-newY)^2);
                    stack(stackindex,5)=stack(stackindex+2,5)+distance/layerParameters(layer(newY,newX),2);

                    stack(stackindex,6)=atand((newX-startingX)/(newY-startingY));
                    p2=layerParameters(currentlayer-1,2);
                    s2=layerParameters(currentlayer-1,3);
                    theta2=asind(p2*sind(theta1)/p1);    %snells law
                    d2=layerParameters(currentlayer-1,4);
                    RC=reflcoeff(p1,p2,s1,s2,theta1,theta2,d1,d2); %function defined outside
                    stack(stackindex+1,7:6+noOfPoints)=conv(RC,stack(stackindex,7:6+noOfPoints));
                end 
            end    
        end 
    end
end