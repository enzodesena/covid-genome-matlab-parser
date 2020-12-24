# COVID-19 genome Matlab parser

This project parses and downloads all the genomic sequences of COVID-19 that were made available by research centres across the world via the website of the National Center for Biotechnology Information (NCBI): [Covid-19 page](https://www.ncbi.nlm.nih.gov/genbank/sars-cov-2-seqs/). In order to reduce stress on the NCBI database, this repo already contains the data up to the time of the latest commit. 



## Getting Started

These instructions will get you a copy of the project up and running on your  machine.

### Prerequisites

You need Matlab and the Bioinformatics Toolbox.

I only tested the code on Mac with Matlab2020a. I have no reason to believe it shouldn't run on earlier versions (albeit recent ones), but I won't provide support for any other platform.


### Installing

No need for installation. Clone/download and you are ready to go!


### Software

In order to avoid repetition of operations that are costly either in terms of computation or bandwidth, the software is divided into steps:

* **step_1_download_genbank** - This will download all the sequences into a directory `dataset` as individual `.mat` files. Re-running this script will only download files that are not present in the `dataset` directory, so you can run it again to keep your dataset up-to-date with the NCBI dataset. 
* **step_1_download_genbank_yaml_deprecated** - This will download all the sequences into a directory `dataset` as individual `.mat` files. Re-running this script will only download files that are not present in the `dataset` directory, so you can run it again to keep your dataset up-to-date with the NCBI dataset. This script uses an old YAML file that NCBI no longer makes available, so running this script will result in a 404 error. The old files associated to this YAML files are still contained in the ``dataset`` folder and are bundled together with the new ones using the ``step_3_bundle_datasets`` script. 


### Structure of dataset

For each entry in the NCBI database, the following information is available:
* **`accession`** - This is the string identifying the specific genome of this entry. 
* **`collection_date`** - This is the date of collection, in Matlab's datenum format. To convert to a readable quantity you can run `datetime(double(dataset.collection_date),'ConvertFrom','datenum');`
* **`sequence`** - This contains the genomic sequence.
* **`locality`** - This is the locality of collection (or processing? I am unsure) of the specific genome. When available, not only the country, but also the region/state is specified; in that case, the country and the region/state are separated by a comma. 
* **`latitude`** - The approximate latitude corresponding to the locality (this is only available if step 2 was run).
* **`longitude`** - The approximate longitude corresponding to the locality (this is only available if step 2 was run).

If you use step 3 to access the data, everything will be indexed accordingly. So, for instance, the genomic sequence of the first measurement is `datasets(1).genebank_entry.Sequence`.

## Contributing

Pull requests are welcome.

## Authors

* **Enzo De Sena** - [desena.org](https://www.desena.org) (enzodesena AT gmail DOT com)

The project uses:
* **Yauhen Yakimovich**'s *yamlmatlab* [Github repo](https://github.com/ewiger/yamlmatlab)
* **Joel Feenstra**'s *parse_json* [Mathworks File Exchange](https://mathworks.com/matlabcentral/fileexchange/20565-json-parser)


## License

This project is licensed under the MIT License. The data and the sofware are provided as they are without warranty of any kind (see [LICENSE.md](LICENSE.md) for details).
