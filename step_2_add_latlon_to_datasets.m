% STEP_2_ADD_LATLON_TO_DATASETS(GOOGLE_API_KEY)
%   This step is **optional** and is only needed if you also want to add 
%   the latitude and longitude of the locality of individual sequences  
%   to the individual datasets.
%   GOOGLE_API_KEY is your own Google Map's API key; you'll
%   need to create your own account with Google at 
%   [Google Maps Platform](https://cloud.google.com/maps/official).
%
%   STEP_2_ADD_LATLON_TO_DATASETS(GOOGLE_API_KEY, PARSER_SETTINGS)
%   This runs the same script but using your own settings 
%   (see default_settings.m for info).
%
%   Author: Enzo De Sena (enzodesena AT gmail DOT com)
%   Date: 9/4/2020
%   License: MIT

function step_2_add_latlon_to_datasets(google_API_key, parser_settings)


%% Load settings
if nargin == 0
    error('You need a Google Maps API key to run this script. Remember also that running this step is optional');
elseif nargin == 1
    parser_settings = default_parser_settings();
end

%% Run query to google maps API for each
dataset_folder_contents = dir(parser_settings.dataset_directory_name);
num_files = length(dataset_folder_contents);

for n=1:num_files
    filename = dataset_folder_contents(n).name;
    
    % Exclude yaml file in directory
    if startsWith(filename, '.') || endsWith(filename, '.yaml') || endsWith(filename, '.txt')
        continue;
    end
    
    filepath = strcat(parser_settings.dataset_directory_name, filename);
    dataset = load(filepath);
 
    disp('-------');
    disp(strcat('Handling filepath: ', filepath));
    disp(strcat('Accession: ', dataset.accession));
    locality = dataset.locality;
    disp(strcat('Locality: ', locality));
    
    if isfield(dataset, 'latitude')
        disp(strcat('Ignored because lat/lon already present. Latitude: ', num2str(dataset.latitude), ', longitude: ', num2str(dataset.longitude)));
        continue;
    end
    
    [dataset.latitude, dataset.longitude] = get_latlon_from_google(locality, google_API_key);
    disp(strcat('Found. Latitude: ', num2str(dataset.latitude), ', longitude: ', num2str(dataset.longitude)));
    save(filepath, '-struct', 'dataset');
end






function [latitude, longitude] = get_latlon_from_google(locality, google_API_key)
locality = strrep(locality, ' ', '%20');
google_search = ...
    ['https://maps.googleapis.com/maps/api/geocode/json?key=', ...
    google_API_key,'&address=',locality];

%% Download data using Google's API
json_output = parse_json(urlread(google_search));

%% Extract latitude and longitude
latitude=json_output{1}.results{1}.geometry.location.lat;
longitude=json_output{1}.results{1}.geometry.location.lng;

