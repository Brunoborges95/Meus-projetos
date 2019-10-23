load cliques.mat
% find cliques that are wholly contained in another:
% Start by assuming all cliques are unique. If we find a clique that is not
% unique we eliminate it and search over the remaining.
uniqueflag=true(1,length(cl));
for i=1:length(cl)
    for j=find(uniqueflag)
        if i~=j
            if isempty(setdiff(cl{i},intersect(cl{i},cl{j})));
                uniqueflag(i)=false;
                break;
            end
        end
    end
end

% convert to decimal form:
clunique=cl(find(uniqueflag));
for i=1:length(clunique)
    for j=1:length(clunique{i})
        D(i,clunique{i}(j))=1;
    end
end
dec=2.^(9:-1:0);
sort(sum(repmat(dec,17,1).*D,2))