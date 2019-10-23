function [jtmargpot jtmess]=ShaferShenoy(jtpot,infostruct)
%SHAFERSHENOY Perform full round of Shafer Shenoy messages on a Junction Tree
% [jtmargpot jtmess]=ShaferShenoy(jtpot,infostruct)
%
% Perform (sum) messages for a JT specified with potentials jtpot. The distribution marginals are contained in
% the returned jtmargpot.
%
% infostruct is a structure with information about the Junction Tree:
% infostruct.cliquetree : connectivity structure of Junction Tree cliques
% infostruct.EliminationSchedule is a list of clique to clique
% eliminations. The root clique is contained in the last row.
% infostruct.ForwardOnly is optional. If this is set to 1 only the schedule contained
% in infostruct.EliminationSchedule is carried out. Otherwise both a
% forward and backward schedule is carried out.
Atree=infostruct.cliquetree; % connectivity structure of JT cliques
import brml.*
schedule=infostruct.EliminationSchedule;
ForwardOnly=0;
if isfield(infostruct,'ForwardOnly')
    ForwardOnly=infostruct.ForwardOnly;
end
if ~ForwardOnly
    reverseschedule=flipud(fliplr(schedule));
    schedule=vertcat(schedule,reverseschedule); % full round over all separators in both directions
end
for count=1:length(schedule)
    [elim neighb]=assign(schedule(count,:));
    if elim~=neighb
        incoming=setdiff(neighb,neigh(Atree,elim));
        if isempty(incoming)
            jtmess{elim,neighb} = sumpot(jtpot{neighb}, jtpot{neighb}.variables,0);
        else
            jtmess{elim,neighb} = sumpot(multpots([jtmess(incoming) jtpot{neighb}]), jtpot{neighb}.variables,0);
        end
    end
end
for c=1:length(jtpot)
    jtmargpot{c}=multpots(jtmess(neigh(infostruct.cliquetree,c),c));
end