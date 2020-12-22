% STEP_1_DOWNLOAD_GENBANK_TXT()
%   This will download all the sequences into a directory `dataset` as 
%   individual `.mat` files. Re-running this script will only download 
%   files that are not present in the `dataset` directory, so you can run 
%   it again to keep your dataset up-to-date with the NCBI dataset.
% 
%   STEP_1_DOWNLOAD_GENBANK(PARSER_SETTINGS)
%   This runs the same script but using your own settings 
%   (see default_settings.m for info).
% 
%   Author: Enzo De Sena (enzodesena AT gmail DOT com)
%   Date: 22/12/2020
%   License: MIT

function step_1_download_genbank_txt(parser_settings)

%% Load settings
if nargin < 1
    parser_settings = default_parser_settings();
end

if ~exist(parser_settings.dataset_directory_name, 'dir')
	mkdir(parser_settings.dataset_directory_name)
end

txt_filename = strcat(parser_settings.dataset_directory_name, ...
                      'ncov-sequences.txt');

disp('Downloading COVID-19 metadata from NCBI website');
websave(txt_filename, parser_settings.ncbi_ncov_seq_url_txt);
disp('Download completed!');

% %% Read TXT file
f_id = fopen(txt_filename);
accession = fgetl(f_id);
while ischar(accession)
    if ~strcmp(accession, 'id')
        handle_accession_entry(accession, parser_settings)
    end
    accession = fgetl(f_id);
end
fclose(f_id);

disp('-------');
disp(strcat('Done! Handled n.',num2str(N),' accessions'));

function handle_accession_entry(accession, parser_settings)
disp('-------');

filepath = strcat(parser_settings.dataset_directory_name, accession, '.mat');

disp(strcat('Handling accession: ', accession));

if exist(filepath, 'file')
    disp('Ignored because file already exists');
    return;
end


%% Download from genbank
was_downloaded = 0;
try_count = 0;
while (~was_downloaded)
    try
        disp(strcat('Attempting to download accession: ', accession));
        genbank_entry = getgenbank(accession);
        was_downloaded = 1;
        disp('Download successful! Saving... ');
    catch exception
        try_count = try_count + 1;
        if try_count <= parser_settings.max_num_download_attempts
            warning('Attempt failed. Waiting and trying again...');
            pause(parser_settings.pause_time);
        else
            warning('Too many attempts failed. Giving up on this entry.');
            return;
        end
    end
    
    if was_downloaded
        handle_genbank_entry(genbank_entry, filepath, parser_settings);
    end
end


function handle_genbank_entry(genbank_entry, filepath, parser_settings)

accession = genbank_entry.LocusName;

if parser_settings.ignore_sequence_if_incomplete && ...
        isempty(strfind(genbank_entry.Definition, 'complete genome'))
    disp('Ignored because gene is not complete');
    return
end

[collection_date, locality, is_homo_sapiens] = get_features(genbank_entry.Features);


if isempty(collection_date)
    disp('Ignored because collection date missing');
    return;
end

if isempty(locality)
    disp('Ignored because locality date missing');
    return;
end

if strlength(collection_date) ~= 10
    disp(strcat('Ignored because collection date incorrectly formatted:"',collection_date,'"'));
    return;
end

collection_date = datenum(collection_date, 'yyyy-mmm-dd');

if ~is_homo_sapiens
    disp('Ignored because not homo sapiens');
    return;
end

save(filepath, 'genbank_entry', 'locality', 'collection_date', 'accession');

disp('Saved successfully!');

