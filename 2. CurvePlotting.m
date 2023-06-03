%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Marek Traczynski    %%%
%%%     October  2022      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Cancel axis position offset
for i=1:1%stepsNum 

    eval(strcat('Z = ', 'step', num2str(i),'.Z;'));
    eval(strcat('Fz = ', 'step', num2str(i),'.Fz;'));

    if(Z(1)~=0) % if first sample is different than 0 (there is an offset)
        if(Z(1)<Z(end)) %if needle moving DOWN
            Zmodified = Z - Z(1);
        elseif(Z(1)>Z(end)) %if needle moving UP
            Zmodified = Z - Z(end);
        else %TODO: check if possible
            error('nieobslugiwany wyjatek')
        end
    else
        Zmodified=Z;
    end

    eval(strcat('step', num2str(i),'.Zmodified',' = Zmodified;')) % add position to structure
end


       
%% Plot figures
for i=1:1%stepsNum 
    f=figure('Name','Wykres','NumberTitle','off');
    f.WindowState = 'maximized';
    eval(strcat('xAxis = ', 'step', num2str(i),'.Zmodified'));
    eval(strcat('yAxis = ', 'step', num2str(i),'.Fz'));
    plot(xAxis,yAxis)
    hold on
    plot(xAxis,yAxis,'.')
    hold on
    grid on
    grid minor
    xlabel('Position [mm]')
    ylabel('Force [N]')

%legend('Proba3 \phi0.6mm 20mm 0\circ','Proba3 \phi0.6mm 20mm 10\circ','Proba3 \phi0.6mm 20mm 20\circ','Proba3 \phi0.6mm 20mm 20\circ V=4x','Proba3 \phi0.6mm 20mm 0\circ powrot','Proba3 \phi0.6mm 20mm 10\circ powrot','Proba4 \phi0.6mm 20mm 20\circ powrot','Proba3 \phi0.6mm 20mm 20\circ V=4x')
    legend(name(1:end-4),'Interpreter','none')
end
%% Clear unused data
if(1)
    clearvars X Y T Fx Y X V1 V2 V3 Ff COF i f colNum Zmodified Z Fz xAxis yAxis 
end