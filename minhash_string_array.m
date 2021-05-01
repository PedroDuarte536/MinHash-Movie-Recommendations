% This function will run the minhash_single_string function for every
% string in a cell array and join their signatures in a single matrix
function signatures = minhash_string_array(string_list)
    load 'consts.mat' MOVIE_HASH_SEEDS
    
    Ndocuments = length(string_list);
    signatures = zeros(length(MOVIE_HASH_SEEDS), Ndocuments);
    
    for i=1:Ndocuments
        string = string_list{i};        
        signatures(:, i) = minhash_single_string(string);
    end
end