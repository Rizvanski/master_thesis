*********************************** Financial Liberalization and Income Inequality **********************************
*********************************** Data Analysis *******************************************************************

***** Iniitial Data Formating *****

*** restoring Stata ***
clear all 

*** installing required packages ***
ssc install reghdfe
ssc install ftools
ssc install xtabond2
ssc install asdoc

*** setting working directory ***
cd "Y:/Master Thesis Documents Stata/Data" 

*** loading data ***
use "final_data4.dta"

*** viewing the data set ***
edit

*** generating index variable for dynamic panel analysis ***
egen country_index = group(country)
sort country_index year

*** replacing the index variable ***
replace index = country_index

*** creating log forms from existing variables ***
* GDP per capita
gen gdp_per_log = log(gdp_per)
* Total population
gen pop_log = log(pop)

*** creating lags from main independent variables ***
* financial liberalization indicator
gen fin_lib_lag = fin_lib[_n-1]
* financial development indicator (private credit/GDP)
gen fin_dev_prcrdt_lag = fin_dev_prcrdt[_n-1]
* financial development indicator (deposits/GDP)
gen fin_dev_dep_lag = fin_dev_dep[_n-1]
* global financial crisis
gen gfc_lag = gfc[_n-1]

*** manually generating interaction terms ***
* financial liberalization and financial development measured by private credit/GDP
gen fin_lib_fin_dev_prcrdt = fin_lib_lag*fin_dev_prcrdt_lag
* financial liberalization and financial development measured by bank deposits/GDP
gen fin_lib_fin_dev_dep = fin_lib_lag*fin_dev_dep_lag

* financial Liberalization and global Financial Crisis
gen fin_lib_gfc = fin_lib_lag*gfc

*** creating financial liberalization pre and post global financial crisis variables ***
* pre-financial-crisis indicator variable
gen pre_crisis = 0
replace pre_crisis = 1 if year <= 2006
* financial liberalization prior to global financial crisis independent variable
gen fin_lib_pre_gfc = fin_lib_lag*pre_crisis
* post-financial-crisis indicator variable
gen post_crisis = 0
replace post_crisis = 1 if year >= 2009
* financial liberalization after the global financial crisis independent variable
gen fin_lib_post_gfc = fin_lib_lag*post_crisis

*** adding labels ***
* Dependent Variables
label var swiid_market "SWIID Market Income Inequality"
label var swiid_mrkt_bott50 "SWIID Market Income Inequality (bottom 50%)"
label var swiid_mrkt_top10 "SWIID Market Income Inequality (top 10%)"
label var swiid_dsp "SWIID Disposable Income Inequality" 
label var swiid_dsp_bott50 "SWIID Disposable Income Inequality (bottom 50%)"
label var swiid_dsp_top10 "SWIID Disposable Income Inequality (top 10%)"
label var gini_coeff "WIID UNU-WIDER Gini Coefficients" 
label var s80s20 "Income Ration 80/20 Percentiles"
* Main Independent Variables
label var fin_lib "Fraser Institute Financial Liberalization Indicator"
label var fin_lib_lag "Lag Fraser Institute Financial Liberalization Indicator"
label var gfc "Global Financial Crisis Binary Variable"
label var gfc_lag "Lag Global Financial Crisis Binary Variable"
label var fin_dev_prcrdt "Financial Development Indicator (Private Credit/GDP)"
label var fin_dev_prcrdt_lag "Lag Financial Development Indicator (Private Credit/GDP)"
label var fin_dev_dep "Financial Development Indicator (Bank Deposits/GDP)"
label var fin_dev_dep_lag "Lag Financial Development Indicator (Bank Deposits/GDP)"
label var fin_lib_fin_dev_prcrdt "Interaction between Financial Liberalization and Financial Development 1"
label var fin_lib_fin_dev_dep "Interaction between Financial Liberalization and Financial Development 2"
label var fin_lib_gfc "Interaction between Financial Liberalization and Global Financial Crisis"
label var pre_crisis "Period Prior Global Financial Crisis (2007/2008) Binary Variable"
label var fin_lib_pre_gfc "Fraser Institutue Financial Liberalization Indicator Prior Global Financial Crisis"
label var post_crisis "Period Post Global Financial Crisis (2007/2008) Binary Variable"
label var fin_lib_post_gfc "Fraser Institute Financial Liberalization Indicator Post Global Financial Crisis"
* Control Variables
label var gdp_per "GDP Per Capita WDI"
label var gdp_per_log "Log GDP Per Capita WDI"
label var trade "Trade (% of GDP) WDI"
label var pop "Total Population WDI"
label var pop_log "Log Total Population WDI"
label var infl "Consumer Prices Inflation (annual %) WDI"
label var gdp_grth "GDP Growth (annual %) WDI"
label var agri "Agriculture, Forestry, and Fishing, Value Added (& of GDP) WDI"
label var ind "Industry (including construction), Value Added (& of GDP) WDI"
label var nat_res "Total Natural Resources Rents (& of GDP) WDI"
label var edu_exp "Adjusted Savings: Education Expenditure (% of GNI) WDI"
label var edu_prime "School Enrollment, Primary (% gross) WDI"
label var edu_sec "School Enrollment, Secondary (% gross) WDI"
label var edu_ter "School Enrollment, Tertiary (% gross) WDI"
label var life_exp "Life Expectancy at Birth, Total (years) WDI"
label var net_barter "Net Barter Terms of Trade Index (2015 = 100) WDI"
label var fdi "Foreign Direct Investments, Net Inflows (% of GDP) WDI"
label var cap_for "Gross Fixed Capital Formation (% of GDP) WDI"
label var gvt_cs "General Government Final Consumption Expenditure (% of GDP) WDI"
label var unemp "Unemployment, total (% of total labor force) (modeled ILO estimate)"
label var curcri "Laeven and Valencia Currency Crisis Binary Variable"
label var kaopen "Chinn-Ito Index Capital Openness"
label var civ_lib "Freedom House Civil Liberties Index"
label var exprty "Chief Executive Party Orientation Binary Variable DPI"
label var trade_glob "Trade Globalization Index"
label var legor_so "Socialist Law Legal Origin"
label var legor_ge "German Law Legal Origin"
* Descriptive Statistics for Structure of Financial Markets
label var bank_prcrdt "Private Credit by Deposit Money Banks to GDP (%)"
label var all_prcrdt "Private Credit by Deposit Money Banks and Other Financial Institutions to GDP (%)"
label var bank_share_prcrdt "Share of Banking Sector in Private Credit to GDP (%)"
label var bank_asgdp "Deposit Money Bank Assets to GDP (%)"
label var fin_dep "Financial System Deposits to GDP (%)"
label var bank_share_dep "Share of Banking Sector in Financial Deposits to GDP (%)"
label var net_int "Net Interest Margin (%)"
label var bank_roa "Bank ROA (returns on assets)"
label var bank_roe "Bank ROE (returns on equity)"
label var bank_con "Bank Concentration (%)"
label var ins_asset "Insurance Company Assets to GDP (%)"
label var life_ins "Life Insurance Premium Volume to GDP (%)"
label var nonlife_ins "Non-Life Insurance Premium Volume to GDP(%)"
label var stock_mrkt  "Stock Market Capitalization to GDP (%)"
label var stock_trade "Stock Market Total Value Traded to GDP (%)"
label var private_penfunds "Private Pension Funds Assets"
label var mutual_funds "Mutual Fund Assets to GDP"

***** Data Visualization *****

*** Dependent Variables ***
*** market income inequality SWIID ***
* Albania
line swiid_market year if country_index == 1, title("Albania") xtitle("Year") ytitle("Market Income Inequality") graphregion(color(white)) name(graph11)
* Bosnia and Herzegovina
line swiid_market year if country_index == 2, title("B & H") xtitle("Year") ytitle("Market Income Inequality") graphregion(color(white)) name(graph12)
* Bulgaria
line swiid_market year if country_index == 3, title("Bulgaria") xtitle("Year") ytitle("Market Income Inequality") graphregion(color(white)) name(graph13)
* Croatia
line swiid_market year if country_index == 4, title("Croatia") xtitle("Year") ytitle("Market Income Inequality") graphregion(color(white)) name(graph14)
* Montenegro
line swiid_market year if country_index == 5, title("Montenegro") xtitle("Year") ytitle("Market Income Inequality") graphregion(color(white)) name(graph15)
* North Macedonia
line swiid_market year if country_index == 6, title("N. Macedonia") xtitle("Year") ytitle("Market Income Inequality") graphregion(color(white)) name(graph16)
* Romania
line swiid_market year if country_index == 7, title("Romania") xtitle("Year") ytitle("Market Income Inequality") graphregion(color(white)) name(graph17)
* Serbia
line swiid_market year if country_index == 8, title("Serbia") xtitle("Year") ytitle("Market Income Inequality") graphregion(color(white)) name(graph18)

* combining the graphs together SWIID
graph combine graph11 graph12 graph13 graph14 graph15 graph16 graph17 graph18,rows(2) graphregion(color(white)) name(market_income) title("Graph 1: SWIID Market Income Inequality in South Eastern Europe", color(black) size(10pt) position(11))

* one graph with all countries
twoway ((line swiid_market year if country_index == 1, lcolor(blue)  xline(2007 2008) legend(label(1 "Albania" )) title("Market Income Inequality in South Eastern Europe") ytitle("Market Income Inequality") xtitle("Year")) (line swiid_market year if country_index == 2, lcolor(yellow) legend(label(2 "Bosnia and Herzegovina"))) (line swiid_market year if country_index == 3, lcolor(green) legend(label(3 "Bulgaria" ))) (line swiid_market year if country_index == 4, lcolor(purple) legend(label(4 "Croatia"))) (line swiid_market year if country_index == 5, lcolor(pink) legend(label(5 "Montenegro" ))) (line swiid_market year if country_index == 6, lcolor(black)  legend(label(6 "North Macedonia" ))) (line swiid_market year if country_index == 7, lcolor(maroon) legend(label(7 "Romania"))) (line swiid_market year if country_index == 8, lcolor(orange) legend(label(8 "Serbia" ))))

*** Gini Indices WIID - UNU WIDER ***
* Albania
line gini_coeff year if country_index == 1, title("Albania") xtitle("Year") ytitle("Gini Index") graphregion(color(white)) name(graph21)
* Bosnia and Herzegovina
line gini_coeff year if country_index == 2, title("B&H") xtitle("Year") ytitle("Gini Index") graphregion(color(white)) name(graph22)
* Bulgaria
line gini_coeff year if country_index == 3, title("Bulgaria") xtitle("Year") ytitle("Gini Index") graphregion(color(white)) name(graph23)
* Croatia
line gini_coeff year if country_index == 4, title("Croatia") xtitle("Year") ytitle("Gini Index") graphregion(color(white)) name(graph24)
* Montenegro
line gini_coeff year if country_index == 5, title("Montenegro") xtitle("Year") ytitle("Gini Index") graphregion(color(white)) name(graph25)
* North Macedonia
line gini_coeff year if country_index == 6, title("N. Macedonia") xtitle("Year") ytitle("Gini Index") graphregion(color(white)) name(graph26)
* Romania
line gini_coeff year if country_index == 7, title("Romania") xtitle("Year") ytitle("Gini Index") graphregion(color(white)) name(graph27)
* Serbia
line gini_coeff year if country_index == 8, title("Serbia") xtitle("Year") ytitle("Gini Index") graphregion(color(white)) name(graph28)

* combining the graphs together WIID - UNU WIDER
graph combine graph21 graph22 graph23 graph24 graph25 graph26 graph27 graph28, rows(2)graphregion(color(white)) name(gini_index) title("Graph 2: Income Inequality measured by Gini Coefficients", color(black) size(10pt) position(11))

* one graph with all countries

twoway ((line gini_coeff year if country_index == 1, lcolor(blue)  xline(2007 2008) legend(label(1 "Albania" )) title("Income Inequality in South Eastern Europe") ytitle("Gini Index") xtitle("Year")) (line gini_coeff year if country_index == 2, lcolor(yellow) legend(label(2 "Bosnia and Herzegovina"))) (line gini_coeff year if country_index == 3, lcolor(green) legend(label(3 "Bulgaria" ))) (line gini_coeff year if country_index == 4, lcolor(purple) legend(label(4 "Croatia"))) (line gini_coeff year if country_index == 5, lcolor(pink) legend(label(5 "Montenegro" ))) (line gini_coeff year if country_index == 6, lcolor(black)  legend(label(6 "North Macedonia" ))) (line gini_coeff year if country_index == 7, lcolor(maroon) legend(label(7 "Romania"))) (line gini_coeff year if country_index == 8, lcolor(orange) legend(label(8 "Serbia" ))))

*** Main Independent Variables ***
*** Financial Liberalization ***

* Albania
line fin_lib year if country_index == 1, title("Albania") xtitle("Year") ytitle("Financial Liberalization") graphregion(color(white)) name(graph31)
* Bosnia and Herzegovina
line fin_lib year if country_index == 2, title("B & H") xtitle("Year") ytitle("Financial Liberalization") graphregion(color(white)) name(graph32)
* Bulgaria
line fin_lib year if country_index == 3, title("Bulgaria") xtitle("Year") ytitle("Financial Liberalization") ylabel(7 8 9) graphregion(color(white)) name(graph33)
* Croatia
line fin_lib year if country_index == 4, title("Croatia") xtitle("Year") ytitle("Financial Liberalization") graphregion(color(white)) ylabel(7 8 9) name(graph34)
* Montenegro
line fin_lib year if country_index == 5, title("Montenegro") xtitle("Year") ytitle("Financial Liberalization") graphregion(color(white)) name(graph35)
* North Macedonia
line fin_lib year if country_index == 6, title("N. Macedonia") xtitle("Year") ytitle("Financial Liberalization") graphregion(color(white)) name(graph36)
* Romania
line fin_lib year if country_index == 7, title("Romania") xtitle("Year") ytitle("Financial Liberalization") graphregion(color(white)) name(graph37)
* Serbia
line fin_lib year if country_index == 8, title("Serbia") xtitle("Year") ytitle("Financial Liberalization") graphregion(color(white)) name(graph38)

* combining the graphs together Fraser Institute
graph combine graph31 graph32 graph33 graph34 graph35 graph36 graph37 graph38, rows(2) graphregion(color(white)) name(liberalization) title("Graph 3: Financial Liberalization in South Eastern Europe", color(black) size(10pt) position(11))

* one graph with all countires
twoway ((line fin_lib year if country_index == 1, lcolor(blue)  xline(2007 2008) legend(label(1 "Albania" )) title("Financial Liberalization in South Eastern Europe") ytitle("Financial Liberalization Index") xtitle("Year")) (line fin_lib year if country_index == 2, lcolor(yellow) legend(label(2 "Bosnia and Herzegovina"))) (line fin_lib year if country_index == 3, lcolor(green) legend(label(3 "Bulgaria" ))) (line fin_lib year if country_index == 4, lcolor(purple) legend(label(4 "Croatia"))) (line fin_lib year if country_index == 5, lcolor(pink) legend(label(5 "Montenegro" ))) (line fin_lib year if country_index == 6, lcolor(black)  legend(label(6 "North Macedonia" ))) (line fin_lib year if country_index == 7, lcolor(maroon) legend(label(7 "Romania"))) (line fin_lib year if country_index == 8, lcolor(orange) legend(label(8 "Serbia" ))))

*** Financial Development (Private Credit/GDP) ***
* Albania
line fin_dev_prcrdt year if country_index == 1, title("Albania") xtitle("Year") ytitle("Private Credit/GDP (%)") graphregion(color(white)) name(graph41)
* Bosnia and Herzegovina
line fin_dev_prcrdt year if country_index == 2, title("B & H") xtitle("Year") ytitle("Private Credit/GDP (%)") graphregion(color(white)) name(graph42)
* Bulgaria
line fin_dev_prcrdt year if country_index == 3, title("Bulgaria") xtitle("Year") ytitle("Private Credit/GDP (%)") graphregion(color(white)) name(graph43)
* Croatia
line fin_dev_prcrdt year if country_index == 4, title("Croatia") xtitle("Year") ytitle("Private Credit/GDP (%)") graphregion(color(white)) name(graph44)
* Montenegro
line fin_dev_prcrdt year if country_index == 5, title("Montenegro") xtitle("Year") ytitle("Private Credit/GDP (%)") graphregion(color(white)) name(graph45)
* North Macedonia
line fin_dev_prcrdt year if country_index == 6, title("N. Macedonia") xtitle("Year") ytitle("Private Credit/GDP (%)") graphregion(color(white)) name(graph46)
* Romania
line fin_dev_prcrdt year if country_index == 7, title("Romania") xtitle("Year") ytitle("Private Credit/GDP (%)") graphregion(color(white)) name(graph47)
* Serbia
line fin_dev_prcrdt year if country_index == 8, title("Serbia") xtitle("Year") ytitle("Private Credit/GDP (%)") graphregion(color(white)) name(graph48)

* combining the graphs together World Bank (Private Credit/GDP)
graph combine graph41 graph42 graph43 graph44 graph45 graph46 graph47 graph48, rows(2) graphregion(color(white)) name(financial_development1) title("Graph 4: Financial Development measured by Private Credit to GDP (%)", color(black) size(10pt) position(11))

* one graph with all countries
twoway ((line fin_dev_prcrdt year if country_index == 1, lcolor(blue)  xline(2007 2008) legend(label(1 "Albania" )) title("Financial Development in South Eastern Europe") ytitle("Private Credit/GDP (%)") xtitle("Year")) (line fin_dev_prcrdt year if country_index == 2, lcolor(yellow) legend(label(2 "Bosnia and Herzegovina"))) (line fin_dev_prcrdt year if country_index == 3, lcolor(green) legend(label(3 "Bulgaria" ))) (line fin_dev_prcrdt year if country_index == 4, lcolor(purple) legend(label(4 "Croatia"))) (line fin_dev_prcrdt year if country_index == 5, lcolor(pink) legend(label(5 "Montenegro" ))) (line fin_dev_prcrdt year if country_index == 6, lcolor(black)  legend(label(6 "North Macedonia" ))) (line fin_dev_prcrdt year if country_index == 7, lcolor(maroon) legend(label(7 "Romania"))) (line fin_dev_prcrdt year if country_index == 8, lcolor(orange) legend(label(8 "Serbia" ))))

*** Financial Development (Bank Deposits/GDP) ***
* Albania
line fin_dev_dep year if country_index == 1, title("Albania") xtitle("Year") ytitle("Bank Deposits/GDP (%)") graphregion(color(white)) name(graph51)
* Bosnia and Herzegovina
line fin_dev_dep year if country_index == 2, title("B & H") xtitle("Year") ytitle("Bank Deposits/GDP (%)") graphregion(color(white)) name(graph52)
* Bulgaria
line fin_dev_dep year if country_index == 3, title("Bulgaria") xtitle("Year") ytitle("Bank Deposits/GDP (%)") graphregion(color(white)) name(graph53)
* Croatia
line fin_dev_dep year if country_index == 4, title("Croatia") xtitle("Year") ytitle("Bank Deposits/GDP (%)") graphregion(color(white)) name(graph54)
* Montenegro
line fin_dev_dep year if country_index == 5, title("Montenegro") xtitle("Year") ytitle("Bank Deposits/GDP (%)") graphregion(color(white)) name(graph55)
* North Macedonia
line fin_dev_dep year if country_index == 6, title("N. Macedonia") xtitle("Year") ytitle("Bank Deposits/GDP (%)") graphregion(color(white)) name(graph56)
* Romania
line fin_dev_dep year if country_index == 7, title("Romania") xtitle("Year") ytitle("Bank Deposits/GDP (%)") graphregion(color(white)) name(graph57)
* Serbia
line fin_dev_dep year if country_index == 8, title("Serbia") xtitle("Year") ytitle("Bank Deposits/GDP (%)") graphregion(color(white)) name(graph58)

* combining the graphs together World Bank (Bank Deposits/GDP)
graph combine graph51 graph52 graph53 graph54 graph55 graph56 graph57 graph58, rows(2) graphregion(color(white)) name(financial_development2) title("Graph 5: Financial Development measured by Bank Deposits to GDP (%)", color(black) size(10pt) position(11))

* one graph with all countries
twoway ((line fin_dev_dep year if country_index == 1, lcolor(blue)  xline(2007 2008) legend(label(1 "Albania" )) title("Financial Development in South Eastern Europe") ytitle("Bank Deposits/GDP (%)") xtitle("Year")) (line fin_dev_dep year if country_index == 2, lcolor(yellow) legend(label(2 "Bosnia and Herzegovina"))) (line fin_dev_dep year if country_index == 3, lcolor(green) legend(label(3 "Bulgaria" ))) (line fin_dev_dep year if country_index == 4, lcolor(purple) legend(label(4 "Croatia"))) (line fin_dev_dep year if country_index == 5, lcolor(pink) legend(label(5 "Montenegro" ))) (line fin_dev_dep year if country_index == 6, lcolor(black)  legend(label(6 "North Macedonia" ))) (line fin_dev_dep year if country_index == 7, lcolor(maroon) legend(label(7 "Romania"))) (line fin_dev_dep year if country_index == 8, lcolor(orange) legend(label(8 "Serbia" ))))

*** Banking Sector Concentration (%) ***
* Albania
line bank_con year if country_index == 1, title("Albania") xtitle("Year") ytitle("Bank Concentration (%)") graphregion(color(white)) name(graph61)
* Bosnia and Herzegovina
line bank_con year if country_index == 2, title("B & H") xtitle("Year") ytitle("Bank Concentration (%)") graphregion(color(white)) name(graph62)
* Bulgaria
line bank_con year if country_index == 3, title("Bulgaria") xtitle("Year") ytitle("Bank Concentration (%)") graphregion(color(white)) name(graph63)
* Croatia
line bank_con year if country_index == 4, title("Croatia") xtitle("Year") ytitle("Bank Concentration (%)") graphregion(color(white)) name(graph64)
* Montenegro
line bank_con year if country_index == 5, title("Montenegro") xtitle("Year") ytitle("Bank Concentration (%)") graphregion(color(white)) name(graph65)
* North Macedonia
line bank_con year if country_index == 6, title("N. Macedonia") xtitle("Year") ytitle("Bank Concentration (%)") graphregion(color(white)) name(graph66)
* Romania
line bank_con year if country_index == 7, title("Romania") xtitle("Year") ytitle("Bank Concentration (%)") graphregion(color(white)) name(graph67)
* Serbia
line bank_con year if country_index == 8, title("Serbia") xtitle("Year") ytitle("Bank Concentration (%)") graphregion(color(white)) name(graph68)

* combining the graphs together Bank Concentration
graph combine graph61 graph62 graph63 graph64 graph65 graph66 graph67 graph68, rows(2) graphregion(color(white)) name(banking_concentration) title("Graph 6: Banking Sector Concentration (%)", color(black) size(10pt) position(11))

* one graph with all countries
twoway ((line bank_con year if country_index == 1, lcolor(blue)  xline(2007 2008) legend(label(1 "Albania" )) title("Banking Sector Concentration (%)") ytitle("Bank Concentration (%)") xtitle("Year")) (line bank_con year if country_index == 2, lcolor(yellow) legend(label(2 "Bosnia and Herzegovina"))) (line bank_con year if country_index == 3, lcolor(green) legend(label(3 "Bulgaria" ))) (line bank_con year if country_index == 4, lcolor(purple) legend(label(4 "Croatia"))) (line bank_con year if country_index == 5, lcolor(pink) legend(label(5 "Montenegro" ))) (line bank_con year if country_index == 6, lcolor(black)  legend(label(6 "North Macedonia" ))) (line bank_con year if country_index == 7, lcolor(maroon) legend(label(7 "Romania"))) (line bank_con year if country_index == 8, lcolor(orange) legend(label(8 "Serbia" ))))

*** Scatter Plots ***
*** Financial Liberalization and Income Inequality
* SWIID
twoway scatter swiid_market fin_lib, xtitle("Financial Liberalization Index") ytitle("Market Income Inequality") graphregion(color(white)) name(swiid_finlib)
* WIID - UNU WIDER
twoway scatter gini_coeff fin_lib, xtitle("Financial Liberalization Index") ytitle("GINI Coefficient") graphregion(color(white)) name(gini_finlib) 

*** Financial Development and Income Inequality
* SWIID
twoway scatter swiid_market fin_dev_prcrdt, xtitle("Financial Development Index") ytitle("Market Income Inequality") graphregion(color(white)) name(swiid_findev)
* WIID - UNU WIDER
twoway scatter gini_coeff fin_dev_prcrdt, xtitle("Financial Development Index") ytitle("GINI Coefficient") graphregion(color(white)) name(gini_findev)

*** Statistics Summary ***
*** variable labels ***
asdoc des, replace

*** variable overall summary statistics ***
asdoc sum swiid_market gini_coeff fin_dev fin_lib gfc gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_exp life_exp net_barter fdi cap_for gvt_cs curcri kaopen civ_lib exprty

*** variable country specific summary statistics ***
bys country: asdoc sum swiid_market gini_coeff fin_dev fin_lib gfc gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_exp life_exp net_barter fdi cap_for gvt_cs curcri kaopen civ_lib exprty

*** Table 1: Banking Sectors in South Eastern Europe ***
asdoc summarize bank_share_dep bank_share_prcrdt bank_asgdp, ///
  by(country) stat(mean) title(Table 1: Banking Sectors in South Eastern Europe (2000-2016)) ///
ftitle(2.0f) ftable(2.0f) save(Y:/Master Thesis Documents Stata/Tables/Banking Sector in South Eastern Europe.doc) replace

*** Table 2: Banking and Non-Banking Sectors Share in Financial System Assets
asdoc, row(Country, Year, Banking Sector, Non-Banking Sector) title(Table 2: Banking and Non-Banking Sectors Share in Financial System Assets) save(Y:/Master Thesis Documents Stata/Tables/Banking and Non-Banking Sectors Share in Financial System Assets.doc) replace
* Albania
asdoc, row(Albania, 2005, 75.2, 24.8) dec(1)
asdoc, row(Albania, 2010, 85.7, 14.3) dec(1)
asdoc, row(Albania, 2016, 91.3,  8.7) dec(1)
* Bosnia and Herzegovina
asdoc, row(Bosnia and Herzegovina, 2005, 77.3, 22.7) dec(1)
asdoc, row(Bosnia and Herzegovina, 2010, 84.3, 15.7) dec(1)
asdoc, row(Bosnia and Herzegovina, 2016, 87.8, 12.2) dec(1)
* Bulgaria
asdoc, row(Bulgaria, 2005, 64,  36) dec(0)
asdoc, row(Bulgaria, 2010, 92.94,  17.07) dec(2)
asdoc, row(Bulgaria, 2016, 82.93,  17.07) dec(2)
* Croatia
asdoc, row(Croatia, 2005, 80.1,  19.9) dec(1)
asdoc, row(Croatia, 2010, 77,  23) dec(0)
asdoc, row(Croatia, 2016, 70.8,  29.2) dec(1)
* Montenegro
asdoc, row(Montenegro, 2005, n.a,  n.a) dec(0)
asdoc, row(Montenegro, 2010, n.a,  n.a) dec(0)
asdoc, row(Montenegro, 2016, 92.02,  7.98) dec(2)
* North Macedonia
asdoc, row(North Macedonia, 2005, 91,  9) dec(0)
asdoc, row(North Macedonia, 2010, 89,  11) dec(0)
asdoc, row(North Macedonia, 2016, 84.75,  15.25) dec(2)
* Romania
asdoc, row(Romania, 2005, 90.9,  9.1) dec(1)
asdoc, row(Romania, 2010, 91.3,  6.3) dec(1)
asdoc, row(Romania, 2016, 93.7,  6.3) dec(1)
* Serbia
asdoc, row(Serbia, 2005, 84.76,  15.24) dec(2)
asdoc, row(Serbia, 2010, 91.7,  8.3) dec(1)
asdoc, row(Serbia, 2016, 91.1,  8.9) dec(1)

*** Table 3: Profitability of Banking Sectors in South Eastern Europe
asdoc, row(Country, Year, Net Interest Margin, Bank ROA, Bank ROE) title(Table 3: Profitability of Banking Sectors in South Eastern Europe) save(Y:/Master Thesis Documents Stata/Tables/Profitability of Banking Sector in South Eastern Europe.doc) replace
* Albania
asdoc, row(Albania, 2000, 5.289,2.1,22.51) dec(2)
asdoc, row(Albania, 2005, 4.369,1.615, 22.691,) dec(2)
asdoc, row(Albania, 2010, 4.543,1.052,9.849) dec(2)
asdoc, row(Albania, 2015, 3.389, 0.038,0.31) dec(2)
* Bosnia and Herzegovina
asdoc, row(Bosnia and Herzegovina, 2000, 6.355, 0.716,3.911) dec(2)
asdoc, row(Bosnia and Herzegovina, 2005, 4.829, 0.791,7.591) dec(2)
asdoc, row(Bosnia and Herzegovina, 2010, 4.433, -0.552, -4.867) dec(2)
asdoc, row(Bosnia and Herzegovina, 2015, 4.188, 0.15,3.786) dec(2)
* Bulgaria
asdoc, row(Bulgaria, 2000, 5.547, 3.632,18.283) dec(2)
asdoc, row(Bulgaria, 2005, 5.203, 1.865,17.828) dec(2)
asdoc, row(Bulgaria, 2010, 4.287, 0.861,6.66) dec(2)
asdoc, row(Bulgaria, 2015, 3.439, 0.559, 4.48) dec(2)
* Croatia
asdoc, row(Croatia, 2000, 4.301,1.517,12.899) dec(2)
asdoc, row(Croatia, 2005, 3.38, 1.297,14.904) dec(2)
asdoc, row(Croatia, 2010, 3.447, 0.9, 6.436) dec(2)
asdoc, row(Croatia, 2015, 2.892,-0.553,-3.46) dec(2)
* Montenegro
asdoc, row(Montenegro, 2000, n.a,  n.a, n.a) dec(0)
asdoc, row(Montenegro, 2005, 5.68,  0.353, 2.224) dec(2)
asdoc, row(Montenegro, 2010, 4.226,  -4.342, -41.22) dec(2)
asdoc, row(Montenegro, 2015, 4.338, -0.39,  -2.82) dec(2)
* North Macedonia
asdoc, row(North Macedonia, 2000, 5.601, 0.596,3.184) dec(2)
asdoc, row(North Macedonia, 2005, 5.07,1.409,8.684) dec(2)
asdoc, row(North Macedonia, 2010, 4.462, 0.982,8.246) dec(2)
asdoc, row(North Macedonia, 2015, 4.166, 1.144, 9.251) dec(2)
* Romania
asdoc, row(Romania, 2000, 8.249,  2.354,13.068) dec(2)
asdoc, row(Romania, 2005, 7.086, 1.93,16.858) dec(2)
asdoc, row(Romania, 2010, 5.273,0.708,  6.819) dec(2)
asdoc, row(Romania, 2015, 3.205,  1.311,12.625) dec(2)
* Serbia
asdoc, row(Serbia, 2000, 0.578,0.616,4.898) dec(2)
asdoc, row(Serbia, 2005, 7.534,0.591,3.112) dec(2)
asdoc, row(Serbia, 2010, 5.667,0.795,4.009) dec(2)
asdoc, row(Serbia, 2015, 4.014,0.184,0.862) dec(2)

*** Table 4: Foreign Ownership of Banking Sectors in South Eastern Europe
asdoc, row(Country, Year, Total Number of Banks,Number of Foreign Banks,Foreign Ownership of Banking Sector Assets) title(Table 4: Foreign Ownership of Banking Sectors in South Eastern Europe) save(Y:/Master Thesis Documents Stata/Tables/Foreign Ownership of Banking Sector in South Eastern Europe.doc) replace
* Albania
asdoc, row(Albania, 1998,10,8,14.4) dec(1)
asdoc, row(Albania, 2002,13,12,45.9) dec(1)
asdoc, row(Albania, 2006,17,14,90.5) dec(1)
asdoc, row(Albania, 2017, 3.389, 0.038,0.31) dec(1)
* Bosnia and Herzegovina
asdoc, row(Bosnia and Herzegovina, 1998,53,9,1.9) dec(1)
asdoc, row(Bosnia and Herzegovina, 2002,40,21,76.7) dec(1)
asdoc, row(Bosnia and Herzegovina, 2006,32,22,94) dec(1)
asdoc, row(Bosnia and Herzegovina, 2017,23,16,86) dec(1)
* Bulgaria
asdoc, row(Bulgaria, 1998,34,17,32.5) dec(1)
asdoc, row(Bulgaria, 2002,34,26,75.2) dec(1)
asdoc, row(Bulgaria, 2006,32,23,80.1) dec(1)
asdoc, row(Bulgaria, 2017,25,13,77) dec(1)
* Croatia
asdoc, row(Croatia, 1998,60,10,39.9) dec(1)
asdoc, row(Croatia, 2002,46,23,90.2) dec(1)
asdoc, row(Croatia, 2006,33,15,90.8) dec(1)
asdoc, row(Croatia, 2017,25,15,90.1) dec(1)
* Montenegro
asdoc, row(Montenegro,1998, n.a,n.a,n.a) 
asdoc, row(Montenegro, 2002,10,n.a,16.9) dec(1)
asdoc, row(Montenegro, 2006,10,8,91.9) dec(1)
asdoc, row(Montenegro, 2017,15,9,79) dec(1)
* North Macedonia
asdoc, row(North Macedonia,1998, 23,6,11.4) dec(1)
asdoc, row(North Macedonia, 2002,20,7,44) dec(1)
asdoc, row(North Macedonia, 2006,19,8,53.2) dec(1)
asdoc, row(North Macedonia, 2017,15,11,75) dec(1)
* Romania
asdoc, row(Romania, 1998,36,16,51.3) dec(1)
asdoc, row(Romania, 2002,31,24,52.9) dec(1)
asdoc, row(Romania, 2006,31,26,87.9) dec(1)
asdoc, row(Romania, 2017,23,16,77) dec(1)
* Serbia
asdoc, row(Serbia, 1998,104,3,0.5) dec(1)
asdoc, row(Serbia, 2002,50,12,27) dec(1)
asdoc, row(Serbia, 2006,37,22,78.7) dec(1)
asdoc, row(Serbia, 2017,29,21,76) dec(1)

*** Table 5: Insurance Sectors in South Eastern Europe
* naming the variables
asdoc summarize ins_asset life_ins nonlife_ins, ///
  by(country) stat(mean) title(Table 5: Insurance Sectors in South Eastern Europe (2000-2016)) ///
ftitle(2.0f) ftable(2.0f) save(Y:/Master Thesis Documents Stata/Tables/Insurance Sector in South Eastern Europe.doc) label abb(.) replace

*** Table 6: Stock Markets Development in South Eastern Europe
asdoc, row(Country, Year, Stock Market Capitalization to GDP, Stock Market Total Value Traded to GDP) title(Table6: Stock Markets Developments in South Eastern Europe) save(Y:/Master Thesis Documents Stata/Tables/Stock Market Developments in South Eastern Europe.doc) replace
* Albania
asdoc, row(Albania, 2000,n.a,n.a) 
asdoc, row(Albania, 2004,n.a,n.a)
asdoc, row(Albania, 2007/08,n.a,n.a) 
asdoc, row(Albania, 2011, n.a,n.a)
* Bosnia and Herzegovina
asdoc, row(Bosnia and Herzegovina, 2000,n.a, n.a) 
asdoc, row(Bosnia and Herzegovina, 2005,14.533, n.a) dec(3)
asdoc, row(Bosnia and Herzegovina, 2007/08,29.891, n.a) dec(3)
asdoc, row(Bosnia and Herzegovina, 2011, 13.542, n.a) dec(3)
* Bulgaria
asdoc, row(Bulgaria, 2000, 0.821,0.034) dec(3)
asdoc, row(Bulgaria, 2004,9.075,1.114) dec(3)
asdoc, row(Bulgaria, 2007/08,33.465,8.892) dec(3)
asdoc, row(Bulgaria, 2011, 14.023,0.630) dec(3)
* Croatia
asdoc, row(Croatia, 2000, 11.315,0.567) dec(3)
asdoc, row(Croatia, 2004,21.335,0.887) dec(3)
asdoc, row(Croatia, 2007/08,79.102,5.508) dec(3)
asdoc, row(Croatia, 2011, 39.483,1.620) dec(3)
* Montenegro
asdoc, row(Montenegro, 2000, n.a,n.a) dec(0)
asdoc, row(Montenegro, 2004,n.a,n.a) dec(0)
asdoc, row(Montenegro, 2007/08,74.9005,7.284) dec(3)
asdoc, row(Montenegro, 2011,76.772,1.367) dec(3)
* North Macedonia
asdoc, row(North Macedonia, 2000, 0.182,1.860) dec(3)
asdoc, row(North Macedonia, 2004,7.14,0.398) dec(2)
asdoc, row(North Macedonia, 2007/08,21.206,3.917) dec(3)
asdoc, row(North Macedonia, 2011,6.1,0.427) dec(1)
* Romania
asdoc, row(Romania, 2000, 0.784,0.182) dec(3)
asdoc, row(Romania, 2004,9.435,0.686) dec(3)
asdoc, row(Romania, 2007/08,13.8085,1.121) dec(3)
asdoc, row(Romania, 2011,7.921,1.280) dec(3)
* Serbia
asdoc, row(Serbia, 2000, n.a,0.161) dec(0)
asdoc, row(Serbia, 2004,9.193,2.016) dec(3)
asdoc, row(Serbia, 2007/08,53.452,5.360) dec(3)
asdoc, row(Serbia, 2011,9.34,0.786) dec(2)

*** Table 7: Private Investment Funds in South Eastern Europe (2000-2016)
asdoc summarize private_penfunds mutual_funds, ///
  by(country) stat(mean) title(Table 7: Private Investment Funds in South Eastern Europe (2000-2016)) ///
ftitle(2.0f) ftable(2.0f) save(Y:/Master Thesis Documents Stata/Tables/Private Investment Funds in South Eastern Europe.doc) label abb(.) replace

*** Table 8: Banking Sectors in Different Regions in the World 
* clearing all elements
clear all

* loading the data for descriptive statistics on different regions in the world
use "final_data_world.dta"

* comparison table
asdoc summarize bank_share_dep bank_share_prcrdt bank_asgdp, ///
  by(country) stat(mean) title(Table 8: Banking Sectors in Different Parts of the World (2000-2016)) ///
ftitle(2.0f) ftable(2.0f) save(Y:/Master Thesis Documents Stata/Tables/Banking Sectors in the World.doc) replace

*** Table 9: Profitability of Banking Sectors in Different Regions in the World
* comparison table
asdoc summarize net_int bank_roa bank_roe, ///
  by(country) stat(mean) title(Table9: Profitability of Banking Sectors in Different Parts of the World (2000-2016)) ///
ftitle(2.0f) ftable(2.0f) save(Y:/Master Thesis Documents Stata/Tables/Profitability of Banking Sectors in Different Parts of the World.doc) replace

*** Table 10: Insurance Sectors in Different Regions in the World
* comparison table
asdoc summarize ins_asset life_ins nonlife_ins, ///
  by(country) stat(mean) title(Table 10: Insurance Sectors in Different Regions of the World (2000-2016)) ///
ftitle(2.0f) ftable(2.0f) save(Y:/Master Thesis Documents Stata/Tables/Insurance Sectors in Different Regions of the World.doc) label abb(.) replace

*** Table 11: Stock Markets in Different Regions in the World
* comparison table
asdoc summarize stock_mrkt stock_trade, ///ki
  by(country) stat(mean) title(Table 11: Stock Markets in Different Regions of the World (2000-2016)) ///
ftitle(2.0f) ftable(2.0f) save(Y:/Master Thesis Documents Stata/Tables/Stock Markets in Different Regions of the World.doc) label abb(.) replace

*** Table 12: Private Investment Funds in Different Regions in the World
* comparison table
asdoc summarize private_penfunds mutual_funds, ///
  by(country) stat(mean) title(Table 12: Private Investment Funds in Different Regions of the World (2000-2016)) ///
ftitle(2.0f) ftable(2.0f) save(Y:/Master Thesis Documents Stata/Tables/Private Investment Funds in Different Regions of the World.doc) label abb(.) replace


***** Regression Analysis *****
***** Panel Data Analysis *****

* setting the panel variables
xtset index year
* summary
xtdescribe
* standard deviation between countries and within countries
xtsum $index $year $ylist $xlist $clist

* defining global variables
global index index
global year year
global ylist gini_coeff
global xlist fin_lib_lag
global xlist1 fin_dev_prcrdt_lag
global xlist2 gfc_lag
global xlist3 fin_lib_lag fin_dev_prcrdt_lag gfc_lag
global xlist4 fin_lib_lag fin_dev_prcrdt_lag gfc_lag fin_lib_fin_dev_prcrdt 
global xlist5 fin_lib_lag fin_dev_prcrdt_lag gfc_lag fin_lib_gfc
global xlist6 fin_lib_lag fin_dev_prcrdt_lag gfc_lag fin_lib_fin_dev_prcrdt fin_lib_gfc
global xlist7 fin_lib_lag fin_dev_prcrdt_lag gfc_lag pre_crisis fin_lib_pre_gfc
global xlist8 fin_lib_lag fin_dev_prcrdt_lag gfc_lag pre_crisis fin_lib_gfc fin_lib_pre_gfc
global xlist9 fin_lib_lag fin_dev_prcrdt_lag gfc_lag post_crisis fin_lib_post_gfc
global xlist10 fin_lib_lag fin_dev_prcrdt_lag gfc_lag post_crisis fin_lib_gfc fin_lib_post_gfc
global xlist11 fin_lib_lag fin_dev_prcrdt_lag gfc_lag pre_crisis post_crisis fin_lib_pre_gfc fin_lib_post_gfc
global xlist12 fin_lib_lag fin_dev_prcrdt_lag gfc_lag pre_crisis post_crisis fin_lib_fin_dev_prcrdt fin_lib_pre_gfc fin_lib_post_gfc
global clist gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_bartert

*** Hausman Test 1*** (p-value = 0 - null hypothesis rejected - fixed effects model used)
* fixed effects
xtreg $ylist $xlist5 $clist, fe
estimates store fixed
* random effects
xtreg $ylist $xlist5 $clist, re theta
estimates store random
* running the test
hausman fixed random

*** Regressions Without Interaction Terms ***
*** 1) Relationship Between Financial Liberalization, Financial Development, Great Financial Crisis and Income Inequality ***
* Financial Liberalization
asdoc xtreg $ylist $xlist $clist, fe vce(cluster country) replace nest title(Regression Table 1) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 1.doc) add(Controls, YES)
* Financial Development 
asdoc xtreg $ylist $xlist1 $clist, fe vce(cluster country) append nest title(Regression Table 1) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) add(Controls, YES)
* Global Financial Crisis
asdoc xtreg $ylist $xlist2 $clist, fe vce(cluster country) nest append nest title(Regression Table 1) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) add(Controls, YES)
* Together
asdoc xtreg $ylist $xlist3 $clist, fe vce(cluster country) nest append nest title(Regression Table 1) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) add(Controls, YES)
*** Regressions With Interaction Terms ***
*** 2) Testing Whether the Impact of Financial Liberalization Depends on Financial Development ***
asdoc xtreg $ylist $xlist4 $clist, fe vce(cluster country) nest append nest title(Regression Table 1) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) add(Controls, YES)
*** 3) Testing Whether Financial Liberalization Is Correlated with Global Financial Crisis
asdoc xtreg $ylist $xlist5 $clist, fe vce(cluster country) nest append nest title(Regression Table 1) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) add(Controls, YES)
*** 4) Testing Whether Financial Liberalization Depends on Financial Development and Whether Financial Liberalization is Correlated with Global Financial Crisis
asdoc xtreg $ylist $xlist6 $clist, fe vce(cluster country) nest append nest title(Regression Table 1) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) add(Controls, YES)

*** Hausman Test 2 *** (p-value is 0 - null rejected - fixed effects used)
* fixed effects
xtreg $ylist $xlist6 $clist, fe
estimates store fixed
* random effects
xtreg $ylist $xlist6 $clist, re theta
estimates store random
* running the test
hausman fixed random

*** 5) Testing Whether Financial Liberalization is Correlated to Global Financial Crisis ***
*** Regressions Without Interaction Terms ***
* Financial Liberalization, Financial Development and Global Financial Crisis
asdoc xtreg $ylist $xlist3 $clist, fe vce(cluster country) replace nest title(Regression Table 2) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 2.doc) add(Controls, YES)
*** Regressions With Interaction Terms ***
* Testing Whether Financial Liberalization is Correlated With Global Financial Crisis
asdoc xtreg $ylist $xlist5 $clist, fe vce(cluster country) append nest title(Regression Table 2) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 2.doc) add(Controls, YES)
*** 6) Testing Whether Financial Liberalization has an Effect on Income Inequality Prior Global Financial Crisis ***
* Only Prior Global Financial Crisis
asdoc xtreg $ylist $xlist7 $clist, fe vce(cluster country) append nest title(Regression Table 2) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 2.doc) add(Controls, YES)
* Together With Interaction Term Between Financial Liberalization and Global Financial Crisis
asdoc xtreg $ylist $xlist8 $clist, fe vce(cluster country) append nest title(Regression Table 2) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 2.doc) add(Controls, YES)
*** 7) Testing Whether Financial Liberalization has an Effect on Income Inequality Post Global Financial Crisis ***
* Only Post Global Financial Crisis
asdoc xtreg $ylist $xlist9 $clist, fe vce(cluster country) append nest title(Regression Table 2) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 2.doc) add(Controls, YES)
* Together With Interaction Term Between Financial Liberalization and Global Financial Crisis
asdoc xtreg $ylist $xlist10 $clist, fe vce(cluster country) append nest title(Regression Table 2) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 2.doc) add(Controls, YES)
*** 8) Testing Whether Financial Liberalization has an Effect on Income Inequality Prior and After the Global Financial Crisis ***
asdoc xtreg $ylist $xlist11 $clist, fe vce(cluster country) append nest title(Regression Table 2) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 2.doc) add(Controls, YES)
*** 9) Testing Both Hypothesis Together ***
asdoc xtreg $ylist $xlist12 $clist, fe vce(cluster country) append nest title(Regression Table 2) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 2.doc) add(Controls, YES)

*** Robustness Checks ***
*** Tests using Robust Standard Errors ***
*** Testing Whether Financial Liberalization is Dependent on Financial Development and Whether Financial Liberalization is Correlated with the Global Financial Crisis ***
* Using Robust Standard Errors
asdoc xtreg $ylist $xlist6 $clist, fe vce(robust) replace nest title(Regression Table 3) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 3.doc) add(Controls, YES)
*** Testing Whether Financial Liberalization Behaves Differenty Prior Global Financial Crisis ***
* Using Robust Standard Errors
* Only Prior Global Financial Crisis
asdoc xtreg $ylist $xlist7 $clist, fe vce(robust) append nest title(Regression Table 3) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 3.doc) add(Controls, YES)
* Together With Interaction Term Between Financial Liberalization and Global Financial Crisis
asdoc xtreg $ylist $xlist8 $clist, fe vce(robust) append nest title(Regression Table 3) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 3.doc) add(Controls, YES)
*** Testing Whether Financial Liberalization's Impact Behaves Differenty Post Global Financial Crisis ***
* Using Robust Standard Errors
* Only Post Global Financial Crisis
asdoc xtreg $ylist $xlist9 $clist, fe vce(robust) append nest title(Regression Table 3) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 3.doc) add(Controls, YES)
* Together With Interaction Term Between Financial Liberalization and Global Financial Crisis
asdoc xtreg $ylist $xlist10 $clist, fe vce(robust) append nest title(Regression Table 3) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 3.doc) add(Controls, YES)
* Together Prior and Post
asdoc xtreg $ylist $xlist11 $clist, fe vce(robust) append nest title(Regression Table 3) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 3.doc) add(Controls, YES)
*** Testing Both Hypothesis Together ***
asdoc xtreg $ylist $xlist12 $clist, fe vce(robust) append nest title(Regression Table 3) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 3.doc) add(Controls, YES)

*** Tests Using First-Diff Method ***
*** Testing Whether Financial Liberalization is Dependent on Financial Development and Whether Financial Liberalization is Correlated with the Global Financial Crisis ***
reg D.($ylist $xlist6 $clist), vce(cluster country) noconstant 
*** Testing Whether Financial Liberalization's Impact Behaves Differenty Prior Global Financial Crisis ***
* Only Prior Global Financial Crisis
reg D.($ylist $xlist7 $clist), vce(cluster country) noconstant 
* Together With Interaction Term Between Financial Liberalization and Global Financial Crisis
reg D.($ylist $xlist8 $clist), vce(cluster country) noconstant
*** Testing Whether Financial Liberalization's Impact Behaves Differenty Post Global Financial Crisis ***
* Only Post Global Financial Crisis
reg D.($ylist $xlist9 $clist), vce(cluster country) noconstant 
* Together With Interaction Term Between Financial Liberalization and Global Financial Crisis
reg D.($ylist $xlist10 $clist), vce(cluster country) noconstant 
* Together Prior and Post
reg D.($ylist $xlist11 $clist), vce(cluster country) noconstant
*** Testing Both Hypothesis Together ***
reg D.($ylist $xlist12 $clist), vce(cluster country) noconstant

*** Tests Using Slovenia in the Sample ***
*** Including all Former Republics of Yugoslavia ***

*** Testing Whether Financial Liberalization is Dependent on Financial Development and Whether Financial Liberalization is Correlated with the Global Financial Crisis ***
asdoc xtreg $ylist $xlist6 $clist, fe vce(cluster country) replace nest title(Regression Table 5) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 5.doc) add(Controls, YES)
*** Testing Whether Financial Liberalization Behaves Differenty Prior Global Financial Crisis ***
* Only Prior Global Financial Crisis
asdoc xtreg $ylist $xlist7 $clist, fe vce(cluster country) append nest title(Regression Table 5) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 5.doc) add(Controls, YES)
* Together With Interaction Term Between Financial Liberalization and Global Financial Crisis
asdoc xtreg $ylist $xlist8 $clist, fe vce(cluster country) append nest title(Regression Table 5) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 5.doc) add(Controls, YES)
*** Testing Whether Financial Liberalization's Impact Behaves Differenty Post Global Financial Crisis ***
* Only Post Global Financial Crisis
asdoc xtreg $ylist $xlist9 $clist, fe vce(cluster country) append nest title(Regression Table 5) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 5.doc) add(Controls, YES)
* Together With Interaction Term Between Financial Liberalization and Global Financial Crisis
asdoc xtreg $ylist $xlist10 $clist, fe vce(cluster country) append nest title(Regression Table 5) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 5.doc) add(Controls, YES)
* Together Prior and Post
asdoc xtreg $ylist $xlist11 $clist, fe vce(cluster country) append nest title(Regression Table 5) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 5.doc) add(Controls, YES)
*** Testing Both Hypothesis Together ***
asdoc xtreg $ylist $xlist12 $clist, fe vce(cluster country) append nest title(Regression Table 5) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 5.doc) add(Controls, YES)

*** Tests Using Different Measurement for Financial Development ***
*** Testing Whether Financial Liberalization is Dependent on Financial Development and Whether Financial Liberalization is Correlated with the Global Financial Crisis ***
* defining new global variables
global xlist13 fin_dev_dep_lag
global xlist14 fin_lib_lag fin_dev_dep_lag gfc_lag
global xlist15 fin_lib_lag fin_dev_dep_lag gfc_lag fin_lib_fin_dev_dep
global xlist16 fin_lib_lag fin_dev_dep_lag gfc_lag fin_lib_fin_dev_dep fin_lib_gfc
global xlist17 fin_lib_lag fin_dev_dep_lag gfc_lag pre_crisis post_crisis fin_lib_fin_dev_dep fin_lib_pre_gfc fin_lib_post_gfc
* relationship between financial development and income inequality
asdoc xtreg $ylist $xlist13 $clist, fe vce(cluster country) replace nest title(Regression Table 6) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 6.doc) add(Controls, YES)
* all variables together without interaction terms
asdoc xtreg $ylist $xlist14 $clist, fe vce(cluster country) append nest title(Regression Table 6) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 6.doc) add(Controls, YES)
* interaction term between financial liberalization and financial development
asdoc xtreg $ylist $xlist15 $clist, fe vce(cluster country) append nest title(Regression Table 6) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 6.doc) add(Controls, YES)
* both interaction terms included
asdoc xtreg $ylist $xlist16 $clist, fe vce(cluster country) append nest title(Regression Table 6) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 6.doc) add(Controls, YES)
*** Testing Both Hypothesis Together ***
asdoc xtreg $ylist $xlist17 $clist, fe vce(cluster country) append nest title(Regression Table 6) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(GINI) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 6.doc) add(Controls, YES)

*** Tests Using SWIID Market Income and Disposable Income Inequality Measures ***
* defining global variables
* disposable income inequality
global ylist1 swiid_dsp
global ylist2 swiid_dsp_bott50
global ylist3 swiid_dsp_top10
* market income inequality
global ylist4 swiid_market
global ylist5 swiid_mrkt_bott50
global ylist6 swiid_mrkt_top10
*** Testing the Relationship Between Financial Liberalization, Financial Development, and Global Financial Crisis, and Disposable Income Inequality
* Market income inequality
asdoc xtreg $ylist4 $xlist3 $clist, fe vce(cluster country) replace nest title(Regression Table 7) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID MRKT) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 7.doc) add(Controls, YES)
*** Testing Whether Financial Liberalization through Financial Development and Global Financial Crisis has an effect on Disposable Income Inequality ***
asdoc xtreg $ylist4 $xlist6 $clist, fe vce(cluster country) nest append title(Regression Table 7) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID MRKT) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 7.doc) add(Controls, YES)
*** Testing Whether Financial Liberalization Behaves Differenty Prior and After Global Financial Crisis with respect to its effect on Income Inequality ***
* Prior
asdoc xtreg $ylist4 $xlist8 $clist, fe vce(cluster country) nest append title(Regression Table 7) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID MRKT) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 7.doc) add(Controls, YES)
* Post
asdoc xtreg $ylist4 $xlist10 $clist, fe vce(cluster country) nest append title(Regression Table 7) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID MRKT) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 7.doc) add(Controls, YES)
* Disposable income inequality
asdoc xtreg $ylist1 $xlist3 $clist, fe vce(cluster country) append nest title(Regression Table 7) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID DSP) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 7.doc) add(Controls, YES)
** Testing Whether Financial Liberalization through Financial Development and Global Financial Crisis has an effect on Disposable Income Inequality ***
asdoc xtreg $ylist1 $xlist6 $clist, fe vce(cluster country) nest append title(Regression Table 7) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID DSP) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 7.doc) add(Controls, YES)
*** Testing Whether Financial Liberalization Behaves Differenty Prior and After Global Financial Crisis with respect to its effect on Income Inequality ***
* Prior
asdoc xtreg $ylist1 $xlist8 $clist, fe vce(cluster country) nest append title(Regression Table 7) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID DSP) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 7.doc) add(Controls, YES)
* Post
asdoc xtreg $ylist1 $xlist10 $clist, fe vce(cluster country) nest append title(Regression Table 7) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID DSP) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 7.doc) add(Controls, YES)
*** Market Income Inequality Using Different Percentiles ***
* using bottom 50 percentiles
asdoc xtreg $ylist5 $xlist3 $clist, fe vce(cluster country) replace nest title(Regression Table 8) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID MRKT) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 8.doc) add(Controls, YES)
*** Testing Whether Financial Liberalization through Financial Development and Global Financial Crisis has an effect on Disposable Income Inequality ***
asdoc xtreg $ylist5 $xlist6 $clist, fe vce(cluster country) append nest title(Regression Table 8) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID MRKT) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 8.doc) add(Controls, YES)
*** Testing Whether Financial Liberalization Behaves Differenty Prior and After Global Financial Crisis with respect to its effect on Income Inequality ***
* Prior
asdoc xtreg $ylist5 $xlist8 $clist, fe vce(cluster country) append nest title(Regression Table 8) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID MRKT) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 8.doc) add(Controls, YES)
* Post
asdoc xtreg $ylist5 $xlist10 $clist, fe vce(cluster country) append nest title(Regression Table 8) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID MRKT) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 8.doc) add(Controls, YES)
* using top 10 percentiles
asdoc xtreg $ylist6 $xlist3 $clist, fe vce(cluster country) append nest title(Regression Table 8) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID MRKT) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 8.doc) add(Controls, YES)
*** Testing Whether Financial Liberalization through Financial Development and Global Financial Crisis has an effect on Disposable Income Inequality ***
asdoc xtreg $ylist6 $xlist6 $clist, fe vce(cluster country) append nest title(Regression Table 8) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID MRKT) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 8.doc) add(Controls, YES)
* Prior
asdoc xtreg $ylist6 $xlist8 $clist, fe vce(cluster country) append nest title(Regression Table 8) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID MRKT) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 8.doc) add(Controls, YES)
* Post
asdoc xtreg $ylist6 $xlist10 $clist, fe vce(cluster country) append nest title(Regression Table 8) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID MRKT) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 8.doc) add(Controls, YES)
*** Disposable Income Inequality Using Different Percentiles ***
* using bottom 50 percentiles
asdoc xtreg $ylist2 $xlist3 $clist, fe vce(cluster country) replace nest title(Regression Table 9) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID DSP) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 9.doc) add(Controls, YES)
*** Testing Whether Financial Liberalization through Financial Development and Global Financial Crisis has an effect on Disposable Income Inequality ***
asdoc xtreg $ylist2 $xlist6 $clist, fe vce(cluster country) append nest title(Regression Table 9) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID DSP) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 9.doc) add(Controls, YES)
* Prior
asdoc xtreg $ylist2 $xlist8 $clist, fe vce(cluster country) append nest title(Regression Table 9) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID DSP) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 9.doc) add(Controls, YES)
* Post
asdoc xtreg $ylist2 $xlist10 $clist, fe vce(cluster country) append nest title(Regression Table 9) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID DSP) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 9.doc) add(Controls, YES)
* using top 10 percentiles
asdoc xtreg $ylist3 $xlist3 $clist, fe vce(cluster country) append nest title(Regression Table 9) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID DSP) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 9.doc) add(Controls, YES)
*** Testing Whether Financial Liberalization through Financial Development and Global Financial Crisis has an effect on Disposable Income Inequality ***
asdoc xtreg $ylist3 $xlist6 $clist, fe vce(cluster country) append nest title(Regression Table 9) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID DSP) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 9.doc) add(Controls, YES)
* Prior
asdoc xtreg $ylist3 $xlist8 $clist, fe vce(cluster country) append nest title(Regression Table 9) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID DSP) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 9.doc) add(Controls, YES)
* Post
asdoc xtreg $ylist3 $xlist10 $clist, fe vce(cluster country) append nest title(Regression Table 9) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(SWIID DSP) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 9.doc) add(Controls, YES)

*** Tests Using the 80/20 percentile ratio from WIID ***
* defining global variables
global ylist7 s80s20
* 1
asdoc xtreg $ylist7 $xlist3 $clist, fe vce(cluster country) replace nest title(Regression Table 10) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(S80S20) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 10.doc) add(Controls, YES)
* 2
asdoc xtreg $ylist7 $xlist6 $clist, fe vce(cluster country) append nest title(Regression Table 10) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(S80S20) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 10.doc) add(Controls, YES)
* 3
asdoc xtreg $ylist7 $xlist8 $clist, fe vce(cluster country) append nest title(Regression Table 10) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(S80S20) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 10.doc) add(Controls, YES)
* 4
asdoc xtreg $ylist7 $xlist10 $clist, fe vce(cluster country) append nest title(Regression Table 10) drop(gdp_per_log trade pop_log infl gdp_grth agri ind nat_res edu_ter fdi gvt_cs civ_lib exprty net_barter _cons) cnames(S80S20) save(Y:/Master Thesis Documents Stata/Tables/Regression Table 10.doc) add(Controls, YES)






*** legal origin of Serbia and Montenegro!



*** Tests for Sub-Samples of Data ***
*** Focusing only on South-Eastern European Region ***
*** Without Slovenia *** 




*** Former Yugoslavian Countries ***
*** Western Balkan Region ***














*** Tests Using Different Measurement for Financial Development (Bank Deposits/GDP) ***
* defining global variables
global xlist6 fin_lib_lag fin_dev_dep_lag gfc_lag fin_lib_fin_dev_dep
global xlist7 fin_lib_lag fin_dev_dep_lag gfc_lag fin_lib_pre_gfc fin_lib_post_gfc
global xlist8 fin_lib_lag fin_dev_dep_lag gfc_lag fin_lib_fin_dev_dep fin_lib_pre_gfc fin_lib_post_gfc
*** 5) Testing Whether the Impact of Financial Liberalization Depends on Financial Development ***
* without controls
xtreg $ylist $xlist6, fe
* with controls 
xtreg $ylist $xlist6 $clist, fe
*** 6) Testing Whether Financial Liberalization has an Effect on Income Inequality Prior and After the Global Financial Crisis ***
* without controls
xtreg $ylist $xlist7, fe
* with controls
xtreg $ylist $xlist7 $clist, fe
*** 7) Testing Both Hypothesis Together ***
* without controls
xtreg $ylist $xlist8, fe
* with controls
xtreg $ylist $xlist8 $clist, fe

*** Tests Using Different Measurement for Income Inequality (Market Income Inequality by SWIID) ***
* defining global variable
global ylist1 swiid_market
*** 8) Testing Whether the Impact of Financial Liberalization Depends on Financial Development with Alternative Measurement ***
* without controls
xtreg $ylist1 $xlist1, fe
* with controls
xtreg $ylist1 $xlist1 $clist, fe 
*** 9) Testing Whether Financial Liberalization has an Effect on Income Inequality Prior and After the Global Financial Crisis ***
* without controls
xtreg $ylist1 $xlist4, fe
* with controls
xtreg $ylist1 $xlist4 $clist, fe
*** 10) Testing Both Hypothesis Together ***
* without controls
xtreg $ylist1 $xlist5, fe
* with controls
xtreg $ylist1 $xlist5 $clist, fe

*** Tests Using Random Effects ***
*** 11) Testing Whether the Impact of Financial Liberalization Depends on Financial Development ***
* without controls
xtreg $ylist $xlist1, re theta
* with controls
xtreg $ylist $xlist1 $clist, re theta 
*** 12) Testing Whether Financial Liberalization has an Effect on Income Inequality Prior and After the Global Financial Crisis ***
* without controls
xtreg $ylist $xlist4, re theta
* with controls  
xtreg $ylist $xlist4 $clist, re theta
*** 13) Testing Both Hypothesis Together ***
* without controls
xtreg $ylist $xlist8, re theta
* with controls
xtreg $ylist $xlist8 $clist, re theta

*** Tests Using Robust Standard Errors ***
*** 14) Testing Whether the Impact of Financial Liberalization Depends on Financial Development ***
* without controls
xtreg $ylist $xlist1, fe vce(cluster country)
* with controls
xtreg $ylist $xlist1 $clist, fe vce(cluster country)
*** 15) Testing Whether Financial Liberalization has an Effect on Income Inequality Prior and After the Global Financial Crisis ***
* without controls
xtreg $ylist $xlist4, fe vce(cluster country)
* with controls  
xtreg $ylist $xlist4 $clist, fe vce(cluster country)
*** 16) Testing Both Hypothesis Together ***
* without controls
xtreg $ylist $xlist5, fe vce(cluster country)
* with controls
xtreg $ylist $xlist5 $clist, fe vce(cluster country)







*** Hausman Test ***
* fixed effects
xtreg $ylist $xlist $clist, fe
estimates store fixed
* random effects
xtreg $ylist $xlist $clist, re theta
estimates store random
* running the test
hausman fixed random

*** Fixed effects without interaction terms ***
* without controls
xtreg $ylist $xlist, fe
* with controls
xtreg $ylist $xlist $clist, fe
* with lags
xtreg $ylist $xlist2, fe
xtreg $ylist $xlist2 $clist, fe

*** Random Effects without interaction terms ***
* without controls
xtreg $ylist $xlist, re theta
* with controls
xtreg $ylist $xlist $clist, re theta
* with lags
xtreg $ylist $xlist2, re theta
xtreg $ylist $xlist2 $clist, re theta

*** Fixed effects with interaction terms ***
* without controls
xtreg $ylist $xlist1, fe
* with controls
xtreg $ylist $xlist1 $clist, fe
* with lags
xtreg $ylist $xlist3, fe
xtreg $ylist $xlist3 $clist, fe

*** Random Effects with interaction terms ***
* without controls
xtreg $ylist $xlist1, re theta
* with controls
xtreg $ylist $xlist1 $clist, re theta
* with lags
xtreg $ylist $xlist3, re theta
xtreg $ylist $xlist3 $clist, re theta

***** Panel Data Analysis *****
***** Cross-Country Without Fixed Effects *****

*** Without Interaction Terms ***
* without controls
reg $ylist $xlist
* with controls
reg $ylist $xlist $clist
* with lags
reg $ylist $xlist2
reg $ylist $xlist2 $clist

*** With Interaction Terms ***
* without controls
reg $ylist $xlist1
* with controls
reg $ylist $xlist1 $clist
* with lags
reg $ylist $xlist3
reg $ylist $xlist3 $clist

***** Panel Data Analysis *****
***** First-Diff *****

*** Without Interaction Terms ***
* without controls
reg D.($ylist $xlist9), noconstant
* with controls
reg D.($ylist $xlist9 $clist), vce(cluster country) noconstant

*** With Interaction Terms ***
* without controls
reg D.($ylist $xlist1), noconstant
* with controls
reg D.($ylist $xlist1 $clist), noconstant



*** 3) Testing Whether Financial Liberalization has an Effect on Income Inequality Prior and After the Global Financial Crisis ***
*** prior to global financial crisis ***
* without controls
xtreg $ylist $xlist2, fe
* with controls  
xtreg $ylist $xlist2 $clist, fe
*** after global financial crisis ***
* without controls
xtreg $ylist $xlist3, fe
* with controls  
xtreg $ylist $xlist3 $clist, fe
*** together prior and after global finacial crisis ***
* without controls
xtreg $ylist $xlist4, fe
* with controls  
xtreg $ylist $xlist4 $clist, fe

*** 4) Testing Both Hypothesis Together ***
* without controls
xtreg $ylist $xlist5, fe
* with controls
xtreg $ylist $xlist5 $clist, fe


*** Regression Without Interaction Terms ***
xtreg $ylist $xlist3 $clist, fe
*** Regressions With Interaction Terms ***
* without controls
xtreg $ylist $xlist10, fe
* with controls
xtreg $ylist $xlist10 $clist, fe