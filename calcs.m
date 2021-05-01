% Define some constants for Option 3
MOVIE_MAX_HASH          = 199999;
MOVIE_N_SHINGLES        = 5;
MOVIE_N_HASH_FUNCTIONS  = 143;
MOVIE_HASH_SEEDS = (1:MOVIE_N_HASH_FUNCTIONS)*127;
save 'consts.mat' MOVIE_MAX_HASH MOVIE_N_SHINGLES MOVIE_HASH_SEEDS

% Load the important data from the MovieLens data file
% The first two columns are the only important for  
% this project wich represent the pairs user-movie
udata = load('u.data');
u = udata(1:end,1:2); 
clear udata;

% Load the important data from the supplied 'u_item.txt' file
% The first column represents the movie names and the others 
% represent categories. Since the second column is the category
% 'unknown', that will never be searched, we only save columns "3:end"
dic = readcell('u_item.txt');
movie_names = dic(:, 1);
movie_categories = dic(:, 3:end);
clear dic;

% Get the unique user ids
users = unique(u(:,1));
Nu= length(users);

% Create a list for each user with the movie ids he has watched
movies = u(:,2);
user_movies = cell(Nu, 1);

for i=1:Nu
    user_movies{i} = movies(u(:,1) == users(i));
end

% Get the distance between users
user_distance = minhash(user_movies, unique(movies), 200);

% Get the title's MinHash signatures
movie_signatures = minhash_string_array(movie_names);

      
save 'data.mat' movie_names movie_categories user_movies user_distance movie_signatures