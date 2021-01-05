

primaryTeam = {'Blaziken','Gallade','Gardevoir','Flygon','Roserade','Crawdaunt'};
typesTotal = 18;
% 'Heracross', 'Growlith', 'Exadrill', 'Metagross', 'Volcarona', ...
% 'Togekiss', 'Garchomp', 'Archeops', 'Hydreigon', 'Salamence', ...
% 'Feraligatr', 'Walrein', 'Wailord', 'Seismitoad', 'Heatran'};

prompt = 'Type name of who to substitute in: '
alternate = input(prompt, 's');

prompt = 'Anyone else? (Leave blank if No)'
str = input(prompt, 's')

if isempty(str)
else alternate = [alternate, input(prompt)]
end
   
pokeMatrix = [];
testTeam = primaryTeam;
for i = 1:length(primaryTeam)
    testTeam{i} = alternate;
    effectiveness = SelectionFunction(testTeam);
    pokeMatrix = [pokeMatrix; i effectiveness];
    testTeam = primaryTeam; 
end

maxEff = max(pokeMatrix(:,2));
maxEff == pokeMatrix(:,2);


n = sum(maxEff == pokeMatrix(:,2))
sub = [];

for i = 1:length(pokeMatrix)
    if maxEff == pokeMatrix(i,2)
        sub = [sub string(primaryTeam(i))];
    end
end

switch n
    case 1
        formatSpec = 'Substitute in %s with %s to be super effective against %i/%i types. \n';
        fprintf(formatSpec, string(primaryTeam(n)), alternate, pokeMatrix(n,2), typesTotal);
    case 2
        formatSpec = 'Substitute in %s with %s or %s to be super effective against %i/%i types. \n';
        fprintf(formatSpec, alternate, string(primaryTeam(n-1)), string(primaryTeam(n)), pokeMatrix(i,2), typesTotal);
    case 3
        formatSpec = 'Substitute in %s with %s, %s, or %s to be super effective against %i/%i types. \n';
        fprintf(formatSpec, alternate, string(primaryTeam(n-2)), string(primaryTeam(n-1)),string(primaryTeam(n)), pokeMatrix(i,2), typesTotal);
    case 4
        formatSpec = 'Substitute in %s with %s, %s, %s or %s to be super effective against %i/%i types. \n';
        fprintf(formatSpec, alternate, string(primaryTeam(n-3)), string(primaryTeam(n-2)), string(primaryTeam(n-1)), string(primaryTeam(n)), pokeMatrix(i,2), typesTotal);
    case 5
        formatSpec = 'Substitute in %s with %s, %s, %s, %s, %s, or %s to be super effective against %i/%i types. \n';
        fprintf(formatSpec, alternate, string(primaryTeam(n-4)), string(primaryTeam(n-3)), string(primaryTeam(n-2)), string(primaryTeam(n-1)), string(primaryTeam(n)), pokeMatrix(i,2), typesTotal);
    case 6
        formatSpec = 'Subsitute in %s with anyone to be super effective against %i/%i types. \n';
        fprintf(formatSpec, alternate, pokeMatrix(i,2), typesTotal);
end
