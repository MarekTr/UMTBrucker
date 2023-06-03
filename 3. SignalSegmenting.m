%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Marek Traczynski    %%%
%%%       June 2022        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%check if figure is opened
if (isempty(findobj('type','figure','name','Wykres')))
    error('Brak otwartego okna z wykresem')
end

%% TODO: ZMIANA STAŁYCH NA ZMIENNE DYNAMICZNE- MOZE FUNKCJA?
Zmodified = step1.Zmodified;
Fz = step1.Fz;

%% variables definitions
n=0; % number of points
m=0; % numer of pairs
M=[]; % Matrix of points coordinates
indx=0; % Vector with stored indexes of chosen points on plot
segIndxs=[1,1]; % stores begining and end indexes of each segment
i=0; % loop counter

%% dividing whole plot into several segments
warndlg('Zaznacz początkowy i końcowy punkt segmentu','','modal');
while(1)
        n=n+1;
        m=m+1;
        zoom on
        waitforbuttonpress; % waiting for mouse click (time for setting zoom)
        %% choosing first sample
        M(n,:)=ginput(1); % get click coordinates
        [~, indx(n)] = min(abs(Zmodified-M(n,1))); % find closest sample to the one selected
        zoom on
        waitforbuttonpress; %w aiting for mouse click (time for setting zoom)
        %% choosing last sample
        M(n+1,:)=ginput(1); % get click coordinates
        [~, indx(n+1)] = min(abs(Zmodified-M(n+1,1))); % find closest sample to the one selected
        segIndxs(m,:)=[indx(n),indx(n+1)]; % store indexes of first and last segment sample
        hold on
        legend('hide')
        xline(M(n,1)) % create vertical line at the begining of segment
        xline(M(n+1,1)) % create vertical line at the end of segment
        plot(Zmodified(segIndxs(m,1):segIndxs(m,2)),Fz(segIndxs(m,1):segIndxs(m,2)),'color',rand(1,3),'LineWidth',2)
        n=n+1;
        if (questdlg('Chcesz wyodrębnić kolejny segment?','Podział na segmenty', 'Tak','Nie','Nie') == 'Tak')
            continue
        else
%             n=n+1;
%             segIndxs(n,:)=[indx(n),numel(Zmodified)]; %add last segment
%             plot(Zmodified(segIndxs(n,1):segIndxs(n,2)),Fz(segIndxs(n,1):segIndxs(n,2)),'color',rand(1,3),'LineWidth',2)
            zoom off
            zoom out
            break
        end       
end
%% selecting segments for further analysis
if (questdlg('Wyeksportować wszystkie segmenty?','Wybór segmentów', 'Tak','Wybierz segmenty','Tak') == 'Tak')       
    chosenSegmentsId=1:m;
    i=m;
else
    while(1)
            i=i+1;
            [temp,~]=ginput(1); %
            [~, temp] = min(abs(Zmodified-temp));        
            for k=1:m
                if(ismember(temp,segIndxs(k,1):segIndxs(k,2))) % if index is in the n segment range
                    chosenSegmentsId(i)=k; % create vector with segments numbers
                end
            end
    
        if (questdlg('Chcesz wybrac kolejny segment?','Wybór segmentów do analizy', 'Tak','Nie','Nie') == 'Tak')
            continue
        else
            chosenSegmentsId=sort(chosenSegmentsId);
            break
        end
    end
end

disp(['Wykres podzielono na ',num2str(m),' segmenty/ów. ', 'Do dalszej analizy wybrano ', num2str(i), ' segmenty/ów.' ])
%% create new arrays form selected segments
for k=1:numel(chosenSegmentsId)
    temp = Zmodified(segIndxs(chosenSegmentsId(k),1):segIndxs(chosenSegmentsId(k),2));
    eval(strcat('Segment', num2str(k),'.Z = temp;'));
    temp = Fz(segIndxs(chosenSegmentsId(k),1):segIndxs(chosenSegmentsId(k),2));
    eval(strcat('Segment', num2str(k),'.Fz = temp;'));
end

clearvars M temp i m n k indx Zmodified segIndxs chosenSegmentsId Fz

segFz=Segment1.Fz;
segZ=Segment1.Z;
