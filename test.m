opts = detectImportOptions("Pokedex.csv");
opts = setvartype(opts,{'identifier'},'string');
pokedex = readtable('Pokedex.csv',opts);

%Reference base team
baseTeam = ["Blaziken","Gallade","Gardevoir","Flygon","Roserade","Crawdaunt"];
baseTeamID = [];
for i = 1:length(baseTeam)
    x = strcmp(baseTeam{i},pokedex.identifier);
    index = find(x);
    baseTeamID = [baseTeamID; index];
end

%Request user input
prompt = 'Type name of substitute: ';
x = 0;
y = 0;
subTeamID = [];
while x == 0
    str = input(prompt, 's');
    i = strcmp(str,pokedex.identifier);
    j = strncmp(str, pokedex.identifier, floor(length(str)/2));
    y = y + 1;

    if isempty(str)                 %For blank entry
        x = 1;
    elseif isempty(find(i)) == 0    %For exact match
        index = find(i);
        indx = 1;
    elseif isempty(find(j)) == 0    %For inexact match
        index = find(j);
        [indx,tf] = listdlg('ListString',pokedex.identifier(index));
    else
        prompt = 'No matches for input. Please try again: ';
    end
   prompt = 'Anyone else? (Leave blank if No): '; 
   str = [];
   if x == 0
       subTeamID(y,1) = index(indx);
   end
end

tic

%Catelog types of user pokemon
pokemonTypes = readtable('pokemon_types.csv');
loc = zeros(2);
types = zeros(2);
index = [];
for i = 1:length(subTeamID)
    loc = find(pokemonTypes.pokemon_id == subTeamID(i));
    types(i,:) = pokemonTypes.type_id(transpose(loc));       
end
for j = 1:18
    index = [index; max(max(types == j))];
end

%Determine best combination:
%The first n-number of pokemon in the base team will be substituted by 
%n-number of inputted substitutes.
testTeamID = baseTeamID;
testTeamID(1:length(subTeamID),1) = subTeamID;

%Set some baseline parameters
pokemonTypes = readtable('pokemon_types.csv');
teamTypes = [];
loc = zeros(2);
types = zeros(2);
index = [];
Eff = [];
TTI = 0;
%This double nested for loop will test each inputted substitute pokemon
%with each remaining pokemon on the base team. j is the location of the
%moving substitute, i is the location of where the substitute moves to.
for i = 1:(length(baseTeamID)-length(subTeamID))
    for j = 1:length(subTeamID)
        %A substitute pokemon is placed at a new location in the party, and
        %the spot the substitute switches from is replaced with the pokemon
        %that was originally occupied that spot on the base team.
        testTeamID(i+length(subTeamID)) = subTeamID(j);
        testTeamID(i) = baseTeamID(i);
        teamTypes = [];

        %This function catelogs all the types of the test team.
        for k = 1:length(testTeamID)
            loc = find(pokemonTypes.pokemon_id == testTeamID(k));
            typesIndex(k,:) = pokemonTypes.type_id(transpose(loc));       
        end
        
        %This function sets T/F if any of the 18 types was found in the
        %test team.
        for l = 1:18
            teamTypes = [teamTypes; max(max(typesIndex == l))];
        end
        TTI = find(teamTypes);
        
        %This function calculates the number of types combinations the test
        %team is super effective against. There are 18 variations of single
        %type pokemon and 18x18=324 variations of dual type pokemon.
        typeEff =  readtable('type_efficacy.csv');
        for k = 1:length(TTI)
            for l = 1:18
                for m = 1:18
                    damage1 = typeEff.damage_factor(18*TTI(k)-18+l)/100;
                    damage2 = typeEff.damage_factor(18*TTI(k)-18+m)/100;
                    
                    if l == m
                        damageTotal = damage1;
                    else
                        damageTotal = damage1 * damage2;
                    end
                    
                    Eff = [Eff; i+j TTI(k) l m damageTotal];
                end
            end
        end
    end
end

%Convert double to table
Eff = array2table(Eff);
Eff.Properties.VariableNames = {'Tested_Team' 'Attacking_Type' 'Defending_Type_1' 'Defending_Type_2' 'Damage'};

%Calculate most effective team
accumarray(Eff.Tested_Team,Eff.Damage)

toc
