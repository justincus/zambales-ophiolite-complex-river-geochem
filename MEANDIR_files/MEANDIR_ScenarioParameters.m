%% To use with MEANDIR, these need to be pasted into the if statement in MEANDIR_FindScenarioParameters.m

%% Scenario 1: Full scenario
elseif isequal(ScenarioList{ScenarioListIndex},'Zam_CaMgNaClSiSr')     
  % group 1/5, river observations - 12 variables
    Riverdatasource              = 'IndividualReRuns';       % Data name for the source of the river observations
    AdjustRiverObs               = 0;                          % whether river measurements should be adjusted to reflect analytical uncertainty. options are: 0 or 1
    ObsList                      = {'Ca', 'Mg', 'Na', 'Cl','Si','Sr','Sr8786'}; % list of elements, ions, and isotopic ratios to include in the inversion
    CostFunType                  = {'rel','rel','rel','rel','rel','rel','rel'};  % whether each variable should be evaluated as proportional cost or absolute cost. options are 'rel' and 'abs'.
    WeightingList                = [1   1   1   1   1   1   1];   % weighting term for the cost function                    
    ErrorCutMinMB                = [85   85   85   85   85   85   -0.002];  % if IterateOver is "Samples", these are the bounds of mass balance that will be accepted for an inversion result  
    ErrorCutMaxMB                = [115   115   115   115   115   115   0.002];   % if IterateOver is "Samples", these are the bounds of mass balance that will be accepted for an inversion result  
    nCFList                      = {};                         % list of dissolved variables (in ObsList) to not include in the cost function evaluation
    ConvertDelta2RList           = {};                         % list of isotopic variables (in delta notation) to be converted to isotopic ratios for the analysis (results are converted back to delta)
    AllIonsExplicitlyResolved    =  0;                         % Indicate if all cations and anions (all sources of charge) are resolved. options are: 0 or 1    
    ObsInNormalization           = {'Ca','Mg','Na'};           % list of variables included in the normalization
    ImposeNormalizationCheck     = 1;                          % whether the normalization should be reproduced to the minimum and maximum values for non-isotopic variables 
  % group 2/5, general settings - 8 variables
    Solver                       = 'mldivide_optimize';        % type of inversion solution, options are: 'mldivide', 'lsqnonneg', 'mldivide_optimize', 'lsqnonneg_optimize', 'optimize'. enter as string, not a cell.
    IterateOver                  = 'Samples';                  % whether to apply the same end-members to all sample ('End-members'), or different end-members to each sample ('Sample'). options are: 'End-members', 'Samples'
    maxiterations                = 3000000;                     % if IterateOver equals "Samples", this is the maximum number of inversion attempts 
    maxsuccess                   = 400;                        % if IterateOver is "Samples", this is the desired number of successes      
    numberiterations             = NaN;                        % if IterateOver equals "End-members", this is the number of inversions to perform
    MisfitCuts                   = NaN;                        % if IterateOver equals "End-members", this percentage of simulations with lowest misfit between model result and data will be kept    
    CullOn                       = 'NaN';                      % if IterateOver is "End-members", this must be either 'EachSample' or 'AllSample' and describes HOW to cull the data
    saveuncutdata                = 0;                          % if 1, saves all the simulation data (results in very large files)    
  % group 3/5, end-members - 14 variables
    EMdatasource                 = 'CaMgNaClSiSr_initial';       % the name of the end-member group (the entry on column A of the spreadsheet containing end-member information). 
    EMList0                      = {'prec','bslt','carb','flsc','umfc','clay'};     % list of the end-members to use in the inversion (row 2 of spreadsheet containing end-member information).     
    MinFractionalContribution    = [000   000   000   000   000   -1];      % the minumum fractional contribution of each end-member to the normalization ion (typically 0, unless secondary mineral formation is in inversion)
    MaxFractionalContribution    = [1   1   1   1   1   000];      % the maximum fractional contribution of each end-member to the normalization ion (typically 1, unless secondary mineral formation is in inversion)     
    ListNormClosure              = {'Na','Mg','Ca','Na','Mg','Mg'};           % the variable for each end-member that will be calculated by mass balance to ensure internal consistency     
    ListChargeClosure            = {};                         % the variable for each end-member that will be calculated by charge balance to ensure internal consistency 
    EMUnits                      = 'conc';                     % whether the end-member chemistry is given as concentration or charge-equivalent. options are: 'conc', 'equi'
    EMsources                    = {'prec','bslt','carb','flsc','umfc'};            % end-members that count as sources of dissolved constituents (typically rocks and other solute sources)
    EMsinks                      = {'clay'};                   % end-members that count as sinks of dissolved constituents (clays and other secondary phases)        
    EndMembersWithNegativeRatios = {};                         % end-members with negative chemical ratios    
    CoupleFeS2SO4intoEM          = {};                         % list of end-members where SO4 ratios represent pyrite
    CoupleFeS2d34SintoEM         = {};                         % list of end-members where SO4 d34S values represent pyrite
    RecordFullFeS2Distribution   = 0;                          % whether to record the full distribution of calculated FeS2 values, when d34S is not included in the inversion
    BalanceEvaporite             = 0;                          % whether evaporite SO4 = Ca+Mg+Sr and Cl = Na+K.    
  % group 4/5, Cl correction - 2 variables
    PrecProcessing               = 'EndMember';                % whether Cl should be treated as a common ion ('EndMember') or if there are Cl critical values ('ClCrit'). options are: 'EndMember', 'ClCrit'                            
    ClCriticalValuesGiven        = 1;                          % whether Cl critical values are given. if PrecProcessing is 'ClCrit' and ClCriticalValuesGiven is 1, those ClCritical values are used. if PrecProcessing is 'ClCrit' and ClCriticalValuesGiven is 0, 100% of river Cl is used.        
  % group 5/5, calculation of RZWYC - 8 variables
    CalculateRZCWY               = 0;                          % whether model should attempt to calculate R, Z, C, W, and Y. options are: 0 or 1
    R_Numerator_EMList           = {};                         % end-members that should contribute to the numerator of R
    R_Numerator_IonList          = {};                         % ions that should contribute to the numerator of R        
    Z_NumeratorType              = {};                         % how the numerator of Z (SO4 from FeS2) should be calculated. options are: 'ZfromEM', 'ZfromSO4excess', 'ZfromriverSO4', 'Znotcalculated'
    Z_Numerator_EMList           = {};                         % end-members that should contribute to the numerator of Z (only used if Z_NumeratorType = {'ZfromEM'}).   
    C_Numerator_EMList           = {};                         % End-member that should contribute to the numerator of C
    RZC_Denominator_EMList       = {};                         % end-members that should contribute to the denominator of R, Z, and C (weathering end-members)
    RZC_Denominator_IonList      = {};                         % ions that should contribute to the denominator of R, Z, and C. we recommend including Na and K.                            


%% Scenario 2: Alternative scenario to test for sensitivity of the model to the clay endmember (No Si and clay)
elseif isequal(ScenarioList{ScenarioListIndex},'Zam_CaMgNaClSiSr')     
  % group 1/5, river observations - 12 variables
    Riverdatasource              = 'IndividualReRuns';       % Data name for the source of the river observations
    AdjustRiverObs               = 0;                          % whether river measurements should be adjusted to reflect analytical uncertainty. options are: 0 or 1
    ObsList                      = {'Ca', 'Mg', 'Na', 'Cl','Sr','Sr8786'}; % list of elements, ions, and isotopic ratios to include in the inversion
    CostFunType                  = {'rel','rel','rel','rel','rel','rel'};  % whether each variable should be evaluated as proportional cost or absolute cost. options are 'rel' and 'abs'.
    WeightingList                = [1   1   1   1   1   1];   % weighting term for the cost function                    
    ErrorCutMinMB                = [85   85   85   85   85   -0.002];  % if IterateOver is "Samples", these are the bounds of mass balance that will be accepted for an inversion result  
    ErrorCutMaxMB                = [115   115   115   115   115   0.002];   % if IterateOver is "Samples", these are the bounds of mass balance that will be accepted for an inversion result  
    nCFList                      = {};                         % list of dissolved variables (in ObsList) to not include in the cost function evaluation
    ConvertDelta2RList           = {};                         % list of isotopic variables (in delta notation) to be converted to isotopic ratios for the analysis (results are converted back to delta)
    AllIonsExplicitlyResolved    =  0;                         % Indicate if all cations and anions (all sources of charge) are resolved. options are: 0 or 1    
    ObsInNormalization           = {'Ca','Mg','Na'};           % list of variables included in the normalization
    ImposeNormalizationCheck     = 1;                          % whether the normalization should be reproduced to the minimum and maximum values for non-isotopic variables 
  % group 2/5, general settings - 8 variables
    Solver                       = 'mldivide_optimize';        % type of inversion solution, options are: 'mldivide', 'lsqnonneg', 'mldivide_optimize', 'lsqnonneg_optimize', 'optimize'. enter as string, not a cell.
    IterateOver                  = 'Samples';                  % whether to apply the same end-members to all sample ('End-members'), or different end-members to each sample ('Sample'). options are: 'End-members', 'Samples'
    maxiterations                = 3000000;                     % if IterateOver equals "Samples", this is the maximum number of inversion attempts 
    maxsuccess                   = 400;                        % if IterateOver is "Samples", this is the desired number of successes      
    numberiterations             = NaN;                        % if IterateOver equals "End-members", this is the number of inversions to perform
    MisfitCuts                   = NaN;                        % if IterateOver equals "End-members", this percentage of simulations with lowest misfit between model result and data will be kept    
    CullOn                       = 'NaN';                      % if IterateOver is "End-members", this must be either 'EachSample' or 'AllSample' and describes HOW to cull the data
    saveuncutdata                = 0;                          % if 1, saves all the simulation data (results in very large files)    
  % group 3/5, end-members - 14 variables
    EMdatasource                 = 'CaMgNaClSiSr_initial';       % the name of the end-member group (the entry on column A of the spreadsheet containing end-member information). 
    EMList0                      = {'prec','bslt','carb','flsc','umfc'};     % list of the end-members to use in the inversion (row 2 of spreadsheet containing end-member information).     
    MinFractionalContribution    = [000   000   000   000   000];      % the minumum fractional contribution of each end-member to the normalization ion (typically 0, unless secondary mineral formation is in inversion)
    MaxFractionalContribution    = [1   1   1   1   1];      % the maximum fractional contribution of each end-member to the normalization ion (typically 1, unless secondary mineral formation is in inversion)     
    ListNormClosure              = {'Na','Mg','Ca','Na','Mg'};           % the variable for each end-member that will be calculated by mass balance to ensure internal consistency     
    ListChargeClosure            = {};                         % the variable for each end-member that will be calculated by charge balance to ensure internal consistency 
    EMUnits                      = 'conc';                     % whether the end-member chemistry is given as concentration or charge-equivalent. options are: 'conc', 'equi'
    EMsources                    = {'prec','bslt','carb','flsc','umfc'};            % end-members that count as sources of dissolved constituents (typically rocks and other solute sources)
    EMsinks                      = {};                   % end-members that count as sinks of dissolved constituents (clays and other secondary phases)        
    EndMembersWithNegativeRatios = {};                         % end-members with negative chemical ratios    
    CoupleFeS2SO4intoEM          = {};                         % list of end-members where SO4 ratios represent pyrite
    CoupleFeS2d34SintoEM         = {};                         % list of end-members where SO4 d34S values represent pyrite
    RecordFullFeS2Distribution   = 0;                          % whether to record the full distribution of calculated FeS2 values, when d34S is not included in the inversion
    BalanceEvaporite             = 0;                          % whether evaporite SO4 = Ca+Mg+Sr and Cl = Na+K.    
  % group 4/5, Cl correction - 2 variables
    PrecProcessing               = 'EndMember';                % whether Cl should be treated as a common ion ('EndMember') or if there are Cl critical values ('ClCrit'). options are: 'EndMember', 'ClCrit'                            
    ClCriticalValuesGiven        = 1;                          % whether Cl critical values are given. if PrecProcessing is 'ClCrit' and ClCriticalValuesGiven is 1, those ClCritical values are used. if PrecProcessing is 'ClCrit' and ClCriticalValuesGiven is 0, 100% of river Cl is used.        
  % group 5/5, calculation of RZWYC - 8 variables
    CalculateRZCWY               = 0;                          % whether model should attempt to calculate R, Z, C, W, and Y. options are: 0 or 1
    R_Numerator_EMList           = {};                         % end-members that should contribute to the numerator of R
    R_Numerator_IonList          = {};                         % ions that should contribute to the numerator of R        
    Z_NumeratorType              = {};                         % how the numerator of Z (SO4 from FeS2) should be calculated. options are: 'ZfromEM', 'ZfromSO4excess', 'ZfromriverSO4', 'Znotcalculated'
    Z_Numerator_EMList           = {};                         % end-members that should contribute to the numerator of Z (only used if Z_NumeratorType = {'ZfromEM'}).   
    C_Numerator_EMList           = {};                         % End-member that should contribute to the numerator of C
    RZC_Denominator_EMList       = {};                         % end-members that should contribute to the denominator of R, Z, and C (weathering end-members)
    RZC_Denominator_IonList      = {};                         % ions that should contribute to the denominator of R, Z, and C. we recommend including Na and K.        


%% Scenario 3: Alternative scenario to test for sensitivity of the model to strontium (essentially majors only, No Sr and Sr8786)
elseif isequal(ScenarioList{ScenarioListIndex},'Zam_CaMgNaClSiSr')     
  % group 1/5, river observations - 12 variables
    Riverdatasource              = 'IndividualReRuns';       % Data name for the source of the river observations
    AdjustRiverObs               = 0;                          % whether river measurements should be adjusted to reflect analytical uncertainty. options are: 0 or 1
    ObsList                      = {'Ca', 'Mg', 'Na', 'Cl','Si'}; % list of elements, ions, and isotopic ratios to include in the inversion
    CostFunType                  = {'rel','rel','rel','rel','rel'};  % whether each variable should be evaluated as proportional cost or absolute cost. options are 'rel' and 'abs'.
    WeightingList                = [1   1   1   1   1];   % weighting term for the cost function                    
    ErrorCutMinMB                = [85   85   85   85   85];  % if IterateOver is "Samples", these are the bounds of mass balance that will be accepted for an inversion result  
    ErrorCutMaxMB                = [115   115   115   115   115];   % if IterateOver is "Samples", these are the bounds of mass balance that will be accepted for an inversion result  
    nCFList                      = {};                         % list of dissolved variables (in ObsList) to not include in the cost function evaluation
    ConvertDelta2RList           = {};                         % list of isotopic variables (in delta notation) to be converted to isotopic ratios for the analysis (results are converted back to delta)
    AllIonsExplicitlyResolved    =  0;                         % Indicate if all cations and anions (all sources of charge) are resolved. options are: 0 or 1    
    ObsInNormalization           = {'Ca','Mg','Na'};           % list of variables included in the normalization
    ImposeNormalizationCheck     = 1;                          % whether the normalization should be reproduced to the minimum and maximum values for non-isotopic variables 
  % group 2/5, general settings - 8 variables
    Solver                       = 'mldivide_optimize';        % type of inversion solution, options are: 'mldivide', 'lsqnonneg', 'mldivide_optimize', 'lsqnonneg_optimize', 'optimize'. enter as string, not a cell.
    IterateOver                  = 'Samples';                  % whether to apply the same end-members to all sample ('End-members'), or different end-members to each sample ('Sample'). options are: 'End-members', 'Samples'
    maxiterations                = 3000000;                     % if IterateOver equals "Samples", this is the maximum number of inversion attempts 
    maxsuccess                   = 400;                        % if IterateOver is "Samples", this is the desired number of successes      
    numberiterations             = NaN;                        % if IterateOver equals "End-members", this is the number of inversions to perform
    MisfitCuts                   = NaN;                        % if IterateOver equals "End-members", this percentage of simulations with lowest misfit between model result and data will be kept    
    CullOn                       = 'NaN';                      % if IterateOver is "End-members", this must be either 'EachSample' or 'AllSample' and describes HOW to cull the data
    saveuncutdata                = 0;                          % if 1, saves all the simulation data (results in very large files)    
  % group 3/5, end-members - 14 variables
    EMdatasource                 = 'CaMgNaClSiSr_initial';       % the name of the end-member group (the entry on column A of the spreadsheet containing end-member information). 
    EMList0                      = {'prec','bslt','carb','flsc','umfc','clay'};     % list of the end-members to use in the inversion (row 2 of spreadsheet containing end-member information).     
    MinFractionalContribution    = [000   000   000   000   000   -1];      % the minumum fractional contribution of each end-member to the normalization ion (typically 0, unless secondary mineral formation is in inversion)
    MaxFractionalContribution    = [1   1   1   1   1   000];      % the maximum fractional contribution of each end-member to the normalization ion (typically 1, unless secondary mineral formation is in inversion)     
    ListNormClosure              = {'Na','Mg','Ca','Na','Mg','Mg'};           % the variable for each end-member that will be calculated by mass balance to ensure internal consistency     
    ListChargeClosure            = {};                         % the variable for each end-member that will be calculated by charge balance to ensure internal consistency 
    EMUnits                      = 'conc';                     % whether the end-member chemistry is given as concentration or charge-equivalent. options are: 'conc', 'equi'
    EMsources                    = {'prec','bslt','carb','flsc','umfc'};            % end-members that count as sources of dissolved constituents (typically rocks and other solute sources)
    EMsinks                      = {'clay'};                   % end-members that count as sinks of dissolved constituents (clays and other secondary phases)        
    EndMembersWithNegativeRatios = {};                         % end-members with negative chemical ratios    
    CoupleFeS2SO4intoEM          = {};                         % list of end-members where SO4 ratios represent pyrite
    CoupleFeS2d34SintoEM         = {};                         % list of end-members where SO4 d34S values represent pyrite
    RecordFullFeS2Distribution   = 0;                          % whether to record the full distribution of calculated FeS2 values, when d34S is not included in the inversion
    BalanceEvaporite             = 0;                          % whether evaporite SO4 = Ca+Mg+Sr and Cl = Na+K.    
  % group 4/5, Cl correction - 2 variables
    PrecProcessing               = 'EndMember';                % whether Cl should be treated as a common ion ('EndMember') or if there are Cl critical values ('ClCrit'). options are: 'EndMember', 'ClCrit'                            
    ClCriticalValuesGiven        = 1;                          % whether Cl critical values are given. if PrecProcessing is 'ClCrit' and ClCriticalValuesGiven is 1, those ClCritical values are used. if PrecProcessing is 'ClCrit' and ClCriticalValuesGiven is 0, 100% of river Cl is used.        
  % group 5/5, calculation of RZWYC - 8 variables
    CalculateRZCWY               = 0;                          % whether model should attempt to calculate R, Z, C, W, and Y. options are: 0 or 1
    R_Numerator_EMList           = {};                         % end-members that should contribute to the numerator of R
    R_Numerator_IonList          = {};                         % ions that should contribute to the numerator of R        
    Z_NumeratorType              = {};                         % how the numerator of Z (SO4 from FeS2) should be calculated. options are: 'ZfromEM', 'ZfromSO4excess', 'ZfromriverSO4', 'Znotcalculated'
    Z_Numerator_EMList           = {};                         % end-members that should contribute to the numerator of Z (only used if Z_NumeratorType = {'ZfromEM'}).   
    C_Numerator_EMList           = {};                         % End-member that should contribute to the numerator of C
    RZC_Denominator_EMList       = {};                         % end-members that should contribute to the denominator of R, Z, and C (weathering end-members)
    RZC_Denominator_IonList      = {};                         % ions that should contribute to the denominator of R, Z, and C. we recommend including Na and K.          


