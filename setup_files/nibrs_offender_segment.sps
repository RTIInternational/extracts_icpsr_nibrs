nibrs_offender_segment

This setup file is based on original files created using the R package asciiSetupReader(version 2.3.1) on 2020-03-17 11:01:01. This file has been modified to utilize the NIBRS ICPSR variable names based on the documentation available here: https://www.icpsr.umich.edu/web/pages/NACJD/NIBRS/varlist.html#Batch2.


data list
V5001   1-2
V5002   3-4
V5003   5-13
V5004   14-25
V5005   26-33
V5006   34-35
V5007   36-37
V5008   38
V5009   39
V5011   40
.

variable labels
V5001   "segment_level"
V5002   "state"
V5003   "ori"
V5004   "incident_number"
V5005   "incident_date"
V5006   "offender_sequence_number"
V5007   "age_of_offender"
V5008   "sex_of_offender"
V5009   "race_of_offender"
V5011   "ethnicity_of_offender"
.

value labels
V5002        
'50'      "Alaska"
'01'      "Alabama"
'03'      "Arkansas"
'54'      "American Samoa"
'02'      "Arizona"
'04'      "California"
'05'      "Colorado"
'06'      "Connecticut"
'52'      "Canal Zone"
'08'      "District of Columbia"
'07'      "Delaware"
'09'      "Florida"
'10'      "Georgia"
'55'      "Guam"
'51'      "Hawaii"
'14'      "Iowa"
'11'      "Idaho"
'12'      "Illinois"
'13'      "Indiana"
'15'      "Kansas"
'16'      "Kentucky"
'17'      "Louisiana"
'20'      "Massachusetts"
'19'      "Maryland"
'18'      "Maine"
'21'      "Michigan"
'22'      "Minnesota"
'24'      "Missouri"
'23'      "Mississippi"
'25'      "Montana"
'26'      "Nebraska"
'32'      "North Carolina"
'33'      "North Dakota"
'28'      "New Hampshire"
'29'      "New Jersey"
'30'      "New Mexico"
'27'      "Nevada"
'31'      "New York"
'34'      "Ohio"
'35'      "Oklahoma"
'36'      "Oregon"
'37'      "Pennsylvania"
'53'      "Puerto Rico"
'38'      "Rhode Island"
'39'      "South Carolina"
'40'      "South Dakota"
'41'      "Tennessee"
'42'      "Texas"
'43'      "Utah"
'62'      "Virgin Islands"
'45'      "Virginia"
'44'      "Vermont"
'46'      "Washington"
'48'      "Wisconsin"
'47'      "West Virginia"
'49'      "Wyoming"
V5006        
'00'      "unknown"
V5007        
'00'      "unknown"
'99'      "over 98 years old"
'NN'      "under 24 hours (neonate)"
'NB'      "1-6 days old"
'BB'      "7-364 days old"
V5008        
'M'       "male"
'F'       "female"
'U'       "unknown"
V5009        
'W'       "white"
'B'       "black"
'I'       "american indian/alaskan native"
'A'       "asian/pacific islander"
'U'       "unknown"
'P'       "native hawaiian or other pacific islander"
'M'       "unknown"
.



execute
