nibrs_administrative_segment

This setup file is based on original files created using the R package asciiSetupReader(version 2.3.1) on 2020-03-17 11:01:01. This file has been modified to utilize the NIBRS ICPSR variable names based on the documentation available here: https://www.icpsr.umich.edu/web/pages/NACJD/NIBRS/varlist.html#Batch2.


data list
V1001    1-2
V1002       3-4
V1003       5-13
V1004       14-25
V1005       26-33
V1006       34
V1007       35-36
V1008       37-38
V1009       39-41
V1010      42-43
V1011      44-45
V1012      46-49
V1013      50
V1014      51-58
V1016      88-89
.

variable labels
V1001    "segment_level"
V1002       "state"
V1003       "ori"
V1004       "incident_number"
V1005       "incident_date"
V1006       "report_date_indicator"
V1007       "incident_date_hour"
V1008       "total_offense_segments"
V1009       "total_victim_segments"
V1010      "total_offender_segments"
V1011      "total_arrestee_segments"
V1012      "city_submissions"
V1013      "cleared_exceptionally"
V1014      "exceptional_clearance_date"
V1016      "cargo_theft"
.

value labels
V1002        
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
V1006        
'R'       "report date"
''        "incident date"
V1007        
'00'      "on or between midnight and 00:59"
'01'      "on or between 01:00 and 01:59"
'02'      "on or between 02:00 and 02:59"
'03'      "on or between 03:00 and 03:59"
'04'      "on or between 04:00 and 04:59"
'05'      "on or between 05:00 and 05:59"
'06'      "on or between 06:00 and 06:59"
'07'      "on or between 07:00 and 07:59"
'08'      "on or between 08:00 and 08:59"
'09'      "on or between 09:00 and 09:59"
'10'      "on or between 10:00 and 10:59"
'11'      "on or between 11:00 and 11:59"
'12'      "on or between 12:00 and 12:59"
'13'      "on or between 13:00 and 13:59"
'14'      "on or between 14:00 and 14:59"
'15'      "on or between 15:00 and 15:59"
'16'      "on or between 16:00 and 16:59"
'17'      "on or between 17:00 and 17:59"
'18'      "on or between 18:00 and 18:59"
'19'      "on or between 19:00 and 19:59"
'20'      "on or between 20:00 and 20:59"
'21'      "on or between 21:00 and 21:59"
'22'      "on or between 22:00 and 22:59"
'23'      "on or between 23:00 and 23:59"
V1013       
'A'       "death of offender"
'B'       "prosecution declined (for other than lack of probable cause)"
'C'       "extradition denied"
'D'       "victim refused to cooperate"
'E'       "juvenile/no custody"
'N'       "not applicable"
.



execute
