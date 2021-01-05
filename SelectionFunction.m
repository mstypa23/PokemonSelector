function [effectiveness] = SelectionFunction(primaryTeam, alternate)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

pokedex = readtable("Pokedex.xlsx");
pokemon = pokedex.Pokemon;
typeType = readtable("TypeType.xlsx");

index = [];
for i = 1:length(primaryTeam)
    num = find(strcmp(primaryTeam(i),pokedex.Pokemon));
    index = [index, num(1)];
end

typeSet = [];
indexI = [];
indexII = [];
for i = 1:length(primaryTeam)
    typeI = string(pokedex.TypeI(index(i)));
    typeII = string(pokedex.TypeII(index(i)));
    numI = find(strcmp(typeI,typeType.Attack));
    numII = find(strcmp(typeII,typeType.Attack));
    
    if max(numI == typeSet) == 1
        else typeSet = [typeSet numI];
    end
    
    if max(numII == typeSet) == 1
        else typeSet = [typeSet numII];
    end
    
end

superSet = [];
for i = 1:length(typeSet)
    for j = 2:6
       
        super = string(typeType{typeSet(i),j});
        numSuper = find(strcmp(super,typeType.Attack));
        
        if max(numSuper == superSet) == 1
        else    superSet = [superSet numSuper];
        end
    end
end

effectiveness = length(superSet);
% A2 = 18;
% formatSpec = 'A team of %s, %s, %s, %s, %s, and %s is super effective against %i/%i types \n';
% fprintf(formatSpec,string(primaryTeam(1)),string(primaryTeam(2)),string(primaryTeam(3)), ...
%              string(primaryTeam(4)),string(primaryTeam(5)), string(primaryTeam(6)),effectiveness,A2);


end

