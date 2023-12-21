/* Adam Finch 398 Final Project
Regression Discontinuities in the NFL Draft 

This command imports the merged data set that has been saved as a csv
If you want to reproduce the results, you will need to replace the file path 
with one from your own computer, I will include this csv in my final submission. 
I load this data set in twice, so in order for the do file to run replace the 
file path on line 10 and also on line 70 */

import delimited using "C:\Users\afinch99\Desktop\FinalDataStandardized.csv", clear

/*These commands get my data set ready to analyze, narrowing it down to 1,536 
observations. This represents all first, second, and third round picks between 
the years of 1994 - 2009  */

drop if year > 2009 
drop if rnd > 3

// Generate Summary Statistics for key variables: 

sum rnd pickoverall pos numseasons g gs pb ap1

// Generate indicator variables for whether or not an observation is past the threshold

gen R2indicator=1 if pickdec > 2 & pickdec <= 3
replace R2indicator=0 if pickdec <= 2 | pickdec > 3

gen R3indicator = 1 if pickdec > 3
replace R3indicator = 0 if pickdec <= 3

/* Encode position so that it is possible to create a dummy var for each position
to use in my control vector */

encode pos, gen(numpos)
destring tmprevwins, replace

/* Run formal regression using number of seasons played as the y variable and 
controlling for the position a player has and the year that they were drafted. 
I also install the outreg2 package to export my results in a formal table that 
can be used in my final paper */

ssc install outreg2
reg numseasons R2indicator R3indicator pickdec tmprevwins i.numpos, robust
outreg2 using regtable.doc, replace ctitle(Number Of Seasons)

/* This code generates an RD reduced form graph with number of seasons played on 
the y axis and pick number (running var) on the x axis. Structure for this code
can be found in "Causal Inference: The mixtape" in the RD chapter: */

scatter numseasons pickdec, msize(vsmall) mcolor(%50) legend(off) xline(2, lstyle(foreground)) xline(3, lstyle(foreground)) || lfit numseasons pickdec if pickdec <=2, color(red) || lfit numseasons pickdec if pickdec >2 & pickdec <=3, color(red) || lfit numseasons pickdec if pickdec>3, color(red) xtitle("Pick Number (Standardized)") ytitle("Number of Seasons Played")

/* Run similar regressions other y variables (Total Games Started and Pro Bowl
Appearances) and append results to the regression table document */

reg gs R2indicator R3indicator pickdec tmprevwins i.numpos, robust
outreg2 using regtable.doc, append ctitle(Games Started)

reg pb R2indicator R3indicator pickdec tmprevwins i.numpos, robust
outreg2 using regtable.doc, append ctitle(Pro Bowl Appearances)

// Generate RD reduced form graphs for the new y variables:

scatter gs pickdec, msize(vsmall) mcolor(%50) legend(off) xline(2, lstyle(foreground)) xline(3, lstyle(foreground)) || lfit gs pickdec if pickdec <=2, color(red) || lfit gs pickdec if pickdec >2 & pickdec <=3, color(red) || lfit gs pickdec if pickdec>3, color(red) xtitle("Pick Number (Standardized)") ytitle("Number of Games Started")

*scatter pb pickdec, msize(vsmall) mcolor(%50) legend(off) xline(2, lstyle(foreground)) xline(3, lstyle(foreground)) || lfit pb pickdec if pickdec <=2, color(red) || lfit pb pickdec if pickdec >2 & pickdec <=3, color(red) || lfit pb pickdec if pickdec>3, color(red) xtitle("Pick Number (Standardized)") ytitle("Number of Pro Bowl Appearances")


/* Finally, I wanted to test more recent and modern data. So I needed to load in
the full data set again, this time to focus on data from 2012 - 2021. Again, 
for this code to run you'll need to replace this file path with your own file path*/

import delimited using "C:\Users\afinch99\Desktop\FinalDataStandardized.csv", clear

// Follow the same data preparing process as before to get the data set ready
// to run regressions on the new focus years: 

drop if year < 2012
drop if year > 2021
drop if rnd > 3

gen R2indicator=1 if pickdec > 2 & pickdec <=3
replace R2indicator=0 if pickdec <= 2 | pickdec >3

gen R3indicator = 1 if pickdec > 3
replace R3indicator = 0 if pickdec <= 3

encode pos, gen(numpos)
destring tmprevwins, replace

// Run regression using total snap count rookie season as the outcome var:

reg tscrook R2indicator R3indicator pickdec tmprevwins i.numpos, robust

// Generate RD reduced form graph: 

*scatter tscrook pickdec, msize(vsmall) mcolor(%50) legend(off) xline(2, lstyle(foreground)) xline(3, lstyle(foreground)) || lfit tscrook pickdec if pickdec <=2, color(red) || lfit tscrook pickdec if pickdec >2 & pickdec <=3, color(red) || lfit tscrook pickdec if pickdec>3, color(red) xtitle("Pick Number (Standardized)") ytitle("Total Snap Count Rookie Season")

// That's the end of my do file!

display "Thank you Dr. Pope and Tommy for a great semester"





 



