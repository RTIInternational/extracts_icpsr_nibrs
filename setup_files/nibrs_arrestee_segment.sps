nibrs_arrestee_segment

This setup file is based on original files created using the R package asciiSetupReader(version 2.3.1) on 2020-03-17 11:01:01. This file has been modified to utilize the NIBRS ICPSR variable names based on the documentation available here: https://www.icpsr.umich.edu/web/pages/NACJD/NIBRS/varlist.html#Batch2.


data list
V601    1-2
V6002       3-4
V6003       5-13
V6004       14-25
V6005       26-33
V6006       34-35
V6007       36-47
V6008       48-55
V6009       56
V6010      57
V6011      58-60
V6012      61-63
V6013      64-66
V6014      67-68
V6015      69
V6016      70
V6017      71
V6018      72
V6019      73
.

variable labels
V6001    "segment_level"
V6002    "state"
V6003    "ori"
V6004    "incident_number"
V6005    "incident_date"
V6006    "arrestee_sequence_number"
V6007    "arrest_transaction_number"
V6008    "arrest_date"
V6009    "type_of_arrest"
V6010    "multiple_arrestee_indicator"
V6011    "ucr_arrest_offense_code"
V6012    "arrestee_weapon_1"
V6013    "arrestee_weapon_2"
V6014    "age_of_arrestee"
V6015    "sex_of_arrestee"
V6016    "race_of_arrestee"
V6017    "ethnicity_of_arrestee"
V6018    "resident_status_of_arrestee"
V6019    "disposition_of_arrestee_under_18"
.

value labels
V6002         
'50'       "Alaska"
'01'       "Alabama"
'03'       "Arkansas"
'54'       "American Samoa"
'02'       "Arizona"
'04'       "California"
'05'       "Colorado"
'06'       "Connecticut"
'52'       "Canal Zone"
'08'       "District of Columbia"
'07'       "Delaware"
'09'       "Florida"
'10'       "Georgia"
'55'       "Guam"
'51'       "Hawaii"
'14'       "Iowa"
'11'       "Idaho"
'12'       "Illinois"
'13'       "Indiana"
'15'       "Kansas"
'16'       "Kentucky"
'17'       "Louisiana"
'20'       "Massachusetts"
'19'       "Maryland"
'18'       "Maine"
'21'       "Michigan"
'22'       "Minnesota"
'24'       "Missouri"
'23'       "Mississippi"
'25'       "Montana"
'26'       "Nebraska"
'32'       "North Carolina"
'33'       "North Dakota"
'28'       "New Hampshire"
'29'       "New Jersey"
'30'       "New Mexico"
'27'       "Nevada"
'31'       "New York"
'34'       "Ohio"
'35'       "Oklahoma"
'36'       "Oregon"
'37'       "Pennsylvania"
'53'       "Puerto Rico"
'38'       "Rhode Island"
'39'       "South Carolina"
'40'       "South Dakota"
'41'       "Tennessee"
'42'       "Texas"
'43'       "Utah"
'62'       "Virgin Islands"
'45'       "Virginia"
'44'       "Vermont"
'46'       "Washington"
'48'       "Wisconsin"
'47'       "West Virginia"
'49'       "Wyoming"
V6009         
'O'        "on-view arrest (taken into custody without a warrant or previous incident report)"
'S'        "summoned/cited (not taken into custody)"
'T'        "taken into custody (based on warrant and/or previous incident report)"
V6011        
'200'      "arson"
'13A'      "aggravated assault"
'13B'      "simple assault"
'13C'      "intimidation"
'510'      "bribery"
'220'      "burglary/breaking and entering"
'250'      "counterfeiting/forgery"
'290'      "destruction/damage/vandalism of property"
'35A'      "drug/narcotic violations"
'35B'      "drug equipment violations"
'270'      "embezzlement"
'210'      "extortion/blackmail"
'26A'      "false pretenses/swindle/confidence game"
'26B'      "credit card/atm fraud"
'26C'      "impersonation"
'26D'      "welfare fraud"
'26E'      "wire fraud"
'39A'      "betting/wagering"
'39B'      "operating/promoting/assisting gambling"
'39C'      "gambling equipment violations"
'39D'      "sports tampering"
'09A'      "murder/nonnegligent manslaughter"
'09B'      "negligent manslaughter"
'09C'      "justifiable homicide"
'100'      "kidnapping/abduction"
'23A'      "pocket-picking"
'23B'      "purse-snatching"
'23C'      "shoplifting"
'23D'      "theft from building"
'23E'      "theft from coin-operated machine or device"
'23F'      "theft from motor vehicle"
'23G'      "theft of motor vehicle parts/accessories"
'23H'      "all other larceny"
'240'      "motor vehicle theft"
'370'      "pornography/obscene material"
'40A'      "prostitution"
'40B'      "assisting or promoting prostitution"
'120'      "robbery"
'11A'      "rape"
'11B'      "sodomy"
'11C'      "sexual assault with an object"
'11D'      "fondling (incident liberties/child molest)"
'36A'      "incest"
'36B'      "statutory rape"
'280'      "stolen property offenses (receiving, selling, etc.)"
'520'      "weapon law violations"
'90A'      "bad checks"
'90B'      "curfew/loitering/vagrancy violations"
'90C'      "disorderly conduct"
'90D'      "driving under the influence"
'90E'      "drunkenness"
'90F'      "family offenses, nonviolent"
'90G'      "liquor law violations"
'90H'      "peeping tom"
'90I'      "runaway"
'90J'      "trespass of real property"
'90Z'      "all other offenses"
'26F'      "identity theft"
'26G'      "hacking/computer invasion"
'40C'      "purchasing prostitution"
'64A'      "human trafficking - commercial sex acts"
'64B'      "human trafficking - involuntary servitude"
'720'      "animal cruelty"
V6012        
'01'       "unarmed"
'11'       "firearm (type not stated)"
'12'       "handgun"
'13'       "rifle"
'14'       "shotgun"
'15'       "other firearm"
'16'       "lethal cutting instrument (e.g. switchblade knife, etc.)"
'17'       "club/blackjack/brass knuckles"
V6013        
'A'        "automatic weapon"
V6014        
'01'       "unarmed"
'11'       "firearm (type not stated)"
'12'       "handgun"
'13'       "rifle"
'14'       "shotgun"
'15'       "other firearm"
'16'       "lethal cutting instrument (e.g. switchblade knife, etc.)"
'17'       "club/blackjack/brass knuckles"
V6015        
'A'        "automatic weapon"
V6016        
'00'       "unknown"
'99'       "over 98 years old"
'NN'       "under 24 hours (neonate)"
'NB'       "1-6 days old"
'BB'       "7-364 days old"
V6017        
'M'        "male"
'F'        "female"
'U'        "unknown"
V6018        
'W'        "white"
'B'        "black"
'I'        "american indian/alaskan native"
'A'        "asian/pacific islander"
'U'        "unknown"
'P'        "native hawaiian or other pacific islander"
'M'        "unknown"
V6019        
'H'        "hispanic origin"
'N'        "not of hispanic origin"
'U'        "unknown"
V6020        
'R'        "resident"
'r'        "resident"
'N'        "nonresident"
'U'        "unknown"
V21        
'H'        "handled within department (released to parents, released with warning, etc.)"
'R'        "referred to other authorities (turned over to juvenile court, probation department, welfare agency, other police agency, criminal or adult court, etc.)"
V6010        
'M'        "multiple"
'C'        "count arrestee"
'c'        "count arrestee"
'N'        "not applicable"
.



execute
