# resources
Various artifacts from 2016 ICPSR data that we have pulled labels, lookup values, field order from. We use these to bootstrap our own conversion of the raw master files to ICPSR formatted extracts. These artifacts allow us to convert additonal years without needing to reload and re-parse the ICPSR extract files.

name_label_xref.Rda - the labels assigned to column variable names

select_list.Rda - the list of columns in the specific order they appear in the ICPSR extract files

%_labels.Rda - the labels assosicated with the particular fields.
