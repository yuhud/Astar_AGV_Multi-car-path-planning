function [index,Path1,Path2,Path3]=find_car_and_path(AStart,xTarget,yTarget,AUsedCarIndex,crash_points,A,B,C,D,E,F)


MAX_X=64;
MAX_Y=63;
Path1=[];
Path2=[];

index=1;
num=size(AStart,1);
c=0;
UsedCarNum=size(AUsedCarIndex,1);
NotUsedCarIndex=[];
knx=1;

for inx=1:1:num
    flag=0;
    for jnx=1:1:UsedCarNum 
        if AStart(inx,1)==AStart(AUsedCarIndex(jnx,1),1)
            flag=1;
        end
    end
    if flag==0
        NotUsedCarIndex(knx,1)=AStart(inx,1);
        knx=knx+1;
    end
end
NotUsedCarNum=size(NotUsedCarIndex,1);
for inx=1:1:NotUsedCarNum
    
    if(inx==1)
        c=cost(AStart(NotUsedCarIndex(inx,1),2),AStart(NotUsedCarIndex(inx,1),3),xTarget,yTarget);
        index=NotUsedCarIndex(inx,1);
    else
        if(c>cost(AStart(NotUsedCarIndex(inx,1),2),AStart(NotUsedCarIndex(inx,1),3),xTarget,yTarget))
            c=cost(AStart(NotUsedCarIndex(inx,1),2),AStart(NotUsedCarIndex(inx,1),3),xTarget,yTarget);
            index=NotUsedCarIndex(inx,1);
        end
    end
end


MAP=2*(ones(MAX_X,MAX_Y));


size_crash_points=size(crash_points,1);
if size_crash_points>0
    print('由冲撞点，正在修改路径（冲撞点坐标如下）：');
    crash_points
end

for inx=1:1:size_crash_points
    MAP(crash_points(inx,1),crash_points(inx,2))=-1;
end



for i=7:17
    MAP(i,4)=-1;
    MAP(i,31)=-1;
    MAP(i,34)=-1;
    MAP(i,61)=-1;
    MAP(i+20,4)=-1;
    MAP(i+20,31)=-1;
    MAP(i+20,34)=-1;
    MAP(i+20,61)=-1;
    MAP(i+40,4)=-1;
    MAP(i+40,31)=-1;
    MAP(i+40,34)=-1;
    MAP(i+40,61)=-1;
end
 
 
for j=4:31
    MAP(7,j)=-1;
    MAP(7,j+30)=-1;
    MAP(17,j)=-1;
    MAP(17,j+30)=-1;
    MAP(27,j)=-1;
    MAP(27,j+30)=-1;
    MAP(37,j)=-1;
    MAP(37,j+30)=-1;
    MAP(47,j)=-1;
    MAP(47,j+30)=-1;
    MAP(57,j)=-1;
    MAP(57,j+30)=-1;
end
 
xStart=AStart(index,2);%Starting Position
yStart=AStart(index,3);%Starting Position
MAP(xStart,yStart)=0;
MAP(xTarget,yTarget)=1;
if(yStart>61||yStart<4||xStart<7||xStart>57)
    if(yStart>=34)
        for i=37:47
            MAP(i,61)=-1;
        end
    else
        for i=17:27
            MAP(i,4)=-1;
        end
    end
end
if(yTarget>61||yTarget<4||xTarget<7||xTarget>57)
  if(yTarget>=34)
    for i=17:27
        MAP(i,61)=-1;
    end 
  else
     for i=37:47
        MAP(i,4)=-1;
     end
  end
end
 if(yStart<61&&yStart>4&&xStart>17&&xStart<27)
     for i=17:27
         MAP(i,yStart+1)=-1;
     end
 end
 if(yStart<61&&yStart>4&&xStart>37&&xStart<47)
     for i=37:47
         MAP(i,yStart-1)=-1;
     end
 end
 if(yTarget<61&&yTarget>4&&xTarget>17&&xTarget<27)
     for i=17:27
         MAP(i,yTarget-1)=-1;
     end
 end
  if(yTarget<61&&yTarget>4&&xTarget>37&&xTarget<47)
     for i=37:47
         MAP(i,yTarget+1)=-1;
     end
 end
 
 if(xStart<57)
     if(yStart<34&&yStart>31)
         for j=31:34
             MAP(xStart+1,j)=-1;
         end
     end
     for j=31:34
         MAP(57,j)=-1;
     end
     if(xStart<37)
         for j=31:34
             MAP(37,j)=-1;
         end
         if(xStart<17)
             for j=31:34
                 MAP(17,j)=-1;
             end
         end
     end
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LISTS USED FOR ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OPEN LIST STRUCTURE
%--------------------------------------------------------------------------
%IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
%--------------------------------------------------------------------------
OPEN=[];
%CLOSED LIST STRUCTURE
%--------------
%X val | Y val |
%--------------
% CLOSED=zeros(MAX_VAL,2);
CLOSED=[];
 
%Put all obstacles on the Closed list
k=1;%Dummy counter
for i=1:MAX_X
    for j=1:MAX_Y
        if(MAP(i,j) == -1)
            CLOSED(k,1)=i; 
            CLOSED(k,2)=j; 
            k=k+1;
        end
    end
end

xNode=xStart;
yNode=yStart;
[OPEN,CLOSED]=computer_cost(xNode,yNode,xTarget,yTarget,MAX_X,MAX_Y,OPEN,CLOSED);
%Once algorithm has run The optimal path is generated by starting of at the
%last node(if it is the target node) and then identifying its parent node
%until it reaches the start node.This is the optimal path
i=size(CLOSED,1);
xval=CLOSED(i,1);
yval=CLOSED(i,2);
if ( (xval == xTarget) && (yval == yTarget))
[Path1]=Optimal_path_computer(xStart,yStart,OPEN,CLOSED);
%  j=size(Path1,1);
%  %Plot the Optimal Path!
%  p=plot(Path1(j,1)+.5,Path1(j,2)+.5,'bo');
%  j=j-1;
%  for i=j:-1:1
%   pause(.1);
%   set(p,'XData',Path1(i,1)+.5,'YData',Path1(i,2)+.5);
%  drawnow ;
%  end
%  plot(Path1(:,1)+.5,Path1(:,2)+.5,'LineWidth',1);
else
 pause(1);
 h=msgbox('Sorry, No path exists to the Target!','warn');
 uiwait(h,5);
end

if(yTarget<=9&&yTarget>=4)
    Target=F(1);
    xval=xTarget;
    yval=yTarget;
    xTarget=58-12*mod(Target,2);
    yTarget=29-8*floor(Target/2);
    plot(xval+.5,yval+.5,'gd');
    text(xval+1,yval+.5,'Target')
    xStart=xval;
    yStart=yval;
else if(yTarget<=20&&yTarget>=15)
    Target=E(1);
    xval=xTarget;
    yval=yTarget;
    xTarget=38-12*mod(Target,2);
    yTarget=29-8*floor(Target/2-1);
    plot(xval+.5,yval+.5,'gd');
    text(xval+1,yval+.5,'Target')
    xStart=xval;
    yStart=yval;

    else if(yTarget<=31&&yTarget>=26)
    Target=D(1);
    xval=xTarget;
    yval=yTarget;
    xTarget=18-12*mod(Target,2);
    yTarget=29-8*floor(Target/2);
    plot(xval+.5,yval+.5,'gd');
    text(xval+1,yval+.5,'Target')
    xStart=xval;
    yStart=yval;
        else if(yTarget<=39&&yTarget>=34)
    Target=C(1);
    xval=xTarget;
    yval=yTarget;
    xTarget=58-12*mod(Target,2);
    yTarget=60-8*floor(Target/2-1);
    plot(xval+.5,yval+.5,'gd');
    text(xval+1,yval+.5,'Target')
    xStart=xval;
    yStart=yval;
            else if(yTarget<=50&&yTarget>=45)
    Target=B(1);
    xval=xTarget;
    yval=yTarget;
    xTarget=38-12*mod(Target,2);
    yTarget=60-8*floor(Target/2);
    plot(xval+.5,yval+.5,'gd');
    text(xval+1,yval+.5,'Target')
    xStart=xval;
    yStart=yval;
                else if(yTarget<=61&&yTarget>=56)
    Target=A(1);
    xval=xTarget;
    yval=yTarget;
    xTarget=18-12*mod(Target,2);
    yTarget=60-8*floor(Target/2);
    plot(xval+.5,yval+.5,'gd');
    text(xval+1,yval+.5,'Target')
    xStart=xval;
    yStart=yval;
                    end
                end
            end
        end
    end
end
MAP=2*(ones(MAX_X,MAX_Y));
for i=7:17
    MAP(i,4)=-1;
    MAP(i,31)=-1;
    MAP(i,34)=-1;
    MAP(i,61)=-1;
    MAP(i+20,4)=-1;
    MAP(i+20,31)=-1;
    MAP(i+20,34)=-1;
    MAP(i+20,61)=-1;
    MAP(i+40,4)=-1;
    MAP(i+40,31)=-1;
    MAP(i+40,34)=-1;
    MAP(i+40,61)=-1;
end
 
 
for j=4:31
    MAP(7,j)=-1;
    MAP(7,j+30)=-1;
    MAP(17,j)=-1;
    MAP(17,j+30)=-1;
    MAP(27,j)=-1;
    MAP(27,j+30)=-1;
    MAP(37,j)=-1;
    MAP(37,j+30)=-1;
    MAP(47,j)=-1;
    MAP(47,j+30)=-1;
    MAP(57,j)=-1;
    MAP(57,j+30)=-1;
end

MAP(xStart,yStart)=0;
MAP(xTarget,yTarget)=1;
if(yStart>61||yStart<4||xStart<7||xStart>57)
    if(yStart>=34)
        for i=37:47
            MAP(i,61)=-1;
        end
    else
        for i=17:27
            MAP(i,4)=-1;
        end
    end
end
if(yTarget>61||yTarget<4||xTarget<7||xTarget>57)
  if(yTarget>=34)
    for i=17:27
        MAP(i,61)=-1;
    end 
  else
     for i=37:47
        MAP(i,4)=-1;
     end
  end
end
 if(yStart<61&&yStart>4&&xStart>17&&xStart<27)
     for i=17:27
         MAP(i,yStart+1)=-1;
     end
 end
 if(yStart<61&&yStart>4&&xStart>37&&xStart<47)
     for i=37:47
         MAP(i,yStart-1)=-1;
     end
 end
 if(yTarget<61&&yTarget>4&&xTarget>17&&xTarget<27)
     for i=17:27
         MAP(i,yTarget-1)=-1;
     end
 end
  if(yTarget<61&&yTarget>4&&xTarget>37&&xTarget<47)
     for i=37:47
         MAP(i,yTarget+1)=-1;
     end
 end
 
 if(xStart<57)
     if(yStart<34&&yStart>31)
         for j=31:34
             MAP(xStart+1,j)=-1;
         end
     end
     for j=31:34
         MAP(57,j)=-1;
     end
     if(xStart<37)
         for j=31:34
             MAP(37,j)=-1;
         end
         if(xStart<17)
             for j=31:34
                 MAP(17,j)=-1;
             end
         end
     end
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LISTS USED FOR ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OPEN LIST STRUCTURE
%--------------------------------------------------------------------------
%IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
%--------------------------------------------------------------------------
OPEN=[];
%CLOSED LIST STRUCTURE
%--------------
%X val | Y val |
%--------------
% CLOSED=zeros(MAX_VAL,2);
CLOSED=[];
 
%Put all obstacles on the Closed list
k=1;%Dummy counter
for i=1:MAX_X
    for j=1:MAX_Y
        if(MAP(i,j) == -1)
            CLOSED(k,1)=i; 
            CLOSED(k,2)=j; 
            k=k+1;
        end
    end
end

xNode=xStart;
yNode=yStart;
[OPEN,CLOSED]=computer_cost(xNode,yNode,xTarget,yTarget,MAX_X,MAX_Y,OPEN,CLOSED);
%Once algorithm has run The optimal path is generated by starting of at the
%last node(if it is the target node) and then identifying its parent node
%until it reaches the start node.This is the optimal path
i=size(CLOSED,1);
xval=CLOSED(i,1);
yval=CLOSED(i,2);
if ( (xval == xTarget) && (yval == yTarget))
[Path2]=Optimal_path_computer(xStart,yStart,OPEN,CLOSED);
%  j=size(Path2,1);
%  %Plot the Optimal Path!
%  p=plot(Path2(j,1)+.5,Path2(j,2)+.5,'bo');
%  j=j-1;
%  for i=j:-1:1
%   pause(.1);
%   set(p,'XData',Path2(i,1)+.5,'YData',Path2(i,2)+.5);
%  drawnow ;
%  end
%  plot(Path2(:,1)+.5,Path2(:,2)+.5,'LineWidth',1);
else
 pause(1);
 h=msgbox('Sorry, No path exists to the Target!','warn');
 uiwait(h,5);
end
num2=size(Path2,1);
num1=size(Path1,1);
Path3=Path2;
for i=num1:-1:1
    Path3(num2+i,1)=Path1(i,1);
    Path3(num2+i,2)=Path1(i,2);
end
% j=size(Path3,1);
%  %Plot the Optimal Path!
%  p=plot(Path3(j,1)+.5,Path3(j,2)+.5,'bo');
%  j=j-1;
%  for i=j:-1:1
%   pause(.1);
%   set(p,'XData',Path3(i,1)+.5,'YData',Path3(i,2)+.5);
%  drawnow ;
%  end
end
