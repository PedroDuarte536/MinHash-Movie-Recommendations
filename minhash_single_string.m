% This implementation of MinHash uses the DJB31MA algorithm to create a
% signature of a string
function signature = minhash_single_string(str)
    load 'consts.mat' MOVIE_MAX_HASH MOVIE_N_SHINGLES MOVIE_HASH_SEEDS
    
    % Turn it always lower case so that we can easily search movie titles
    % without case sensitivity
    str = lower(str);
    len = length(str);
    signature = zeros(length(MOVIE_HASH_SEEDS), 1); 

    for j=1:len-MOVIE_N_SHINGLES+1
        % hash the current shingle with every hash function seed 
        s = str(j:j+MOVIE_N_SHINGLES-1);
        hashes = mod(DJB31MA(s, MOVIE_HASH_SEEDS), MOVIE_MAX_HASH)' +1;
        
        % Save the hashes from the hash functions where the signature 
        % value still has no value or the new hash has a lower value
        idxs = signature == 0 | hashes < signature;
        signature(idxs) = hashes(idxs);
    end
    
end