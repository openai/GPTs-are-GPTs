clear
est clear
cd "/Your/directory/here/" **change to the data directory here

import delimited "/Your/directory/here/data/normAutoScoresWithOAIScores.csv" **generate this file with notebook script 1

lab var dv_rating_e "GPT-4 Exposure Rating 1"
lab var dv_rating_ee "GPT-4 Exposure Rating 2"
lab var dv_rating_t "GPT-4 Automation Rating"
lab var mean_rating_human "Human Exposure Rating"
lab var pct_software "Software (Webb)" 
lab var pct_robot "Robot (Webb)" 
lab var pct_ai "AI (Webb)"
lab var msml "Suitability for Machine Learning" 
lab var normalized_r_cog "Normalized Routine Cognitive" 
lab var normalized_r_man "Normalized Routine Manual"
lab var felten_raj_seamans "AI Impact Score" 
lab var freyosborne "Frey \& Osborne Automation" 
lab var log_a_mean "Log Avg. Salary"


foreach x of varlist dv_rating_e dv_rating_ee mean_rating_human {
	* with wage controls
	eststo: reg `x' pct_software pct_robot pct_ai msml normalized_r_cog normalized_r_man felten_raj_seamans freyosborne log_a_mean, robust
	* without wage controls
	eststo: reg `x' pct_software pct_robot pct_ai msml normalized_r_cog normalized_r_man felten_raj_seamans freyosborne, robust
}

esttab using "./normAutoscores_regression.tex", replace ///
 b(5) se(5) ///
 stats(N r2) star(* 0.10 ** 0.05 *** 0.01) ///
 label booktabs noobs nonotes nomtitle collabels(none) ///
 mgroups("GPT-4 Exposure Rating 1" "GPT-4 Exposure Rating 2" "Human Exposure Rating", pattern(1 0 1 0 1 0) ///
 prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1})

est clear

foreach x of varlist pct_software pct_robot pct_ai msml normalized_r_cog normalized_r_man felten_raj_seamans freyosborne {
	eststo `x': reg dv_rating_e `x', robust
}

coefplot (pct_software \ pct_robot \ pct_ai \ msml \ normalized_r_cog \ normalized_r_man \ felten_raj_seamans \ freyosborne, label(GPT4)), drop(_cons) xline(0)

esttab using "./gpt4_normAutoscores_univariate_regression.tex", replace ///
 b(5) se(5) ///
 stats(N r2) star(* 0.10 ** 0.05 *** 0.01) ///
 label booktabs noobs nonotes nomtitle collabels(none) ///
 mgroups("Webb Software" "Webb Robot" "Webb AI" "SML" "Routine Cognitive" "Routine Manual" "AI Impact Score" "Frey \& Osborne Automation", pattern(1 1 1 1 1 1 1 1) ///
 prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1})

est clear

foreach x of varlist pct_software pct_robot pct_ai msml normalized_r_cog normalized_r_man felten_raj_seamans freyosborne {
	eststo `x': reg mean_rating_human `x', robust
}

coefplot (pct_software \ pct_robot \ pct_ai \ msml \ normalized_r_cog \ normalized_r_man \ felten_raj_seamans \ freyosborne, label(Human Rating)), drop(_cons) xline(0)

esttab using "./human_normAutoscores_univariate_regression.tex", replace ///
 b(5) se(5) ///
 stats(N r2) star(* 0.10 ** 0.05 *** 0.01) ///
 label booktabs noobs nonotes nomtitle collabels(none) ///
 mgroups("Webb Software" "Webb Robot" "Webb AI" "SML" "Routine Cognitive" "Routine Manual" "AI Impact Score" "Frey \& Osborne Automation", pattern(1 1 1 1 1 1 1 1) ///
 prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1})

est clear

foreach x of varlist pct_software pct_robot pct_ai msml normalized_r_cog normalized_r_man felten_raj_seamans freyosborne {
	eststo `x': reg dv_rating_e `x' log_a_mean, robust
}
coefplot (pct_software \ pct_robot \ pct_ai \ msml \ normalized_r_cog \ normalized_r_man \ felten_raj_seamans \ freyosborne, label(GPT4)), drop(_cons log_a_mean) xline(0)

est clear

foreach x of varlist pct_software pct_robot pct_ai msml normalized_r_cog normalized_r_man felten_raj_seamans freyosborne {
	eststo `x': reg mean_rating_human `x' log_a_mean, robust
}

coefplot (pct_software \ pct_robot \ pct_ai \ msml \ normalized_r_cog \ normalized_r_man \ felten_raj_seamans \ freyosborne, label(Human Rating)), drop(_cons log_a_mean) xline(0)

est clear

foreach x of varlist pct_software pct_robot pct_ai msml normalized_r_cog normalized_r_man felten_raj_seamans freyosborne {
	eststo human_`x': reg mean_rating_human `x' log_a_mean, robust
	eststo gpt_`x': reg dv_rating_e `x' log_a_mean, robust
}

coefplot (human_pct_software \ human_pct_robot \ human_pct_ai \ human_msml \ human_normalized_r_cog \ human_normalized_r_man \ human_felten_raj_seamans \ human_freyosborne, label(Human Rating)) ///
(gpt_pct_software \ gpt_pct_robot \ gpt_pct_ai \ gpt_msml \ gpt_normalized_r_cog \ gpt_normalized_r_man \ gpt_felten_raj_seamans \ gpt_freyosborne, label(GPT-4 Rating)), drop(_cons log_a_mean) xline(0)

est clear

foreach x of varlist pct_software pct_robot pct_ai msml normalized_r_cog normalized_r_man felten_raj_seamans freyosborne {
	eststo human_`x': reg mean_rating_human `x', robust
	eststo gpt_`x': reg dv_rating_e `x', robust
}

coefplot (human_pct_software \ human_pct_robot \ human_pct_ai \ human_msml \ human_normalized_r_cog \ human_normalized_r_man \ human_felten_raj_seamans \ human_freyosborne, label(Human Rating)) ///
(gpt_pct_software \ gpt_pct_robot \ gpt_pct_ai \ gpt_msml \ gpt_normalized_r_cog \ gpt_normalized_r_man \ gpt_felten_raj_seamans \ gpt_freyosborne, label(GPT-4 Rating)), drop(_cons) xline(0)


est clear

foreach x of varlist pct_software pct_robot pct_ai msml normalized_r_cog normalized_r_man felten_raj_seamans freyosborne {
	eststo human_`x': reg mean_rating_human `x' log_a_mean, robust
	eststo gpt_`x': reg dv_rating_e `x' log_a_mean, robust
	eststo h_`x': reg mean_rating_human `x', robust
	eststo g_`x': reg dv_rating_e `x', robust
}

coefplot (human_pct_software \ human_pct_robot \ human_pct_ai \ human_msml \ human_normalized_r_cog \ human_normalized_r_man \ human_felten_raj_seamans \ human_freyosborne, label(Human Rating w/Wage Control)) ///
(gpt_pct_software \ gpt_pct_robot \ gpt_pct_ai \ gpt_msml \ gpt_normalized_r_cog \ gpt_normalized_r_man \ gpt_felten_raj_seamans \ gpt_freyosborne, label(GPT-4 Rating w/Wage Control)) ///
(h_pct_software \ h_pct_robot \ h_pct_ai \ h_msml \ h_normalized_r_cog \ h_normalized_r_man \ h_felten_raj_seamans \ h_freyosborne, label(Human Rating)) ///
(g_pct_software \ g_pct_robot \ g_pct_ai \ g_msml \ g_normalized_r_cog \ g_normalized_r_man \ g_felten_raj_seamans \ g_freyosborne, label(GPT-4 Rating)), drop(_cons log_a_mean) xline(0)




 