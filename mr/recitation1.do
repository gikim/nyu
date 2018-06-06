*Recitation #1
*Stata
*Review - in class stata exercises & problem set

*Commands at beginning of stata do file to remove data and start fresh */

*clear data
clear all
*drop any programs 
prog drop _all
*close open log file 
capture log close
set more off

/*	Annotate your do-files */ 
* like this 
/* or like this */ 

/* 	Creating directories can help you in logging work */
* 	NOTE: Dataset for Multiple Regression is: "newschools9810.dta."

*current working directory 
cd 
cd "C:\Users\gk1512\Documents\GK\MR\Recitations"

*macro to set directory name
global datadir "C:\Users\gk1512\Documents\GK\MR\Problem Sets - Summer 2018"
global results "C:\Users\gk1512\Documents\GK\MR\Recitations"

/* 
log files allow you to save the output
i.e. ps1.smcl 

IMPORTANT NOTE: If you are using a Mac, use forward slashes instead of back 
slashes in all of the directory commands below. */

log using "$results\recitation1.smcl", replace

/* use dataset */ 
use "$datadir\newschools9810.dta", clear

*sample command 
*useful if your computer is slow and you want to run a random sample
preserve
sample 1
restore 

preserve
sample 10
restore 

use "$datadir\newschools9810.dta", clear

/* 	
Descriptives and Correlations 
*/

*Data exploration
browse
browse if year == 1998

**What is in this dataset?
des

**Are there any strange values or missing data?
sum  
sum zmath, d
sum if year==1998

correlate totreg pwhite pblack phisp pasian pfemale pimmig pfl adj_dppupil_comp psereg plep zmath middle title1_schlwide
corr zmath adj_dppupil_comp pup_tch pfemale pimmig

* to find the percentiles, use the sum command with the detail option 
sum totreg pfl, d
sum adj_dppupil_comp if totreg <= 556
sum adj_dppupil_comp if totreg >= 1028

*Basic descriptives
**What is the relationship between math scores and student teacher ratios, and other characteristics 
twoway (scatter zmath pup_tch) (lfit zmath pup_tch)

* scatterplot
twoway scatter adj_dppupil_comp pfl
graph save "$results\spending pfl.gph", asis replace

* OLS regression 
reg adj_dppupil_comp phisp

*Sampling distribution
*Original regression
reg adj_dppupil_comp phisp
di _b[phisp]

*1 percent sample
preserve
	sample 1
	reg adj_dppupil_comp phisp
restore

//100 1 percent samples --> Get average and histogram in new Stata program
forvalues x=1/100 {
	preserve
		quietly sample 1
		quietly reg adj_dppupil_comp phisp
		di _b[phisp]
	restore
}

*output regression results
*run "findit esttab" to download this user-made program
findit esttab
ssc install estout 
ssc install outreg2 
*****************************************************************************/
quietly reg adj_dppupil_comp phisp
est store m1
outreg2 using "$results\recitation1.xls", replace

quietly reg adj_dppupil_comp phisp, r
est store m2
outreg2 using "$results\recitation1.xls", append

esttab m1 m2, label
esttab m1 m2, label b(2) se(2) wide compress
esttab m1 m2 using "$recitation\recitation1.rtf", label b(2) se(2) wide compress

* To save, fill-in your initials in the command below.
	
save "$results\recitation.do", replace
log close
