% STEP_1_DOWNLOAD_GENBANK()
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
%   Date: 8/4/2020
%   License: MIT

function step_1_download_genbank(parser_settings)

%% Load settings
if nargin < 1
    parser_settings = default_parser_settings();
end

if ~exist(parser_settings.dataset_directory_name, 'dir')
       mkdir(parser_settings.dataset_directory_name)
end

if isempty(parser_settings.yaml_filename)
    yaml_filename = strcat(parser_settings.dataset_directory_name, ...
                           'ncov-sequences.yaml');
    
    disp('Downloading COVID-19 metadata from NCBI website');
    websave(yaml_filename, parser_settings.ncbi_ncov_seq_url);
    disp('Download completed!');
end

%% Read YAML file
addpath(genpath('yamlmatlab/trunk'))
YamlStruct = ReadYaml(yaml_filename);

N = length(YamlStruct(1).genbank0x2Dsequences);

%% Download individual sequences
for n=1:N
    gene_struct = YamlStruct(1).genbank0x2Dsequences{n};
    handle_genbank_entry(gene_struct, parser_settings)
end

disp('-------');
disp(strcat('Done! Handled n.',num2str(N),' accessions'));



function handle_genbank_entry(gene_struct, parser_settings)

disp('-------');

if ~isfield(gene_struct, 'accession')
    disp('Ignored because of a accession field missing');
end

accession = gene_struct.accession;

filepath = strcat(parser_settings.dataset_directory_name, accession, '.mat');

disp(strcat('Handling accession: ', accession));

if exist(filepath, 'file')
    disp('Ignored because file already exists');
    return;
end

if ~isfield(gene_struct, 'accession') || ... 
   ~isfield(gene_struct, 'gene0x2Dregion') || ...
   ~isfield(gene_struct, 'collection0x2Ddate') || ...
   ~isfield(gene_struct, 'locality') || ...
   ~isfield(gene_struct.locality, 'country')
    disp('Ignored because of a field missing');
    return;
end

if parser_settings.ignore_sequence_if_incomplete && ...
        (~strcmp(gene_struct.gene0x2Dregion, 'complete') || ...
        contains(accession, 'gapped'))
    disp('Ignored because gene is not complete');
    return
end

collection_date = double(gene_struct.collection0x2Ddate);

locality = gene_struct.locality.country;
if isfield(gene_struct.locality, 'state')
    locality = strcat(locality, ', ', gene_struct.locality.state);
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
        save(filepath, 'genbank_entry', 'locality', 'collection_date', ...
             'accession', 'gene_struct');
    catch
        try_count = try_count + 1;
        if try_count <= parser_settings.max_num_download_attempts
            warning('Attempt failed. Waiting and trying again...');
            pause(parser_settings.pause_time);
        else
            warning('Too many attempts failed. Giving up on this entry.');
            return;
        end
    end
end
