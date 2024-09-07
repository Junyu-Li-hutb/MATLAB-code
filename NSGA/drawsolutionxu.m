function drawsolutionxu(solution_Compromise,Coordinate_x,Coordinate_y,Chargingindex)
    figure
    box on;
    hold on;
    for i=1:length(solution_Compromise)
        path=solution_Compromise{1,i};
        for j=1:length(path)-1
            nowNode=path(j);nextNode=path(j+1);
            if nowNode>200
                nowNode=nowNode-200;
                x=[Coordinate_x(nowNode),Coordinate_x(nextNode)];
                y=[Coordinate_y(nowNode),Coordinate_y(nextNode)];
                plot(x,y,'-k')
                hold on
                continue
            end
            if nextNode>200
                nextNode=nextNode-200;
                x=[Coordinate_x(nowNode),Coordinate_x(nextNode)];
                y=[Coordinate_y(nowNode),Coordinate_y(nextNode)];
                plot(x,y,'--k')
                hold on
                continue
            end
            x=[Coordinate_x(nowNode),Coordinate_x(nextNode)];
            y=[Coordinate_y(nowNode),Coordinate_y(nextNode)];
            plot(x,y,'-k')
            hold on
        end
        
    end
    hold on
    w1=plot(Coordinate_x(1),Coordinate_y(1),'kp','MarkerSize', 8, 'MarkerFaceColor', 'k');
    hold on
    w2=plot(Coordinate_x(22:121),Coordinate_y(22:121),'ko','MarkerSize', 4, 'MarkerFaceColor', 'k');
    hold on
    w3=plot(Coordinate_x(Chargingindex{1,1}),Coordinate_y(Chargingindex{1,1}),'k^','MarkerSize', 6, 'MarkerFaceColor', 'k');
    hold on
    w4=plot(Coordinate_x(Chargingindex{1,2}),Coordinate_y(Chargingindex{1,2}),'kd','MarkerSize', 6, 'MarkerFaceColor', 'k');
    hold on
end