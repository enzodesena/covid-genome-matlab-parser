# COVID-19 genome Matlab parser

This project parses and downloads all the genomic sequences of COVID-19 that were made available by research centres across the world via the website of the National Center for Biotechnology Information (NCBI): [Covid-19 page](https://www.ncbi.nlm.nih.gov/genbank/sars-cov-2-seqs/).



## Getting Started

These instructions will get you a copy of the project up and running on your  machine.

### Prerequisites

You need Matlab and the Bioinformatics Toolbox.

I only tested the code on Mac with Matlab2020a. I have no reason to believe it shouldn't run on earlier versions (albeit recent ones), but I won't provide support for any other platform.


### Installing

No need for installation. Clone/download and you are ready to go!


### Software

In order to avoid repetition of operations that are costly either in terms of computation or bandwidth, the software is divided into steps:

* **step_1_download_genbank** - This will download all the sequences into a directory `dataset` as individual `.mat` files. Re-running this script will only download files that are not present in the `dataset` directory, so you can run it again to keep your dataset up-to-date with the NCBI dataset. The NCBI database is currently experiencing a high volume of searches, especially for the more recent COVID-19 sequences, and running ``download_genbank`` currently takes some time (about an hour). The code has provision to wait a given amount of time between searches so as to reduce the load.
* **step_2_add_latlong_to_dataset** - This step is **optional** and is only needed if you also want to add the latitude and longitude of the locality of individual sequences to the individual datasets. This uses Google Maps API's; if you don't have it already, you'll need to create your own account with Google at [Google Maps Platform](https://cloud.google.com/maps/official).
* **step_3_bundle_datasets** - This script reads the dataset folders and returns a struct array containing all the datasets. The datasets are returned in chronological order according to the collection data.

### Structure of dataset

For each entry in the NCBI database, the following information is available:
* **`accession`** - This is the string identifying the specific genome of this entry. 
* **`collection_date`** - This is the date of collection, in Matlab's datenum format. To convert to a readable quantity you can run `datetime(double(dataset.collection_date),'ConvertFrom','datenum');`
* **`genebank_entry`** - This contains the genome bank entry returned by the NCBI database; **to access the genomic RNA sequence, you'll refer to `dataset.genebank_entry.Sequence`**.
* **`locality`** - This is the locality of collection (or processing? I am unsure) of the specific genome. When available, not only the country, but also the region/state is specified; in that case, the country and the region/state are separated by a comma. 
* **`latitude`** - The approximate latitude corresponding to the locality (this is only available if step 2 was run).
* **`longitude`** - The approximate longitude corresponding to the locality (this is only available if step 2 was run).
* **`gene_struct`** - This contains the information extracted from the YAML file.

If you use step 3 to access the data, everything will be indexed accordingly. So, for instance, the genomic sequence of the first measurement is `datasets(1).genebank_entry.Sequence`.

## Contributing

Pull requests are welcome.

## Authors

* **Enzo De Sena** - [desena.org](https://www.desena.org) (enzodesena AT gmail DOT com)

The project uses:
* **Yauhen Yakimovich**'s *yamlmatlab* [Github repo](https://github.com/ewiger/yamlmatlab)
* **Joel Feenstra**'s *parse_json* [Mathworks File Exchange](https://mathworks.com/matlabcentral/fileexchange/20565-json-parser)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
