Data and analysis files accompanying "Ultramafic weathering in tropical volcanic arcs: Geochemistry and inverse modeling of rivers draining the Zambales Ophiolite Complex (ZOC), Philippines" by Custado, et al.
```text
zambales-ophiolite-complex-river-geochem/
├── flux_calculations/
│   ├── Custado_et_al_Zambales_flux_calcs.py
│   ├── Inputs/                 # Water chemistry, catchments, discharge, inversion ID lookup
│   └── Outputs/                # Seasonal/annual fluxes and variability estimates
├── MEANDIR_files/
│   ├── MEANDIR_ScenarioParameters.m
│   ├── MEANDIR_UserEntries.xlsx
│   ├── zam_data_masterlist_for_inversion.xlsx
│   └── Raw outputs/            # FX and EM results for three inversion scenarios
├── phreeqc/
│   ├── river_geochem_input_w_Al_v2.pqi
│   ├── river_geochem_input_w_Al_v2.pqo
│   └── river_results.csv
└── other_datasheets/
    ├── compiled_sea_sr_data.xlsx
    ├── global_comparison_weathering.xlsx
    └── ternary_diagram_values.csv
```
`flux_calculations`:
`Custado_et_al_Zambales_flux_calcs.py` combines river chemistry, MEANDIR-derived endmember contributions, discharge, and drainage areas to calculate seasonal and annual area-normalized solute fluxes. 
The `Inputs/` directory contains the water-chemistry master list (`zambales_masterlist_06Apr26.csv`), inversion sample-ID lookup, catchment areas, monthly discharge estimates, and daily discharge estimates. 
The `Outputs/` directory contains supplied flux results for the full inversion model and a table of coefficients of variation, which are also calculated in the python script.

Running the flux calculations
Install Python with `numpy` and `pandas`.
Open `flux_calculations/Custado_et_al_Zambales_flux_calcs.py` and replace each `\[path]` placeholder with the appropriate local directories.
Set `fname` to the desired inversion scenario and `pct` to `median`, `pct25`, or `pct75`. The output tables are from the `FULLMODEL` scenario.
Run the script. Its final `to_csv` statements write seasonal fluxes, annual fluxes, and catchment variability estimates to the paths you specify.

`MEANDIR_file`:
Contains inversion input spreadsheets, scenario-parameter definitions, and exported results. 
In `Raw outputs/`, `FX_*.csv` files contain fractional endmember contributions and `EM_*.csv` files contain inversion-constrained endmember compositions. 
The scenarios supplied are: `FULLMODEL`, `FULLMODEL_WITHOUT_SR`, `MAJORS_WITHOUT_CLAY`, `MAJORS_WITH_CLAY`. 
The scenario-parameter `.m` file contains blocks intended to be copy-pasted in the MEANDIR_FindScenarioParameters.m file.
Access the full MEANDIR MATLAB files by Kemeny and Torres here: https://github.com/PrestonCosslettKemeny/MEANDIR

`phreeqc`:
Contains a PHREEQC input file (`.pqi`), its output (`.pqo`), and tabulated river results (`river\_results.csv`).

`other_datasheets`:
Contains supporting tables for Southeast Asian Sr data, global weathering comparisons, and ternary-diagram values (Fig. 3a of main manuscript).

