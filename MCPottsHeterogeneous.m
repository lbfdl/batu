function [totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, s, time, pacc, prex, energyChange] = MCPottsHeterogeneous(nstep, MCS_start, n, q, temperature, E0, seed)
    % Monte Carlo Potts model with heterogeneous strain energy
    % This function runs a simulation with heterogeneous strain energy (Es = 2, 4, or 6)
    

    % Initialize the random number generator only once
    if exist('seed','var') && ~isempty(seed)
        rng(seed);
    else
        rng('shuffle');
    end
    
    % Load the initial state from the previous run
    [s, MCS, n, q, pacc, prex, time, strain_energy, temperature, E0, totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, total_en, grain_boundary_en, strain_en] = loadMCPotts(MCS_start, 0, temperature, E0);
    
    % Generate heterogeneous strain energy map
    strain_energy_map = generateStrainEnergyMap(s, n, seed);
    
    % Recalculate initial strain energy with the new map
    strain_en = 0;
    for i = 1:n
        for j = 1:n
            strain_en = strain_en + strainEnergyAssign(s, i, j, 1, 0, strain_energy_map);
        end
    end
    
    total_en = grain_boundary_en + strain_en;
    
    N = n * n;
    nconfig = N * nstep;
    
    % Update arrays if continuing from previous run
    if MCS > 0
        strainEnergyArr(MCS) = strain_en;
        totalEnergyArr(MCS) = total_en;
    end
    
    % Perform Monte Carlo simulation with heterogeneous strain energy
    [totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, s, time] = runMCPottsHeterogeneous(s, MCS, n, q, pacc, prex, time, N, nconfig, temperature, E0, strain_energy_map, totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, total_en, grain_boundary_en, strain_en);
    
    % Test the final energy to ensure accurate updates
    energyChange = testMCPottsHeterogeneous(n, s, E0, totalEnergyArr(end), strain_energy_map);
    
end 