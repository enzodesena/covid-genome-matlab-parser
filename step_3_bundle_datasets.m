% DATASETS = STEP_3_BUNDLE_DATASETS()
%   This script reads the dataset folders and returns a struct array 
%   containing all the datasets. The datasets are returned in chronological 
%   order according to the collection data.
%
%   STEP_3_BUNDLE_DATASETS(PARSER_SETTINGS)
%   This runs the same script but using your own settings 
%   (see default_settings.m for info).
%
% Author: Enzo De Sena (enzodesena AT gmail DOT com)
% Date: 17/4/2020
% License: MIT

function [datasets, collection_dates] = step_3_bundle_datasets(parser_settings)


%% Load settings
if nargin < 1
    parser_settings = default_parser_settings();
end

%% Load datasets
dataset_folder_contents = dir(parser_settings.dataset_directory_name);
num_files = length(dataset_folder_contents);
collection_dates = [];
datasets = [];

for n=1:num_files
    filename = dataset_folder_contents(n).name;
    
    % Exclude current directory and yaml file in directory
    if startsWith(filename, '.') || endsWith(filename, '.yaml') || endsWith(filename, '.txt')
       continue; 
    end
    
    filepath = strcat(parser_settings.dataset_directory_name, filename);
    dataset = load(filepath);
    
    if length(dataset.collection_date) > 1 || ...
       dataset.collection_date < datenum('01-Jan-2001', 'dd-mmm-yyyy')
        warning(strcat('Dataset with accession n.',dataset.accession, ...
            ' was ignored because collection date is incomplete, ',...
            'which will not allow sorting dates.'));
        continue;
    end

    assert(isfield(dataset, 'collection_date'));
    collection_date = datetime(double(dataset.collection_date),'ConvertFrom','datenum');

    if isfield(dataset, 'gene_struct')
        dataset = rmfield(dataset, 'gene_struct')
    end
    
    collection_dates = [collection_dates, collection_date];
    datasets = [datasets, dataset];
end


%% Sort according to collection date
[collection_dates, sorting_indices] = sort(collection_dates);
datasets = datasets(sorting_indices);


