function drawpoint(fitness_paretolast,fitness,Serial_Compromise)
    figure
    box on;
    hold on
    for i=1:size(fitness_paretolast,2)
        if i==Serial_Compromise
            plot(fitness_paretolast(1,i),fitness_paretolast(2,i),'kp','MarkerSize', 8, 'MarkerFaceColor','k');
            hold on
        else
            plot(fitness_paretolast(1,i),fitness_paretolast(2,i),'ko','MarkerSize', 3, 'MarkerFaceColor','k');
        end
    end
    xlabel('Total distribution cost')
    ylabel('Discharging profit')
end