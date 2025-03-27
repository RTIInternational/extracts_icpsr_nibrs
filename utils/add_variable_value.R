#this script demonstrates how to add new lookup values to variable lookup tables
raw_value <- "90K"
new_descr <- "Failure to Appear"
new_value <- 911

for (variable in c("V6011")){
  print(variable)
  file_name <- paste("./data/lookup_tables/", variable, "_xref.Rda", sep = "")
  lookupData <- readRDS(file_name)
  
  if (any(lookupData==raw_value) == F){
    lookupData[nrow(lookupData) + 1,] = list(raw_value, new_value)
    saveRDS(lookupData, file = file_name)
  }
}

add_lookup_definition <- function(target_segment, descr, value, variable){
  tmp <- attr(target_segment[[variable]], "labels")
  if (is.null(tmp)) {
    print("No labels, no need to save a new format RDS")
  }else{
    if (is.na(tmp[descr]) == T){
      tmp <- setNames(c(tmp, value), c(names(tmp), descr))
      attr(target_segment[[variable]], "labels") <- tmp
    }
  }
  target_segment
}


victim_format <- readRDS(file = "./data/resources/icpsr_victim_format.Rda")
for (variable in c("V6011")){
    victim_format <- add_lookup_definition(victim_format, new_descr, new_value, variable = variable)
}
saveRDS(victim_format, "./data/resources/icpsr_victim_format.Rda")
#attr(victim_format[["V4010"]], "labels")

arrestee_format <- readRDS(file = "./data/resources/icpsr_arrestee_format.Rda")
incident_format <- readRDS(file = "./data/resources/icpsr_incident_format.Rda")
for (variable in c("V6011")){
  for (i in 1:3){
    new_var <- paste(variable, i, sep = "")
    #victim_format <- add_lookup_definition(victim_format, "Sports Tampering", 394, variable = new_var)
    arrestee_format <- add_lookup_definition(arrestee_format, new_descr, new_value, variable = new_var)
    incident_format <- add_lookup_definition(incident_format, new_descr, new_value, variable = new_var)
  } 
}
saveRDS(arrestee_format, "./data/resources/icpsr_arrestee_format.Rda")
saveRDS(incident_format, "./data/resources/icpsr_incident_format.Rda")
#attr(arrestee_format[["V40361"]], "labels")
