% PARSER_SETTINGS = DEFAULT_SETTINGS()
%   This function returns the default settings for the
%   covid-genome-matlab-parser.
% 
%   Author: Enzo De Sena (enzodesena AT gmail DOT com)
%   Date: 8/4/2020
%   License: MIT

function parser_settings = default_parser_settings()
parser_settings = struct;

% This is the URL of the NCBI YAML file containing all the COVID-19
% sequences.
parser_settings.ncbi_ncov_seq_url_yaml = 'https://www.ncbi.nlm.nih.gov/projects/genome/sars-cov-2-seqs/ncov-sequences.yaml';
parser_settings.ncbi_ncov_seq_url_txt = 'https://www.ncbi.nlm.nih.gov/sars-cov-2/download-nuccore-ids/';


% The maximum number of download attempts before giving up.
parser_settings.max_num_download_attempts = 30;

% Pause time (in seconds) between subsequent downloading attempts.
parser_settings.pause_time = 1;

% Use this in case you have a local YAML file containing references to the 
% genome sequences to download from the NCBI website. 
% By leaving this empty, you'll use the latest file available on the NCBI 
% file at parser_settings.ncbi_ncov_seq_url.
parser_settings.yaml_filename = []; 

% The directory where we'll save the datasets.
parser_settings.dataset_directory_name = 'dataset/'; 

% If set as true, this will ignore sequences that are not complete.
parser_settings.ignore_sequence_if_incomplete = true; 
