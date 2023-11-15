### Data Set Creation ###

# Packages used

import numpy as np
import pandas as pd

# Countries of interest

balkan_countries = ["Albania", "North Macedonia", "Serbia", "Montenegro", "Bosnia & Hezegovina", "Croatia", "Bulgaria", "Romania"]

# Data files used

swiid = pd.read_stata("C:/Users/haris/OneDrive/Desktop/Master Thesis/Data/swiid_income_inequality.dta")
unu_wilder = pd.read_excel("C:/Users/haris/OneDrive/Desktop/Master Thesis/Data/wiid_income_inequality.xlsx")
fin_lib = pd.ExcelFile("C:/Users/haris/OneDrive/Desktop/Master Thesis/Data/financial_liberalization_indicators.xlsx")

# Defining the Indicator Variables

def ind_variables(data_frame):
    # Country
    data_frame["Country"] = np.repeat(balkan_countries,17)
    # Year
    data_frame["Year"] = np.tile(range(2000,2017),8)
    return data_frame

# Dependent Variables

# SWIID
def swiid_market(data_frame, balkan_countries, swiid):
    # Selecting observations and calculating mean
    selecting_data = swiid[swiid['country'].isin(balkan_countries) & (swiid['year'] >= 2000) & (swiid['year'] <= 2016)]
    selecting_data['mrkt_inc'] = selecting_data.iloc[:, 104:204].mean(axis=1)

    # Add a new variable "SWIID_market" with NaN values to the existing data_frame
    data_frame["SWIID_market"] = np.nan

    # Assign the "mrkt_inc" values for each country in data_frame
    for i, country in enumerate(balkan_countries):
        start = i * 17
        end = (i + 1) * 17
        data_frame.iloc[start:end, data_frame.columns.get_loc('SWIID_market')] = selecting_data[selecting_data['country'] == country]['mrkt_inc']

    return data_frame

# UNU-WILDER
def gini_coeff(data_frame, balkan_countries, unu_wilder):
    # Selecting observations
    selecting_data1 = unu_wilder[unu_wilder['COUNTRY'].isin(balkan_countries) & (unu_wilder['YEAR'] >= 2000) & (unu_wilder['YEAR'] <= 2016)]
    # Add a new variable "Gini_coeff" with NaN values to the existing data_frame
    data_frame["Gini_coeff"] = np.nan
    # Loop to add the respective values
    for country in balkan_countries:
        data_frame.loc[data_frame['Country'] == country, 'Gini_coeff'] = list(selecting_data1[selecting_data1['COUNTRY'] == country]['GINI INDEX'])

    return data_frame

# Independent Variables

# Financial Liberalization
def calculate_mean_from_excel(data_frame, file_path, country, column_indices, sheet_name):
    # Load data from the Excel file
    fin_lib_data = pd.read_excel(file_path, sheet_name)
    
    # Extract the specified rows and columns
    selected_data = fin_lib_data.iloc[column_indices, 15:48:2]
    
    # Calculate the mean
    mean_values = selected_data.mean()
    
    # Add the mean values to the data frame
    data_frame.loc[data_frame['country'] == country, 'fin_lib'] = mean_values.tolist()
file_path = "C:/Users/haris/OneDrive/Desktop/Master Thesis/Data/financial_liberalization_indicators.xlsx"

# Loop through countries and calculate fin_lib values
for country in balkan_countries:
    calculate_mean_from_excel(data_frame, file_path, country, [26, 35, 36, 42], country)

# Global Financial Crisis
def set_gfc_column(data_frame):
    data_frame['gfc'] = 0  # Set 'gfc' column to 0 by default
    data_frame.loc[data_frame['year'].isin([2008, 2009]), 'gfc'] = 1  # Set 'gfc' to 1 where 'year' matches 2008 or 2009
    return data_frame

# Financial Development
def process_fin_dev_data(data_frame, country_code, country_name, columns):
    # Load the financial development indicator data
    fin_dev = pd.read_csv("C:/Users/haris/OneDrive/Desktop/Master Thesis/Data/financial_development_indicator.csv")
    
    # Adding a variable with NaN values
    data_frame["fin_dev"] = np.nan
    
    # Filter the data for the specific country
    country_data = fin_dev[fin_dev['Country Code'] == country_code]
    
    # Extract and process the desired columns
    country_values = country_data.iloc[0, columns].replace('..', np.nan).tolist()
    
    # Update the 'fin_dev' variable in the initial data frame
    data_frame.loc[data_frame['country'] == country_name, 'fin_dev'] = country_values

    return data_frame

# Example usage for Albania
country_code_albania = 'ALB'
country_name_albania = 'Albania'
columns_to_extract = range(12, 29)

data_frame = process_fin_dev_data(data_frame, country_code_albania, country_name_albania, columns_to_extract)
print(data_frame.to_string())

