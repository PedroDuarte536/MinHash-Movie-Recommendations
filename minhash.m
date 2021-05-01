% For this MinHash implementation we used random permutations
% As this data will never change and we won't need to use it
% during run time we don't need to save the user permutations
% For the same reason we can calculate the distances immediatly,
% making it more straightforward to find the nearest user at run time

% The function takes the following arguments
% c         Cell array storing the movie ids for each user
% cunion    Unique movie ids
% N         Number of hash functions
function distances = minhash(c, cunion, N)
    union_len = length(cunion);
    
    Ndocuments = length(c);
    shingles = zeros(union_len, Ndocuments);
    
    % Binary representation of having a shingle (movie id) for each user
    for i=1:Ndocuments
        shingles(:, i) = ismember(cunion, c{i})';
    end
    
    % Create the signatures
    signatures = zeros(N, Ndocuments);
    for i=1:N
        perm = randperm(union_len);
        
        for j=1:union_len
            % Iterate over the permutation indexes, by ascending order of
            % value (we need the min hash). 
            % The indexes of signatures changing their value are the ones 
            % which have the shingle represented by the current permutation
            % index and where the signatures matrix has still no
            % value.
            assinatura_idx = shingles(perm == j, :) == 1 & signatures(i, :) == 0;
            signatures(i, assinatura_idx) = j;
            
            % If all the signatures for this hash function have a value
            % we can skip to the next
            if ~sum(signatures(i, :) == 0)
                break
            end    
        end
    end
    
    % With the MinHash signatures found, calculate all the distances
    distances = zeros(Ndocuments);
    for i=1:Ndocuments

        for j=i+1:Ndocuments
            distances(i, j) = sum(signatures(:, i) ~= signatures(:, j))/N;
            distances(j, i) = distances(i, j);
        end

    end
end