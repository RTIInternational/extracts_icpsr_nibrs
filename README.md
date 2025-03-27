# icpsr_nibrs_extracts
Replicates the ICPSR NIBRS extract files

`raw_to_extract.R` processes NIBRS master data files and converts them to the ICPSR extract files.


`segment_extract.R` generates the header and admin segments that accompany the ICPSR extract files.

`utils\find_missing_values.R` Looks for variables and values that have not been encountered in previous years.

`utils\add_variable_value.R` Used to add new values to the lookup cross reference tables.


The master files and database data are available for download here:
https://crime-data-explorer.fr.cloud.gov/downloads-and-docs

The formats for each segment are specified here:
https://www.icpsr.umich.edu/web/pages/NACJD/NIBRS/varlist.html

To run (master file based process):
- Download the NIBRS master file for the year of interest
- Run the bash script `generate_raw_segments.sh` against the downloaded master file to create the individual segments:
```{bash}
./generate_raw_segments.sh <path_to_master_file/> <year/>
```
- Run the `raw_to_extract.R` script, modifying the configuration variables at the start of the script, to generate the target ICPSR file(s)

## Data Decisions
In an attempt to match the ICPSR extract files, we've mapped NIBRS cell values to ICPSR cell values within the lookup tables.

### Victim Extract

For the Victim Extract, the mappings in `data/lookup_tables/ match NIBRS to ICPSR values.

The following columns contain missing values in ICPSR that should be recoded in the NIBRS Master File:
* BH014
  * -6 (ICPSR) -> NA (Master)
* V1012
  * -6 (ICPSR) -> NA (Master)
* V4017C
  * -6 (ICPSR) -> NA (Master)
* V60071
  * -8 (ICPSR) -> NA (Master)
* V60072
  * -8 (ICPSR) -> NA (Master)
* V60073
  * -8 (ICPSR) -> NA (Master)
* V4020 (Victim Race)
  * NA (ICPSR) -> U (Master)
