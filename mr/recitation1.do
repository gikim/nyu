*Recitation #1
*Stata Review - in class stata exercises & problem set

*Annotate your do-files
*To comment in the do file, start line with asterisk (*) 
*OR start with /* and end with */
*comment
/* comment */ 

*Commands at beginning of stata do file to remove data and start fresh 
*clear data
clear all
*drop any programs created
prog drop _all
*close open log file 
capture log close

*Creating directories can help you in logging work
*Current working directory 
cd 
*CHANGE THE PATH NAME TO WHERE YOUR FILES ARE LOCATED 
*Path Name here corresponds to the nyu.apporto.edu desktop
cd "\\apporto.com\dfs\Users\gk1512\Desktop\"

*macro to set directory name
*folder where the data is stored 
global datadir "\\apporto.com\dfs\Users\gk1512\Desktop\"
global results "\\apporto.com\dfs\Users\gk1512\Desktop\"

/* 
log files allow you to save the output
file name: filename.smcl 
IMPORTANT NOTE: If you are using a Mac, use forward slashes instead of back 
slashes in all of the directory commands below. 
*/

log using "$results\recitation1.smcl", replace

*Load dataset
*NOTE: Dataset for Multiple Regression is: "newschools9810.dta."
use "$datadir\newschools9810.dta", clear

*Command: sample dataset
*useful if your computer is slow and you want to run a random sample
*1 percent sample 
preserve
sample 1
restore 
use "$datadir\newschools9810.dta", clear

*Descriptives and Correlations
*Data exploration
browse
browse if year == 1998

*What is in this dataset?
des

*Are there any strange values or missing data?
sum  
sum zmath 
sum zmath, detail 
sum if year==1998

*correlation table 
correlate totreg pwhite pblack phisp pasian pfemale pimmig pfl adj_dppupil_comp psereg plep zmath middle title1_schlwide
corr zmath adj_dppupil_comp pup_tch pfemale pimmig

* to find the percentiles, use the sum command with the detail option 
sum totreg pfl, d
sum adj_dppupil_comp if totreg <= 556
sum adj_dppupil_comp if totreg >= 1028

*Basic descriptives

*What is the relationship between math scores and student teacher ratios, and other characteristics 
twoway (scatter zmath pup_tch) (lfit zmath pup_tch)

* scatterplot
twoway scatter adj_dppupil_comp pfl
graph save "$results\spending pfl.gph", asis replace

* OLS regression 
reg adj_dppupil_comp phisp

*Sampling distribution
*Original regression
reg adj_dppupil_comp phisp pfemale pfl pblack
*display coefficient on pfl (percent free lunch) 
display _b[pfl]
di _b[pfl]
*display standard error on pfl
di _se[pfl]

*1 percent sample
preserve
	sample 1
	reg adj_dppupil_comp phisp
restore

*100 1 percent samples --> Get average and histogram in new Stata program
forvalues x=1/100 {
	preserve
		quietly sample 1
		quietly reg adj_dppupil_comp phisp
		di _b[phisp]
	restore
}

*output regression results
*run "findit esttab" to download this user-made program
*findit esttab
*ssc install estout 
*outreg2 is another package that allows you to generate regression tables 
*ssc install outreg2 
*****************************************************************************/
quietly reg adj_dppupil_comp phisp
est store m1

quietly reg adj_dppupil_comp phisp, r
est store m2

/*
options with esttab: 

esttab m1 m2, label
esttab m1 m2, label b(2) se(2) wide compress
esttab m1 m2 using "$recitation\recitation1.txt", label b(2) se(2) wide compress
*/
	
save "$results\recitation.do", replace
log close
*translate log file to pdf 
log translate "$results\recitation1.smcl" "$results\recitation1.pdf" 

*global datadir "C:\Users\gk1512\Documents\GK\MR\Problem Sets - Summer 2018"
*global results "\\C:\Users\gk1512\Documents\GK\MR\Recitations"

