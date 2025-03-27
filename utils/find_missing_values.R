# This script may be used to search segments for missing values from the lookup data
# it should only be run against segments containing the raw value data prior to conversion

find_missing_values <- function(segment) {
  segment_field_names <- names(segment)
  for (field_name in segment_field_names){
    data_file <- paste("./data/lookup_tables/", field_name, "_xref.Rda", sep = "")
    if (file.exists(data_file) == T && length(na.omit(segment[[field_name]])) > 0){
      print(paste(field_name, " is missing the following values:"))
      field_xref <- readRDS(data_file)
      unique_values <- na.omit(unique(segment[[field_name]]))
      for (unique_value in unique_values){
        #print(paste("Processing:", unique_value))
        if (any(field_xref == unique_value) == F){
          print(paste("----- ", unique_value))
        }
      }
    }
  }
}

# 61A, 30A, 13C, RU, SC, NE, M values all have fewer than 12 missing records
# so we are ignoring those rather than generating unique values at this time
find_missing_values(segment_victim)
find_missing_values(segment_admin)
find_missing_values(segment_arrestee)
find_missing_values(segment_batch_header)
find_missing_values(segment_offender)
find_missing_values(segment_offense)
find_missing_values(segment_property)
