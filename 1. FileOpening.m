%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Marek Traczynski    %%%
%%%         v 0.4          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear % delete everything form workspace

%% Choose and open file
[name, path] = uigetfile('*.txt'); %ask user for file

if isequal(name,0) %check if user aborted 
   disp('Aborted by user');
   return
end

%% initialize variables.
filename = fullfile(path, name);
stepsRow = 4;
headersRow = 18;
formatSpec = [];

%% open the text file.
fileID = fopen(filename,'r');

%% read each line as string
As = textscan(fileID,'%[^\n\r]'); 
frewind(fileID) %reset file pointer

%% find number of steps
temp=strsplit(string(As{1, 1}{stepsRow, 1}));
stepsNum = str2double(temp(end));

%% find headers names
headersStr=strsplit(string(As{1, 1}{headersRow, 1}));
colNum=length(headersStr);

%% find beginning of each step
temp=1;
for i = 1:size(As{:})
    if regexp((As{1, 1}{i, 1}),'Step No.') % check if in i-th line is searched string
        stepNumRows(temp) = i; % assign line number to vector
        temp=temp+1;
    end
end
if(length(stepNumRows)~=stepsNum)
    error('Script error. Different steps number than declared at the file beggining')
end
dataLengthRows = stepNumRows+6; % from known offset calculate data length line of each step
startRows = stepNumRows+10; % from known offset calculate data beginning line of each step

%% read number of data lines to read in each step 

for i = 1:stepsNum
    temp=strsplit(string(As{1, 1}{dataLengthRows(i), 1}));
    dataLengths(i) = str2double(temp(end));
end
endRows=startRows+dataLengths-1;

%% prepare line format 
for k=1:colNum
  formatSpec = strcat(formatSpec, '%f'); % create a vector with the number of '%f' suiting the number of columns    
end
formatSpec = strcat(formatSpec,'%[^\n\r]'); % add '%[^\n\r]' at the end

%% read and save data
for i = 1:stepsNum
    %% read columns of data according to line format
    frewind(fileID) %reset file pointer
    textscan(fileID, '%[^\n\r]', startRows(i)-1, 'WhiteSpace', '', 'ReturnOnError', false); % rewind file for (startRows(i)-1) lines
    dataArray = textscan(fileID, formatSpec, dataLengths(i), 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN,'ReturnOnError', false); % read 

    %% save data as structure
    for k=1:colNum
        eval(strcat('step', num2str(i),'.',headersStr(k),' = dataArray{:, k};'));
    end
        eval(strcat('step', num2str(i),'.startRow',' = startRows(i);'));
        eval(strcat('step', num2str(i),'.endRow',' = endRows(i);'));
        eval(strcat('step', num2str(i),'.dataLength',' = dataLengths(i);'));

end

%% close the text file.
fclose(fileID);

%% clear temporary variables
clearvars filename As startRow formatSpec fileID dataArray ans str DataCountRow endRow stepsRow k headers headersRow headersStr temp stepNumRows startRows i endRows dataLengthRows dataLengths;
%Rysowanie_przebiegow
%temp_wykresy
