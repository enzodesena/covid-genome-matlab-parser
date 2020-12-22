function [collection_date, locality, is_homo_sapiens] = get_features(features)

[N_lines, ~] = size(features);

is_homo_sapiens = false;
collection_date = [];
locality = [];

pattern_col_date = '/collection_date="';
pattern_country = '/country="';
pattern_homo_sapiens = '/host="Homo sapiens"';

for n=1:N_lines
    string = features(n, :);
    
    if contains(string, pattern_col_date)
        collection_date = extractBetween(string, pattern_col_date, '"');
        collection_date = collection_date{1};
    elseif contains(string, pattern_homo_sapiens)
        is_homo_sapiens = true;
    elseif contains(string, pattern_country)
        locality = extractBetween(string, pattern_country, '"');
        locality = locality{1};
    end
end