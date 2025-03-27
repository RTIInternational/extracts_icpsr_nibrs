library(asciiSetupReader)
library(tidyverse)
library(foreign)
library(DBI)
library(memisc)
library(haven)
library(Hmisc)
library(data.table)
library(labelled)
library(lubridate)
library(dplyr)

# ---------------------- EDIT VARIABLES FOR RUN ----------------------
# Specify the data year of the master files that will be processed.
year <- '2023'
# Specify the extract to create. This determines how the remainder of the script runs, e.g: what ICPSR file to load, segments to join, etc.
extract <- 'offender' # other expected options are: 'incident', 'arrestee', 'victim', or 'offender'
# state_filter is only used when debugging. Specify a state to subset. If commented out, the script will run for all states (take a long time)
#state_filter <- 15 #Kansas
#data_source should always be master, the database option was an attempt to generate the extracts directly from the database provided by the FBI
#a series of views were created to replicate the contents of the master files but these were no longer used once the FBI provided the stored procedures
#used to create the master files, allowing for interim extract file creation.
data_source <- "master" # database or master (FBI master file based)
db <- 'NIBRS_2021' #'NIBRS_DATA_2020_11_03'  #provide the name of your db
host_db <- '<some_database_host/>' 
db_port <- '5432'  # or any other port specified by the DBA
db_user <- 'postgres'  
db_password <- ''
if (data_source == 'database'){
  db_password = readline("Please enter the database password:")
}

setwd("~/projects/icpsr_nibrs_extracts/icpsr_nibrs_extracts/")

do_debug <- F

# ----------------------  LOAD ICPSR ----------------------
# icpsr_extract <- read_sav(file = icpsr_file_path)

# ---------------------- LOAD NIBRS MASTER SEGMENTS ----------------------

get_segment <- function(segment_name, data_year){
  # loads the parsed segment from the master file or queries the target segment table from the database
  segment <- NA
  if (data_source == "master"){
      setup_file <- switch (segment_name,
                            "victim_segment" = "./setup_files/nibrs_victim_segment.sps",
                            "offense_segment" = "./setup_files/nibrs_offense_segment.sps",
                            "batch_header_segment" = "./setup_files/nibrs_batch_header.sps",
                            "admin_segment" = "./setup_files/nibrs_administrative_segment.sps",
                            "property_segment" = "./setup_files/nibrs_property_segment.sps",
                            "offender_segment" = "./setup_files/nibrs_offender_segment.sps",
                            "arrestee_segment" = "./setup_files/nibrs_arrestee_segment.sps",
                            "arrestee_segment_window" = "./setup_files/nibrs_window_arrestee_segment.sps",
                            "arrestee_segment_groupb" = "./setup_files/nibrs_group_b_arrest_report_segment.sps"
      )
      
      segment <- asciiSetupReader::spss_ascii_reader(paste0("./data/raw_data/", data_year, "/", segment_name,".txt"),
                                                     setup_file, value_label_fix = F, real_names = F)
  }else{
    table_name <- paste("crt_", segment_name, sep = "") # additional arrestee segments aren't done yet
    query <- paste("select * from ", table_name, " where data_year = ", data_year, sep = "")
    con <- dbConnect(RPostgres::Postgres(), dbname = db, host=host_db, port=db_port, user=db_user, password=db_password)
    print(query)
    segment <- dbGetQuery(con, query)
    names(segment) <- str_to_upper(names(segment))
  }

  segment
}

# loads the named segment and sorts as-needed
segment_victim <- get_segment("victim_segment", year) %>%
  arrange(V4003, V4004, V4006) # ORI, INCNUM, SEQUENCE

segment_offense <- get_segment("offense_segment", year) #%>%

#this was used to correct 5 records in 2020 and ~ 300 in 2021 that had these offense codes but weren't coded with ICPSR numeric values
#segment_offense_keep <- segment_offense %>%  
#  filter(V2006 %in% c('58A', '58B', '61A', '61B', '620', '103', '26H', '49A', '49B', '49C', '30A', '30B', '30C', '30D', '360', '101', '521', '522', '526'))

segment_batch_header <- get_segment("batch_header_segment", year)

segment_admin <- get_segment("admin_segment", year)

segment_property <- get_segment("property_segment", year)

segment_offender <- get_segment("offender_segment", year) %>%
  arrange(V5003, V5004, V5006)

segment_arrestee <- get_segment("arrestee_segment", year) %>%
  arrange(V6003, V6004, V6006)

segment_arrestee_window <- get_segment("arrestee_segment_window", year) %>%
  arrange(V6003, V6004, V6006)

# some years of data did not have segment_arrestee_window data and segment_arrestee_window is typically
# contains very few records, when this occurs we have used an empty segment_arrestee_window file so the 
# code can run without additonal changes. The format of segment_arrestee_window is the same as segment_arrestee

#segment_arrestee_window <- segment_arrestee[FALSE, ]

segment_arrestee_groupb <- get_segment("arrestee_segment_groupb", year) %>%
  arrange(V6003, V6004, V6006)

# ---------------------- FILTER ICPSR & NIBRS MASTER SEGMENTS ----------------------
# only used for debug purposes to make the process run more quickly
if (!is.null(state_filter) && do_debug == T) {
  #icpsr_extract <- icpsr_extract %>%
    #filter(INCNUM == "2W1I0U7 628R")
    #filter(STATE == state_filter)
  
    ori <- "AR0080300"
    inc_num <- "NH-U73Z4UWEM"
    
  segment_admin <- segment_admin %>%
    #filter(V1002 == state_filter) 
    filter(V1003 %in% c(ori)) %>%
    filter(V1004 %in% c(inc_num))

  segment_arrestee <- segment_arrestee %>%
    #filter(V6002 == state_filter) #%>%
    filter(V6003 %in% c(ori))# %>%
    #filter(V6004 %in% c(inc_num))

  segment_batch_header <- segment_batch_header %>%
    #filter(BH002 == state_filter) #%>%
    filter(BH003 %in% c(ori)) # %>%
    #filter(BH004 %in% c(inc_num))

  segment_offender <- segment_offender %>%
    #filter(V5002 == state_filter) #%>%
    filter(V5003 %in% c(ori)) %>%
    filter(V5004 %in% c(inc_num))

  segment_offense <- segment_offense %>%
    #filter(V2002 == state_filter) #%>%
    filter(V2003 %in% c(ori)) %>%
    filter(V2004 %in% c(inc_num))

  segment_property <- segment_property %>%
    #filter(V3002 == state_filter) #%>%
    filter(V3003 %in% c(ori)) %>%
    filter(V3004 %in% c(inc_num))

  segment_victim <- segment_victim %>%
    #filter(V4002 == state_filter) #%>%
    filter(V4003 %in% c(ori)) %>%
    filter(V4004 %in% c(inc_num))
  
  segment_arrestee_groupb <- segment_arrestee_groupb %>%
    filter(V6004 == "2W1I0U7 628R")
  
  segment_arrestee_window <- segment_arrestee_window %>%
    filter(V6004 == "2W1I0U7 628R")
}

# ----------------------  CONVERT TO ICPSR values ----------------------
convert_to_icpsr_values <- function(segment) {
  # uses the RTI created cross reference data to map raw FBI values to the correct ICPSR numeric values
  # converts fields from segment to ICPSR values if we have a current cross reference from the raw data to ICPSR numeric values
  segment_field_names <- names(segment)
  for (field_name in segment_field_names){
    data_file <- paste("./data/lookup_tables/", field_name, "_xref.Rda", sep = "")
    if (file.exists(data_file) == T && length(na.omit(segment[[field_name]])) > 0){
      field_xref <- readRDS(data_file)
      class(segment[[field_name]]) <- class(field_xref[[field_name]])
      segment <- left_join(segment, field_xref)
      segment[[field_name]] <- segment[[paste(field_name, ".icpsr", sep = "")]]
    }
  }
  #colnames(segment) <- lapply(names(segment), str_remove, pattern = ".icpsr")
  segment %>%
    subset(select = segment_field_names) %>%
    distinct()
}

# converts raw values for each segment to ICPSR values using the convert function defined above
segment_victim <- convert_to_icpsr_values(segment_victim)
segment_offense <- convert_to_icpsr_values(segment_offense)
segment_batch_header <- convert_to_icpsr_values(segment_batch_header)
segment_admin <- convert_to_icpsr_values(segment_admin)
segment_property <- convert_to_icpsr_values(segment_property)
segment_offender <- convert_to_icpsr_values(segment_offender)
segment_arrestee <- convert_to_icpsr_values(segment_arrestee)
segment_arrestee_groupb <- convert_to_icpsr_values(segment_arrestee_groupb)
segment_arrestee_window <- convert_to_icpsr_values(segment_arrestee_window)
gc()

# this section of commented out code can be used to save time by writing the segments to disk and then 
# reloading from here for the creation of other extract files. One would write once for a specific year and then
# read in the files for subsequent runs. Note, the year is hard coded here and should be made dynamic in a future update.

#saveRDS(segment_victim, "./data/raw_data/2023/segment_victim.RDS")
#saveRDS(segment_offense, "./data/raw_data/2023/segment_offense.RDS")
#saveRDS(segment_batch_header, "./data/raw_data/2023/segment_batch_header.RDS")
#saveRDS(segment_admin, "./data/raw_data/2023/segment_admin.RDS")
#saveRDS(segment_property, "./data/raw_data/2023/segment_property.RDS")
#saveRDS(segment_offender, "./data/raw_data/2023/segment_offender.RDS")
#saveRDS(segment_arrestee, "./data/raw_data/2023/segment_arrestee.RDS")
#saveRDS(segment_arrestee_groupb, "./data/raw_data/2023/segment_arrestee_groupb.RDS")
#saveRDS(segment_arrestee_window, "./data/raw_data/2023/segment_arrestee_window.RDS")

#segment_victim <- readRDS("./data/raw_data/2023/segment_victim.RDS")
#segment_offense <- readRDS("./data/raw_data/2023/segment_offense.RDS")
#segment_batch_header <- readRDS("./data/raw_data/2023/segment_batch_header.RDS")
#segment_admin <- readRDS("./data/raw_data/2023/segment_admin.RDS")
#segment_property <- readRDS("./data/raw_data/2023/segment_property.RDS")
#segment_offender <- readRDS("./data/raw_data/2023/segment_offender.RDS")
#segment_arrestee <- readRDS("./data/raw_data/2023/segment_arrestee.RDS")
#segment_arrestee_groupb <- readRDS("./data/raw_data/2023/segment_arrestee_groupb.RDS")
#segment_arrestee_window <- readRDS("./data/raw_data/2023/segment_arrestee_window.RDS")
#gc()


# ---------------------- HANDLING Transformation that was being done by QA code, post-process -------------
segment_victim <- segment_victim %>% # recodes 10 to missing per Sean Wire Q/A investigation
  mutate(V4023 = if_else(V4023 == 10, -7, V4023))

# ----------------------  START JOINING NIBRS MASTER SEGMENTS ----------------------

segment_admin$RECSADM <- 1 # always 1 admin segment
segment_admin$RECSOFS <- segment_admin$V1008 # TOTAL OFFENSE SEGMENTS

# calculates the number of property records for the ORI, Incident
property_counts <- segment_property %>%
  dplyr::select(V3003, V3004) %>% #subset(select = c(V3003, V3004)) %>%
  group_by(V3003, V3004) %>% # ORI, incident #
  summarise(RECSPRP = n())

segment_admin <- left_join(segment_admin, property_counts, by = c("V1003" = "V3003", "V1004" = "V3004"))

segment_admin$RECSVIC <- segment_admin$V1009 # TOTAL VICTIM SEGMENTS
segment_admin$RECSOFR <- segment_admin$V1010 # TOTAL OFFENDER SEGMENTS
segment_admin$RECSARR <- segment_admin$V1011 # TOTAL ARRESTEE SEGMENTS

if (year == "2023"){ # this should go away when the FBI fixes their data issue, currently stubs out an empty dataframe so we don't have to change any code
  segment_arrestee_window <- data.frame(matrix(ncol = ncol(segment_arrestee), nrow = 0))
  names(segment_arrestee_window) <- names(segment_arrestee)
}
# The first join is conditional based on the extract
if (extract %in% c('incident', 'arrestee', 'offender')) {
  segment_admin <- segment_admin %>%
    mutate(ORI = V1003,
           INCNUM = V1004)
  
  if (extract == 'arrestee'){
    segment_arrestee$SEGMENT <- "06"
    segment_arrestee_groupb$SEGMENT <- "07"
    segment_arrestee_window <- segment_arrestee_window %>%
      mutate(SEGMENT = "W6")
    
    segment_arrestee_groupb <- segment_arrestee_groupb %>%
      dplyr::select(names(segment_arrestee))
    
    segment_arrestee_window <- segment_arrestee_window %>%
      dplyr::select(names(segment_arrestee))
    
    for (fname in names(segment_arrestee)){
      class(segment_arrestee_groupb[[fname]]) <- class(segment_arrestee[[fname]])
      class(segment_arrestee_window[[fname]]) <- class(segment_arrestee[[fname]])
    }
  }else if (extract == 'offender'){
    segment_offender <- segment_offender %>%
      mutate(SEGMENT = "05")
  }else{
    segment_admin$SEGMENT <- segment_admin$V1001
  }
  segment_admin <- segment_admin %>%
    mutate(STATE = V1002,
          INCDATE = V1005)
  # Each line will be a unique incident
  rslt <- left_join(segment_admin, segment_batch_header, by = c("ORI" = "BH003"))
} else {
  segment_victim$ORI <- segment_victim$V4003
  segment_victim$INCNUM <- segment_victim$V4004
  segment_victim$SEGMENT <- segment_victim$V4001
  segment_victim$STATE <- segment_victim$V4002
  segment_victim$INCDATE <- segment_victim$V4005
  # Each line will be a unique victim
  rslt <- left_join(segment_victim, segment_batch_header, by = c("ORI" = "BH003"))
  rslt <- left_join(rslt, segment_admin, by = c("ORI" = "V1003", "INCNUM" = "V1004"))
}

rslt <- rslt %>%
  mutate(RECSBH = 1) #1 batch header per record

# OFFENDER SEGMENT JOIN
if (extract == 'offender'){
  rslt <- inner_join(rslt, segment_offender, by = c("ORI" = "V5003", "INCNUM" = "V5004")) #, relationship='many-to-many')
}else{
  ignore_list <- c("off_count", "V5003", "V5004", "V5001", "V5002")
  candidates <- names(segment_offender)
  target_names <- candidates[!candidates %in% grep(paste0(ignore_list, collapse = "|"), candidates, value = T)]
  
  offender_wide <- segment_offender %>%
    subset(select = -c(V5001, V5002)) %>%
    group_by(V5003, V5004) %>%
    arrange(V5003, V5004, V5006) %>%
    mutate(off_count = row_number()) %>%
    filter(off_count <= 3) %>%
    pivot_wider(
      names_from = c(off_count),
      values_from = target_names,
      names_sep = ""
    ) %>%
    ungroup()
  
  rslt <- left_join(rslt, offender_wide, by = c("ORI" = "V5003", "INCNUM" = "V5004"))
  rm(offender_wide)
}

# VICTIM SEGMENT JOIN is also conditional based on the segment.
# If the intended extract is 'incident' then we want to pivot out the victim columns (e.g: Keep our extract at the incident row level)
if (extract %in% c('incident', 'arrestee', 'offender')) {
  ignore_list <- c("off_count", "V4003", "V4004", "V4001", "V4002")
  candidates <- names(segment_victim)
  target_names <- candidates[!candidates %in% grep(paste0(ignore_list, collapse = "|"), candidates, value = T)]

  victim_wide <- segment_victim %>% # broke these up due to memory issues when processing arrestee
    subset(select = -c(V4001, V4002)) %>%
    group_by(V4003, V4004)
  
  victim_wide <- victim_wide %>%
    mutate(off_count = row_number()) %>%
    filter(off_count <= 3) 
  
   victim_wide <- victim_wide %>%
    pivot_wider(
      names_from = c(off_count),
      values_from = target_names,
      names_sep = ""
    ) 
   
   victim_wide <- victim_wide %>%
    ungroup()
   
  rslt <- left_join(rslt, victim_wide, by = c("ORI" = "V4003", "INCNUM" = "V4004"))
  rm(victim_wide)
}

# OFFENSE SEGMENT JOIN
# pivoting out offense segment
ignore_list <- c("off_count", "V2003", "V2004", "V2001", "V2002")
candidates <- names(segment_offense)
target_names <- candidates[!candidates %in% grep(paste0(ignore_list, collapse = "|"), candidates, value = T)]

gc()

offense_wide <- segment_offense %>%
  subset(select = -c(V2001, V2002)) %>%
  group_by(V2003, V2004) %>%
  arrange(V2003, V2004, V2006) %>%
  mutate(off_count = row_number()) %>%
  filter(off_count <= 3) %>%
  pivot_wider(
    names_from = c(off_count),
    values_from = target_names,
    names_sep = ""
  ) %>%
  ungroup()

rslt <- left_join(rslt, offense_wide, by = c("ORI" = "V2003", "INCNUM" = "V2004"))
rm(offense_wide)


# PROPERTY SEGMENT JOIN
ignore_list <- c("off_count", "V3003", "V3004", "V3001", "V3002")
candidates <- names(segment_property)
target_names <- candidates[!candidates %in% grep(paste0(ignore_list, collapse = "|"), candidates, value = T)]

property_wide <- segment_property %>%
  subset(select = -c(V3001, V3002)) %>%
  group_by(V3003, V3004) %>% # ORI, incident number
  mutate(off_count = row_number()) %>%
  filter(off_count <= 3) %>%
  pivot_wider(
    names_from = c(off_count),
    values_from = target_names,
    names_sep = ""
  ) %>%
  ungroup()

rslt <- left_join(rslt, property_wide, by = c("ORI" = "V3003", "INCNUM" = "V3004"))
rm(property_wide)


# ARRESTEE SEGMENT JOIN
if (extract == 'arrestee'){
  rslt <- inner_join(rslt, segment_arrestee, by = c("ORI" = "V6003", "INCNUM" = "V6004"))
}else{
  ignore_list <- c("off_count", "V6003", "V6004", "V6002")
  candidates <- names(segment_arrestee)
  target_names <- candidates[!candidates %in% grep(paste0(ignore_list, collapse = "|"), candidates, value = T)]

  arrestee_wide <- segment_arrestee %>%
    subset(select = -c(V6002)) %>%
    group_by(V6003, V6004) %>%
    arrange(V6003, V6004, desc(V6007), V6006) %>%
    mutate(off_count = row_number()) %>%
    filter(off_count <= 3) %>%
    pivot_wider(
      names_from = c(off_count),
      values_from = target_names,
      names_sep = ""
    ) %>%
    ungroup()


  rslt <- left_join(rslt, arrestee_wide, by = c("ORI" = "V6003", "INCNUM" = "V6004"))
  rm(arrestee_wide)
}


all_of_ns <- segment_offense[order(segment_offense$V2006),] %>%
  group_by(V2003, V2004) %>%
  distinct(V2006) %>%
  mutate(ALLOFNS = paste(V2006, collapse= ' ')) %>%
  ungroup() %>%
  subset(select = c(V2003, V2004, ALLOFNS)) %>%
  distinct()

rslt <- left_join(rslt, all_of_ns, by = c("ORI" = "V2003", "INCNUM" = "V2004"))
rm(all_of_ns)

gc()

# ----------------------  FORMAT JOINED DATA ----------------------
# Get target columns from ICPSR extract
load(file = "./data/resources/select_list.Rda") # loads victim select list variable
load(file = "./data/resources/select_list_incident.Rda")
load(file = "./data/resources/select_list_arrestee.Rda")
load(file = "./data/resources/select_list_offender.Rda")

select_list_extract <- ""

if (extract == "victim"){
  select_list_extract <- select_list
} else if (extract == 'arrestee'){
  select_list_extract <- select_list_arrestee
} else if (extract == 'offender'){
  select_list_extract <- select_list_offender
} else {
  select_list_extract <- select_list_incident
}

rslt$INCDATE2 <- as.character(rslt$INCDATE)

#rslt <- rslt %>%
#  filter(INCNUM %in% unique(segment_offense_keep$V2004))

# Remove records with an INCDATE prior to the year being investigated, order by ORI - INCNUM to match ICPSR, and get distinct records
rslt_final <- rslt %>%
  filter(INCDATE < paste(c(as.character(as.integer(year) + 1), '0000'), collapse="")) %>%
  filter(INCDATE >= paste(c(year, '0000'), collapse="")) %>%
  dplyr::select(all_of(select_list_extract)) %>%
  arrange(ORI, INCNUM) %>%
  distinct()

rm(rslt)
gc()

# optional save point so that it can be reloaded from here if we hit a memory issue
#file_name <- "rslt_final.rds"
#file.remove(file_name)
#saveRDS(rslt_final, file_name)

if (extract == 'arrestee'){
  rslt_final <- rslt_final %>%
    filter(is.na(V6006) == F)

  rslt_final <- rslt_final %>%
    group_by(ORI, INCNUM, V6006) %>%
    arrange(ORI, INCNUM, V6006) %>%
    mutate(row_num = row_number()) %>%
    filter(row_num == 1) %>%
    ungroup()
  
  segment_arrestee_groupb <- segment_arrestee_groupb %>%
    group_by(V6003, V6004, V6006) %>%
    arrange(V6003, V6004, V6006) %>%
    mutate(row_num = row_number()) %>%
    filter(row_num == 1) %>%
    ungroup()
  
  segment_arrestee_window <- segment_arrestee_window %>%
    group_by(V6003, V6004, V6006) %>%
    arrange(V6003, V6004, V6006) %>%
    mutate(row_num = row_number()) %>%
    filter(row_num == 1) %>%
    ungroup()
  
  groupb_rslt <- segment_batch_header %>%
    inner_join(segment_arrestee_groupb, by = c("BH003" = "V6003")) %>%
    left_join(rslt_final, by = c("BH003" = "ORI", "V6004" = "INCNUM"), suffix = c("", ".gb"))
  
  groupb_rslt$SEGMENT <- "07"
  groupb_rslt$STATE <- groupb_rslt$V6002
  groupb_rslt$ORI <- groupb_rslt$BH003
  groupb_rslt$INCNUM <- groupb_rslt$V6004
  groupb_rslt$INCDATE <- groupb_rslt$V6005
  
  groupb_rslt <- groupb_rslt %>%
    dplyr::select(names(rslt_final))
  
  groupb_rslt <- groupb_rslt %>%
    group_by(ORI, INCNUM) %>%
    mutate(RECSARR = n()) %>%
    ungroup()
  
  
  rslt_final <- union_all(rslt_final, groupb_rslt)
  
  window_rslt <- rslt_final %>%
    right_join(segment_arrestee_window, by = c("ORI" = "V6003", "INCNUM" = "V6004"), suffix = c("", ".w"))

  window_rslt <- segment_batch_header %>%
    inner_join(segment_arrestee_window, by = c("BH003" = "V6003")) %>%
    left_join(rslt_final, by = c("BH003" = "ORI", "V6004" = "INCNUM"), suffix = c("", ".gb"))
  
  window_rslt <- window_rslt %>%
    mutate(SEGMENT = "W6",
          STATE = V6002,
          ORI = BH003,
          INCNUM = V6004,
          INCDATE = V6005)
  
  
  window_rslt <- window_rslt %>%
    dplyr::select(names(rslt_final))
  
  window_rslt <- window_rslt %>%
    group_by(ORI, INCNUM) %>%
    mutate(RECSARR = n()) %>%
    ungroup()

  
  rslt_final <- union_all(rslt_final, window_rslt)
  rm(groupb_rslt)
  rm(window_rslt)
}

# Additional columns that require single recodings
rslt_final$BH014[is.na(rslt_final$BH014)]  <- "-6"
rslt_final$V1012[is.na(rslt_final$V1012)]  <- "-6"


if (extract == "victim"){
  rslt_final$V4017C[is.na(rslt_final$V4017C)]  <- -6
}else{
  rslt_final$V4017C1[is.na(rslt_final$V4017C1)]  <- -6
  rslt_final$V4017C2[is.na(rslt_final$V4017C2)]  <- -6
  rslt_final$V4017C3[is.na(rslt_final$V4017C3)]  <- -6
}

rslt_final$V20201[is.na(rslt_final$V20201)]  <- 99
if (extract == 'arrestee'){
  rslt_final$V6007[is.na(rslt_final$V6007)]  <- "-8"
}else{
  rslt_final$V60071[is.na(rslt_final$V60071)]  <- "-8"
  rslt_final$V60072[is.na(rslt_final$V60072)]  <- "-8"
  rslt_final$V60073[is.na(rslt_final$V60073)]  <- "-8"
}
rslt_final$RECSPRP[is.na(rslt_final$RECSPRP)] <- 0
if (extract == 'offender'){
  rslt_final$V5007[is.na(rslt_final$V5007)] <- 0
  rslt_final$V5007[rslt_final$V5006 == 0] <- NA
  
}else{
  rslt_final$V50071[is.na(rslt_final$V50071)] <- 0
  rslt_final$V50071[rslt_final$V50061 == 0] <- NA
}
rslt_final$V1006[is.na(rslt_final$V1006)] <- 0
# need to zero pad record type and county code
if (extract != "arrestee" && extract != 'offender'){
  rslt_final$SEGMENT <- sprintf("%02d", rslt_final$SEGMENT)
}
rslt_final$BH054 <- sprintf("%03s", rslt_final$BH054)

rslt_final$BH054[rslt_final$BH054 == 'UCR']  <- 900

for (field in 42:53){
  field_name <- paste("BH0", field, sep = "")
  rslt_final[[field_name]] <- gsub('BBB', '0', rslt_final[[field_name]])
  rslt_final[[field_name]] <- gsub('NNN', '0', rslt_final[[field_name]])
  rslt_final[[field_name]] <- gsub('BBY', '1', rslt_final[[field_name]])
  rslt_final[[field_name]] <- gsub('NNY', '1', rslt_final[[field_name]])
  rslt_final[[field_name]] <- gsub('BYB', '10', rslt_final[[field_name]])
  rslt_final[[field_name]] <- gsub('NYN', '10', rslt_final[[field_name]])

  rslt_final[[field_name]] <- gsub('BYY', '11', rslt_final[[field_name]])
  rslt_final[[field_name]] <- gsub('NYY', '11', rslt_final[[field_name]])

  rslt_final[[field_name]] <- gsub('YBB', '100', rslt_final[[field_name]])
  rslt_final[[field_name]] <- gsub('YNN', '100', rslt_final[[field_name]])

  rslt_final[[field_name]] <- gsub('YBY', '101', rslt_final[[field_name]])
  rslt_final[[field_name]] <- gsub('YNY', '101', rslt_final[[field_name]])

  rslt_final[[field_name]] <- gsub('YYB', '110', rslt_final[[field_name]])
  rslt_final[[field_name]] <- gsub('YYN', '110', rslt_final[[field_name]])

  rslt_final[[field_name]] <- gsub('YYY', '111', rslt_final[[field_name]])
}

rslt_final$V30061 <- as.double(rslt_final$V30061)
rslt_final$V30062 <- as.double(rslt_final$V30062)
rslt_final$V30063 <- as.double(rslt_final$V30063)

rslt_final <- rslt_final %>%
  mutate(V30061 = if_else(V30061 == 8, -8, V30061),
         V30062 = if_else(V30062 == 8, -8, V30062),
         V30063 = if_else(V30063 == 8, -8, V30063))


if (extract == "arrestee"){
  rslt_final$V20062[is.na(rslt_final$V20062)] <- -8
  rslt_final$V20063[is.na(rslt_final$V20063)] <- -8
  rslt_final$V20072[is.na(rslt_final$V20072)] <- -8
  rslt_final$V20073[is.na(rslt_final$V20073)] <- -8
  
  for (i in 18:58){
    field <- paste("BH0", i, sep = "")
    print(field)
    # this was modified due to an error that was occuring with 2022 data, on BH042 and BH058
    # in some cases NAs were introduced by coercion with these fields
    rslt_final <- rslt_final %>%
    mutate(!!field := if_else(is.na(!!sym(field)), -6, as.numeric(!!sym(field))))
  }

  for (i in c(13,14,16)){
    field <- paste("V10", i, sep = "")
    rslt_final[[field]] <- if_else(is.na(rslt_final[[field]]) == T, -6, rslt_final[[field]] )
  }
  
  for (i in c(10,13,19)){
    field <- paste("V60", i, sep = "")
    rslt_final[[field]] <- if_else(is.na(rslt_final[[field]]) == T, -6, rslt_final[[field]] )
  }
  
  for (field in c("V20081","V20091","V20101","V20121","V20131","V20151","V20161","V30071","V30081","V30091","V30101","V30111","V30121","V30131","V30141","V30151","V30161","V30171","V30181","V30191","V30201","V30211","V30221","V30231","V40081","V40091","V40101","V40111","V40121","V40131","V40141","V40151","V40161","V4017A1","V4017B1","V40181","V40191","V40201","V40211","V40221","V40231","V40241","V40251","V40261","V40271","V40281","V40291","V40301","V40311","V40321","V40331","V40341","V40351","V40361","V40371","V40381","V40391","V40401","V40411","V40421","V40431","V40441","V40451","V40461","V40471","V40481","V40491","V40501")){
    #rslt_final[[field]] <- if_else(is.na(rslt_final[[field]]) == T, -6, rslt_final[[field]] )
    rslt_final <- rslt_final %>%
      mutate(!!field := if_else(is.na(!!sym(field)), -6, as.numeric(!!sym(field))))
  }
  for (field in c("V2020B1", "V2020B1", "V6017", "V2020D1", "V2020E1")){
    rslt_final[[field]] <- if_else(is.na(rslt_final[[field]]) == T, -7, rslt_final[[field]] )
  }
  for (field in c("V20082","V20083","V20092","V20093","V20102","V20103","V20112","V20113","V20122","V20123","V20132","V20133","V20142","V20143","V20152","V20153","V20162","V20163","V20172","V20173","V20182","V20183","V20192","V20193","V20202","V20203","V2020B2","V2020B3","V2020C2","V2020C3","V2020D2","V2020D3","V2020E2","V2020E3","V30062","V30063","V30072","V30073","V30082","V30083","V30092","V30093","V30102","V30103","V30112","V30113","V30122","V30123","V30132","V30133","V30142","V30143","V30152","V30153","V30162","V30163","V30172","V30173","V30182","V30183","V30192","V30193","V30202","V30203","V30212","V30213","V30222","V30223","V30232","V30233","V40062","V40063","V40072","V40073","V40082","V40083","V40092","V40093","V40102","V40103","V40112","V40113","V40122","V40123","V40132","V40133","V40142","V40143","V40152","V40153","V40162","V40163","V40172","V40173","V4017A2","V4017A3","V4017B2","V4017B3","V4017C2","V4017C3","V40182","V40183","V40192","V40193","V40202","V40203","V40212","V40213","V40222","V40223","V40232","V40233","V40242","V40243","V40252","V40253","V40262","V40263","V40272","V40273","V40282","V40283","V40292","V40293","V40302","V40303","V40312","V40313","V40322","V40323","V40332","V40333","V40342","V40343","V40352","V40353","V40362","V40363","V40372","V40373","V40382","V40383","V40392","V40393","V40402","V40403","V40412","V40413","V40422","V40423","V40432","V40433","V40442","V40443","V40452","V40453","V40462","V40463","V40472","V40473","V40482","V40483","V40492","V40493","V40502","V40503","V50063","V50073","V50083","V50093","V50113")){
    if (class(rslt_final[[field]]) == "character"){
      rslt_final[[field]] <- if_else(is.na(rslt_final[[field]]) == T, "-8", rslt_final[[field]] )
    }else{
      rslt_final[[field]] <- if_else(is.na(rslt_final[[field]]) == T, -8, rslt_final[[field]] )
    }
    for (field in c("V20171","V20181","V20191","V50111","V50112")){
      rslt_final[[field]] <- if_else(is.na(rslt_final[[field]]) == T, -9, rslt_final[[field]] )
    }
  }
}

# load the target format dataframe to use the labels
if (extract == "victim"){
  target_df <- readRDS(file = "./data/resources/icpsr_victim_format.Rda")
}else if (extract == "arrestee"){
  target_df <- readRDS(file = "./data/resources/icpsr_arrestee_format.Rda")
}else if (extract == 'offender'){
  target_df <- readRDS(file = "./data/resources/icpsr_offender_format.Rda")
}else{
  target_df <- readRDS(file = "./data/resources/icpsr_incident_format.Rda")
}


# handle duplicates defined by Sean as all data is the same except for V1006 values and
# we ultimately want to remove the V1006 records = 0
duplicates <- rslt_final %>%
  group_by_at(vars(-V1006)) %>%
  filter(n() > 1) %>%
  filter(V1006 == 0) %>%
  ungroup()

if (nrow(duplicates) > 0){
  rslt_final <- anti_join(rslt_final, duplicates, by = names(rslt_final))
}

rm(duplicates)

# ensures there are no duplicate records
rslt_final <- rslt_final %>%
  distinct()

# removes the row_num column that was used for debugging
if ("row_num" %in% names(rslt_final)){
  rslt_final <- rslt_final %>%
    dplyr::select(-c(row_num))
}

#R version if needed
file_name <- paste(c('./data/', year, '_', extract, '_extract_converted.rds'), collapse="")
file.remove(file_name)
saveRDS(rslt_final, file_name)

#------------run the header and admin files
# stata and sav file will be generated on concatenated data set.

# Stata / dta files don't support labels for anything but integers so we will write the 
# Stata output file before applying any labels
file_name <- paste(c('./data/', year, '_', extract, '_extract_converted.dta'), collapse="")
file.remove(file_name)
write_dta(rslt_final, file_name) 

gc()

sharedColNames <- names(target_df)#[names(target_df) %in% names(rslt_final)]
rslt_final_before <- rslt_final # saves off a before adding labels and column types in case something needs to be investigated

if (extract == 'offender'){
  data_source <- 'database'
}

# convert our dataframe to the target data types and add labels for each column
for (col_name in sharedColNames) {
  labels_class <- class(target_df[[col_name]])
  col_class <- class(rslt_final[[col_name]])
  if (data_source == "database"){
    # only doing field name labels
    label(rslt_final[[col_name]]) <- label(target_df[[col_name]])
    class(rslt_final[[col_name]]) <- class(target_df[[col_name]])
  }else{
    # This conditional fixes the case when the labels class and column class differ
    if ("double" %in% labels_class && "character" == col_class) {
      rslt_final[[col_name]] <- as.numeric(rslt_final[[col_name]])
    }
    class(rslt_final[[col_name]]) <- class(target_df[[col_name]])
    attr(rslt_final[[col_name]], "labels") = attr(target_df[[col_name]], "labels") # value labels
    label(rslt_final[[col_name]]) <- label(target_df[[col_name]]) # field name labels
  }
}

# save the data to the target format
file_name <- paste(c('./data/', year, '_', extract, '_extract_converted.sav'), collapse="")
file.remove(file_name)
write_sav(rslt_final, file_name)

# for the admin & header files, only needs to be done once.
write_sav(segment_admin, paste(c('./data/', year, '_segment_admin.sav'), collapse=""))
write_sav(segment_batch_header, paste(c('./data/', year, '_segment_batch_header.sav'), collapse=""))
