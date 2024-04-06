# Financial Liberalization in Transition Economies: Implications for Income Inequality in South Eastern Europe

### Master Thesis Work

### University of Bonn - WS 2023/2024

### Author

- Haris Rizvanski (e-mail: haris.rizvanski@uni-bonn.de)

### About

This repository contains materials used for my master thesis in the Winter Semester of 2023/2024. This master thesis was submitted to the department of economics at the
Rheinische Friedrich-Wilhelms-Universität Bonn on 05.04.2024. The topic of the thesis is "Financial Liberalization in Transition Economies: Implications for Income Inequality
in South Eastern Europe". This thesis explores the role of financial liberalization in eight South Eastern European countries and its impact on income inequality during the period
between the years 2000 and 2016. Furthermore, it provides short historical background on the region, explores the financial liberalization process and how the financial systems 
are structured within the countries, and contains empirical analysis that explore the relationship between financial liberalization and income inequality.

### Data

The data for the analysis is collected from several sources, including: World Bank (WB), World Income Inequality Database (WIID), Fraser Institute, International Monetary Fund (IMF), 
United Nations Conference on Trade and Development (UNCTAD), Freedom House, Organization for Economic Cooperation and Development (OECD) and Database of Political Institutions (DPI).

The time period for which the data is collected is between the years 2000 and 2016. 

The data is obtained for the following countries:

- Albania
- North Macedonia
- Serbia
- Montenegro
- Bosnia and Herzegovina
- Croatia
- Slovenia
- Bulgaria
- Romania

All of the data files used to construct the data set can be found in the folder "Data". Furthermore, the final data set that was used for the empirical analysis can be found in the 
same folder, under the sub-folder "final_data". In this sub-folder there are two files, named: final_data_see, and final_data_world. The first file (.._see) contains data for the countries
of South Eastern Europe. This file was used in the main empirical analysis, as well as for constructing the tables and figures for the South Eastern European countries. The second file (.._world)
contains data for countries belonging to different regions of the world. This file (.._world) was only used for constructing tables that were used to compare more developed economies with the 
countries used in the main analysis. Both of the files can be found in csv and dta formats. 

These files are easily accessible either by clicking the .csv files, or by opening the .dta file with Stata.

### Data Management

There are several data files used to construct the panel data. This panel data was not previously available online. For the construction of this data, there are two separate notebook
files used. These files can be found in the "Data_Management" folder. The first notebook file (data_management_see.ipynb) was used to construct the panel data 
(final_data_see.dta and final_data_see.csv) on the South Eastern European Countries. The second notebook file (data_management_world.ipynb) was used to construct the data files 
(final_data_world.dta and final_data_world.csv) on the countries as comparison from different regions of the world. 

### Empirical Analysis

The empirical analysis was done using the Stata program. The do-file can be found in the "Empirical_Analysis" folder, under the name "data-analysis.do". This file can be opened using the Stata program.
This do-file was used to conduct the empirical analysis with a country fixed-effects dynamic panel data model. Additionally, this file was used to create the descriptive tables and figures used for the master thesis.

### Figures

The "Figures" folder contains all of the figures used in the master thesis. They are numerically listed accordingly with their usage in the master thesis. There are in total 15 figures. All of the figures
are in .png format.

### Paper

The folder "Paper" contains the final work in a .pdf format. This file is named "final_paper.pdf".

### References

All of the papers used in the master thesis are listed in a text file. This file is named "Papers Used in Thesis.txt" and can be found in the "References" folder.

### Tables

The folder "Tables" contains all of the tables used in the master thesis. First, there are the the descriptive tables, starting from "Table 1" to "Table 15". These tables contain descriptive information 
on both the South Eastern European countries and the countries taken as comparison from different regions of the world. Then, there are the regression tables, starting from "Regression Table 1" to
"Regression Table 6", which show the results from the empirical analysis. All of the tables are in .docx format.
