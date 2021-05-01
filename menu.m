clc
clear

load data.mat
load consts.mat MOVIE_N_SHINGLES

id = -1;
while id < 0
    id = menu_input('Insert User ID (1 to 943): ', 1, 943);
end
fprintf("\n")

loop = 1;
while loop
    fprintf('1 - Your Movies\n2 - Get Suggestions\n3 - Search Title\n4 - Exit\n');
    option = menu_input('Select choice: ', 1, 4);
    switch option
        case 1
            fprintf("\nYour Movies:\n")
            fprintf("\t> %s\n", movie_names{user_movies{id}})
            fprintf("\n")
        case 2
            fprintf("\n1- Action, 2- Adventure, 3- Animation, 4- Children’s\n5- Comedy, 6- Crime, 7- Documentary, 8- Drama\n9- Fantasy, 10- Film-Noir, 11- Horror, 12- Musical\n13- Mystery, 14- Romance, 15- Sci-Fi, 16- Thriller\n17- War, 18- Western\n")
                    
            while 1
                category = menu_input('Select choice: ', 1, 18);
                if category == -1
                    fprintf("Invalid category!\n\n");
                else
                    break
                end
            end
            
            % Find the closest user to the current one
            [~, idx] = min(user_distance(id, [1:id-1 id+1:end]));
            if idx >= id
                idx = idx + 1;
            end
            
            % Select the movies of the nearest user that we have not
            % watched and filter the category
            idxs = zeros(length(movie_names), 1);
            idxs(user_movies{idx}) = 1;
            idxs(user_movies{id}) = 0;
            idxs = idxs' & [movie_categories{:, category}];
            
            fprintf("\nSuggestions:\n")
            
            if sum(idxs) == 0
                disp('No suggestions found!')
            else
                fprintf("\t> %s\n", movie_names{idxs})
            end
            
            fprintf("\n")
        case 3
            search = input('Write a string: ', 's');
            
            if length(char(search)) < MOVIE_N_SHINGLES
                fprintf("\nMinimum string size for search is %d\n\n", MOVIE_N_SHINGLES)
                continue
            end
            
            % Turn the user typed string into signatures to compare with
            % the movie names signatures
            str = minhash_single_string(search);
            simmilarity = zeros(height(movie_names), 1);
            for i=1:height(movie_names)
                simmilarity(i) = sum(str == movie_signatures(:, i))/length(str);
            end
            
            % Return only results with distance inferior to .99,
            % simmilarity bigger than .01 and narrow the results to 5 max
            results = sum(simmilarity > .01);
            if results > 5
                results = 5;
            end
            
            fprintf("\nResults for '%s':\n", search)
            
            if results == 0
                disp('No results found!')
            end
                
            % Find the closest matches, if they exist
            for i=1:results
                [~, M] = max(simmilarity);
                fprintf("\t> %s\n", movie_names{M})
                simmilarity(M) = -1;
            end
            
            fprintf("\n")
        case 4
            loop = 0;
        case -1
            fprintf("\nOpção Inválida!\n\n")
    end
end

function option = menu_input(message, min, max)
    option = str2double(input(message, 's'));
    
    if isnan(option) || option < min || option > max
        option = -1;
    end
end