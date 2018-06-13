*recitation #2
*class #3
global data "\\apporto.com\dfs\Users\gk1512\Desktop\"
log using "$data\recitation2.smcl", replace
use "$data\newschools9810.dta", clear
*use "$data\\MR_foreclosure_data", clear

*Quadratic relationships
scatter adj_dppupil_comp totreg
gen regsq = totreg*totreg
reg adj_dppupil_comp totreg regsq

*Log transformation 
histogram adj_dppupil_comp
gen lntotexp = ln(adj_dppupil_comp)
histogram lntotexp

reg lntotexp totreg
* 1 unit increase (1 more student enrolled) leads to a .004% decrease in spending. 

*Dummy variables

*middle school 
tab middle 

*categorical variables can be represented as multiple dummy variables 
xi: reg adj_dppupil i.boro 
sum _Iboro*

*can also generate separate dummy variables
sum boro
gen manhattan = 1 if boro == 1
replace manhattan = 0 if boro != 1

*does borough have a differential effect on the impact of the percent of 
* students who are full-time special education on spending? 
sum psereg
gen man_sped = manhattan*psereg
reg adj_dppupil psereg manhattan man_sped
*interpret interaction term 

* Significance Tests
/* Note that the first command tests the joint significance of totreg and regsq 
 (using the F test). */
* Fill in the second command

test psereg manhattan
log close 

