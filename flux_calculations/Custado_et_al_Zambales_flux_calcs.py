# -*- coding: utf-8 -*-
"""
Created on Tue Apr 28 20:54:20 2026

@author: mcustado
"""

import numpy as np
import pandas as pd

pd.options.future.infer_string = False

def flatten(xss):  # Flatten a nested list
    return [x for xs in xss for x in xs]

# %% Load data files. Edit [path] to actual file path

zam = pd.read_csv(r'[path]\zambales_masterlist_06Apr26.csv') 
zam['Sr_uM'] = zam['Sr_nM']/1000

inv_id = pd.read_csv(r'[path]\inversion_id_names.csv') # Match inversion IDs (FX and EM files) to catchments
disch_data = pd.read_csv(r'[path]\estimated_discharge.csv') # Monthly climatological data
disch_daily_data = pd.read_csv(r'[path]\estimated_discharge_daily.csv') # Daily data
catchments = pd.read_csv(r'[path]\catchments.csv') # Study catchments

# Collect all water samples into one dataframe
waters = zam.loc[zam['Sample_type'] == 'water'].copy()
waters['SumObs'] = waters['Ca_uM'] + waters['Mg_uM'] + waters['Na_uM']

# Divide samples by geographic subgroup
west_water = waters.loc[(waters['Group'] == 'West')]
east_water = waters.loc[(waters['Group'] == 'East')]
pmb_water = waters.loc[(waters['Group'] == 'PMB')]
sc_water = waters.loc[(waters['Group'] == 'SC')]

waters_dict = {
    "West": west_water,
    "East": east_water,
    "PMB": pmb_water,
    "SC": sc_water
    }

# %% Define color palettes and markers for visualization

palette = {
    "West": "#4477AA",
    "East": "#AA3377",
    "PMB": "#228833",
    "SC": "#66CCEE"
    }

rock_type = {"slct_lowNa": "P",
             "slct_highNa": "h",
             "umfc": "*",
             "carb": "D"}

rock_color = {"slct_lowNa": "#e0d7c3",
             "slct_highNa": "#FFD10B",
             "umfc": "#83FF49",
             "carb": "#F43C20"}

# %% Calculate SEASONAL endmember fractions per ion per catchment

# -----------------------------------------------------------------------------
# Load the output files from the MEANDIR analysis (MEANDIR_files > Raw outputs)
# FX - fractional contributions of each endmember; EM - inversion-constrained endmember ratios
# -----------------------------------------------------------------------------

# Which scenario (refer to file names): 'FULLMODEL', 'FULLMODEL_WITHOUT_SR', 'MAJORS_WITHOUT_CLAY'
fname = 'FULLMODEL' 

# Load fractional contribution (FX) file
em_file = pd.read_csv(r'[path]\\FX_' + fname + '.csv') # Replace [path] with the appropriate directory

# Define endmembers and ions to evaluate
source_em = ['bslt', 'slct', 'carb', 'prec', 'umfc']
sink_em = 'clay' # Comment out for the MAJORS_WITHOUT_CLAY scenario

ions = ['Ca', 'Mg', 'Na', 'Cl','Si','Sr','Sr8786_x_Sr','norm']  # 'norm' denotes the inversion normalization parameter ([Ca] + [Mg] + [Na])
ion_conc = ['Ca_uM', 'Mg_uM', 'Na_uM', 'Cl_uM','Si_uM','Sr_uM','Sr_ratio']  # Corresponding concentration columns 
                                                                            # Column names in the chemistry dataframe

df_inversions = em_file.join(inv_id, lsuffix="_inv_results", rsuffix="_inv_id") # Match fractional contributions to inversion IDs
df_inversions = df_inversions.set_index('sample_id_inv_results')

# -----------------------------------------------------------------------------
# Arrange inversion results in a single dataframe
# -----------------------------------------------------------------------------

em_col = []
sink_col = []

for ion in ions:
    if ion == 'norm':  # The norm variable has different column names
        s = [f'F_{ion}_{em}' for em in source_em]
        s25 = [f'F_{ion}_25_{em}' for em in source_em]
        s75 = [f'F_{ion}_75_{em}' for em in source_em]
        em_col.append(s)
        em_col.append(s25)
        em_col.append(s75)
    
        sink_col.append(f'F_{ion}_{sink_em}')
        sink_col.append(f'F_{ion}_25_{sink_em}')
        sink_col.append(f'F_{ion}_75_{sink_em}')
    
    else:
        s = [f'F_{ion}_{em}' for em in source_em]
        s25 = [f'F_{ion}_{em}_pct25' for em in source_em]
        s75 = [f'F_{ion}_{em}_pct75' for em in source_em]
        em_col.append(s)
        em_col.append(s25)
        em_col.append(s75)
    
        sink_col.append(f'F_{ion}_{sink_em}')
        sink_col.append(f'F_{ion}_{sink_em}_pct25')
        sink_col.append(f'F_{ion}_{sink_em}_pct75')

cols = ['catchment', 'season', 'group'] + flatten(em_col) + sink_col

df = df_inversions[cols].set_index('catchment') # Select columns from the inversion output

# -----------------------------------------------------------------------------
# Summarize seasonal fractional contributions by catchment 
# -----------------------------------------------------------------------------
df2 = df.copy()

for ion in ions:
    
    if ion == 'norm':  # The norm variable uses _25 and _75 rather than _pct25 and _pct75
        total = df2[[f'F_{ion}_{em}' for em in source_em]].sum(axis=1)
        total_25 = df2[[f'F_{ion}_25_{em}' for em in source_em]].sum(axis=1)
        total_75 = df2[[f'F_{ion}_75_{em}' for em in source_em]].sum(axis=1)
        
        for em in source_em:
            df2[f'F_{ion}_{em}_norm'] = df2[f'F_{ion}_{em}'] / total
            df2[f'F_{ion}_{em}_pct25_norm'] = df2[f'F_{ion}_25_{em}'] / total_25
            df2[f'F_{ion}_{em}_pct75_norm'] = df2[f'F_{ion}_75_{em}'] / total_75
            
        df2[f'F_{ion}_{sink_em}_norm'] = -df2[f'F_{ion}_{sink_em}'] / (1-df2[f'F_{ion}_{sink_em}'])
        df2[f'F_{ion}_{sink_em}_pct25_norm'] = -df2[f'F_{ion}_25_{sink_em}'] / (1-df2[f'F_{ion}_25_{sink_em}'])
        df2[f'F_{ion}_{sink_em}_pct75_norm'] = -df2[f'F_{ion}_75_{sink_em}'] / (1-df2[f'F_{ion}_75_{sink_em}'])
        
    else:
        # Total contribution of that ion across endmembers PER ROW
        total = df2[[f'F_{ion}_{em}' for em in source_em]].sum(axis=1)
        total_25 = df2[[f'F_{ion}_{em}_pct25' for em in source_em]].sum(axis=1)
        total_75 = df2[[f'F_{ion}_{em}_pct75' for em in source_em]].sum(axis=1)

        # Normalize each endmember contribution for that ion
        for em in source_em:
            df2[f'F_{ion}_{em}_norm'] = df2[f'F_{ion}_{em}'] / total
            df2[f'F_{ion}_{em}_pct25_norm'] = df2[f'F_{ion}_{em}_pct25'] / total_25
            df2[f'F_{ion}_{em}_pct75_norm'] = df2[f'F_{ion}_{em}_pct75'] / total_75
        
        df2[f'F_{ion}_{sink_em}_norm'] = -df2[f'F_{ion}_{sink_em}'] / (1-df2[f'F_{ion}_{sink_em}'])
        df2[f'F_{ion}_{sink_em}_pct25_norm'] = -df2[f'F_{ion}_{sink_em}_pct25'] / (1-df2[f'F_{ion}_{sink_em}_pct25'])
        df2[f'F_{ion}_{sink_em}_pct75_norm'] = -df2[f'F_{ion}_{sink_em}_pct75'] / (1-df2[f'F_{ion}_{sink_em}_pct75'])

# Get normalized-fraction column headers
norm_cols = [c for c in df2.columns if c.endswith('_norm')]
# clay_cols = [f'F_{ion}_{sink_em}_norm' for ion in ions]

# Group normalized fractions per season, reset index so that catchment name is repeated per season
avg_frac_season = df2.groupby([df2.index, 'season'])[norm_cols].mean().reset_index()

# %% Generate dataframe that contains the seasonal averages of the chemistry and the calculated fractional contributions per season 

catch_list = ['lawis_river', 'bulsa_river_ds', 'camiling_river_us', 'malabobo_river',
       'dumoloc_river', 'bulsa_river_us', 'camiling_river_ds', 'bayaoas_river',
       'mapita_river', 'pmb1', 'pmb2', 'pmb4', 'pmb3', 'sc7', 'masinloc_river',
       'salasa_river', 'bagsit_river', 'bancal_river', 'bucao_river',
       'maloma_river', 'sc5', 'sc1', 'sc6', 'sc4', 'dapya_river']

seasonal_chem = waters.groupby(['Catchment', 'Season'])[ion_conc].mean().reset_index()
seasonal_chem['norm_uM'] = seasonal_chem[['Ca_uM', 'Mg_uM', 'Na_uM']].sum(axis=1)

# Make column names consistent
frac2 = avg_frac_season.copy()
conc2 = seasonal_chem.copy()

cols = conc2.columns.to_series()
cols.iloc[0:2] = cols.iloc[0:2].str.lower()
cols = cols.values
conc2.columns = cols

# Merge normalized fractions with concentrations
seasonal_chem_frac = conc2.merge(frac2, on=['catchment', 'season'], how='left')

pct = 'median' # Select 'median', 'pct25', or 'pct75'

# Calculate concentration contribution of each endmember to each ion
for ion, conc in zip(ions, ion_conc):    
    for e in source_em:
        frac_col = f'F_{ion}_{e}_norm' if pct == 'median' else f'F_{ion}_{e}_{pct}_norm'
        seasonal_chem_frac[f'{ion}_{e}_uM'] = seasonal_chem_frac[conc] * seasonal_chem_frac[frac_col]


# %% Get weighing factors per season based on discharge data (to be used for averaging to get annual fluxes)

# Dry season: Nov–Apr; wet season: May–Oct. Climate reference: https://upload.wikimedia.org/wikipedia/commons/6/61/Climate_Map_of_the_Philippines_%281951-2010%29.jpg
dry_months = [11, 12, 1, 2, 3, 4]
wet_months = [5, 6, 7, 8, 9, 10]

discharge2 = disch_data.copy()
discharge2.rename(columns={'date': 'month'}, inplace=True) # Rename 'date' to 'month'

discharge2['season'] = np.where(discharge2['month'].isin(dry_months),'dry','wet')

weights = (discharge2.melt(id_vars=['season'], var_name='catchment', value_name='discharge').groupby(['catchment', 'season'], as_index=False)['discharge'].sum())

weights['season_weight'] = (weights['discharge']/weights.groupby('catchment')['discharge'].transform('sum'))

# Apply discharge-based seasonal weights to chemistry

# Merge seasonal chemistry, discharge weights, and drainage area
seasonal_chem_flux = seasonal_chem_frac.merge(weights[['catchment', 'season', 'discharge','season_weight']], on=['catchment', 'season'], how='left')
seasonal_chem_flux = seasonal_chem_flux.merge(catchments[['catchment', 'drainage_area_km2']], on='catchment', how='left')

exclude_list = ['ephemeral', 'pmb34','sc67'] # Exclude catchments not used in the analysis

seasonal_chem_flux = seasonal_chem_flux[~seasonal_chem_flux['catchment'].isin(exclude_list)]

# Fill missing dry/wet fractions within each catchment
# bulsa_river_ds - no inversion-constrained wet fractions; dapya_river - no dry fraction; pmb34 - no dry fraction; sc1, sc4, sc6 - no dry fractions

df = seasonal_chem_flux.copy()

# Columns to copy across seasons
frac_cols = [c for c in df.columns if c.startswith('F_') and c.endswith('_norm')]

df[frac_cols] = df[frac_cols].apply(pd.to_numeric, errors='coerce')

# Fill missing dry/wet fractions within each catchment
df[frac_cols] = (
    df
    .groupby('catchment')[frac_cols]
    .transform(lambda x: x.bfill().ffill())
)

df['Sr_ratio'] = df.groupby('catchment')['Sr_ratio'].transform(lambda x: x.bfill().ffill())

for ion in ions:
    for e in source_em:
        if ion == 'Sr8786_x_Sr':
            ion_data = df['Sr_uM']*df['Sr_ratio']
        else:
            ion_data = df[f'{ion}_uM']
            
            df[f'{ion}_{e}_uM'] = (
                ion_data *
                df[f'F_{ion}_{e}_norm']
            )

seasonal_chem_flux_filled = df  # Filled dataset

#%% Calculate seasonal area-normalized fluxes, then sum to obtain annual area-normalized fluxes

for ion in ions:
    for e in source_em:
        if ion == 'Sr8786_x_Sr':
            ion_data = seasonal_chem_flux_filled['Sr_uM']*seasonal_chem_flux_filled['Sr_ratio']
        else:
            ion_data = seasonal_chem_flux_filled[f'{ion}_uM']
            
        seasonal_chem_flux_filled[f'{ion}_{e}_mol_km2_season'] = (
            ion_data * seasonal_chem_flux_filled[f'F_{ion}_{e}_norm']  # Endmember contribution to concentration
            * 1e-6 * 1000 * seasonal_chem_flux_filled['discharge'] # Convert µmol/L to mol/m³ and multiply by seasonal discharge (m³)
            * 1/seasonal_chem_flux_filled['drainage_area_km2']) # Divide by drainage area to obtain mol/km²/season

flux_cols = [f'{ion}_{em}_mol_km2_season' for ion in ions for em in source_em]

# Calculate annual discharge and include it in the exported dataframe

annual_discharge = (
    weights
    .groupby('catchment', as_index=False)['discharge']
    .sum()
    .rename(columns={'discharge': 'annual_discharge_m3_yr'})
)

annual_chem_flux = (seasonal_chem_flux_filled.groupby('catchment')[flux_cols].sum().reset_index())

annual_chem_flux = annual_chem_flux.merge(
    annual_discharge,
    on='catchment',
    how='left'
)

annual_chem_flux.columns = annual_chem_flux.columns.str.replace('km2_season', 'km2_year', regex=False)

# %% Calculate uncertainties (Schopka, et al. 2011)

# Catchment-level uncertainty
# Calculate CV for each solute and catchment
conc_std = waters.groupby("Catchment").std(numeric_only=True)
conc_mean = waters.groupby("Catchment").mean(numeric_only=True)
conc_cv = conc_std/conc_mean

cv_catchment = conc_cv.copy() # Create the main CV dataframe

cv_catchment = cv_catchment.drop(index=['ephemeral', 'pmb34', 'sc67']) # Exclude catchments not used in the analysis

# Calculate CV for each parent gauge
q = disch_daily_data.copy()

q['date'] = pd.to_datetime(q['date'])
q = q.melt('date', var_name='Gauge', value_name='Q').dropna()

q['Year'] = q['date'].dt.year
q['Month'] = q['date'].dt.month

q['Q'] = pd.to_numeric(q['Q'], errors='coerce')
q = q.dropna(subset=['Q'])

monthly_q = q.groupby(['Gauge', 'Year', 'Month'])['Q'].median().reset_index()
monthly_q['Q'] *= pd.to_datetime(dict(year=monthly_q['Year'], month=monthly_q['Month'], day=1)).dt.days_in_month

annual_q = (monthly_q.groupby(['Gauge','Year'])
     .filter(lambda x: x['Month'].nunique() == 12)
     .groupby(['Gauge','Year'])['Q']
     .sum()
     .reset_index()
)

q_cv = annual_q.groupby('Gauge')['Q'].agg(['mean', 'std', 'count'])
q_cv['cv_Q'] = q_cv['std'] / q_cv['mean']
q_cv['cv_Q_mean'] = q_cv['cv_Q'] / np.sqrt(q_cv['count'])

cv_catchment['Q_cv'] = q_cv['cv_Q_mean']
cv_catchment['drainage_area_km2'] = catchments.set_index('catchment')['drainage_area_km2']

cv_catchment['area_cv'] = np.select(
    [cv_catchment['drainage_area_km2'] < 2,
     cv_catchment['drainage_area_km2'].between(2, 22),
     cv_catchment['drainage_area_km2'] > 22],
    [0.24, 0.16, 0.03] # assigned CV depending on the area of the catchment (see main text for reference)
)

#%% Save final dataframes to csvs
seasonal_chem_flux_filled.to_csv(r'[path]\seasonal_chem_flux_filled_'+pct+'_'+fname+'.csv') # Seasonal area-normalized fluxes
annual_chem_flux.to_csv(r'[path]\\annual_chem_flux'+pct+'_'+fname+'.csv') # Annual area-normalized fluxes
cv_catchment.to_csv(r'[path]'+'cv_conc_disch_area.csv') # Coefficient of variations

