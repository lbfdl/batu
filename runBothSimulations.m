% Script to run both simulations as requested
% Assumes you have already run: MCPotts(300, 0, 50, 5, 0, 0, 1);

clear; clc;

% Set parameters
nstep = 500;        % Number of Monte Carlo sweeps
MCS_start = 300;    % Starting from the saved state
n = 50;             % System size
q = 5;              % Number of spin orientations
temperature = 0;    % Temperature (K)
E0 = 1;             % Grain boundary energy
seed = 12345;       % Random seed for reproducibility

fprintf('Running Monte Carlo Potts simulations...\n');
fprintf('Starting from saved state at MCS = %d\n', MCS_start);

%% Case 1: Uniform strain energy (Es = 4)
fprintf('\n=== Case 1: Uniform Strain Energy (Es = 4) ===\n');

try
    [totalEnergyArr1, grainBoundaryEnergyArr1, strainEnergyArr1, s1, time1, pacc1, prex1, energyChange1] = MCPotts(nstep, MCS_start, n, q, 4, temperature, E0);
    
    fprintf('Case 1 completed successfully!\n');
    fprintf('Final energy error: %.4f%%\n', energyChange1);
    
    % Save results for Case 1
    save('Case1_UniformStrainEnergy.mat', 'totalEnergyArr1', 'grainBoundaryEnergyArr1', 'strainEnergyArr1', 's1', 'time1', 'pacc1', 'prex1', 'energyChange1');
    
catch ME
    fprintf('Error in Case 1: %s\n', ME.message);
end

%% Case 2: Heterogeneous strain energy (Es = 2, 4, or 6)
fprintf('\n=== Case 2: Heterogeneous Strain Energy (Es = 2, 4, 6) ===\n');

try
    [totalEnergyArr2, grainBoundaryEnergyArr2, strainEnergyArr2, s2, time2, pacc2, prex2, energyChange2] = MCPottsHeterogeneous(nstep, MCS_start, n, q, temperature, E0, seed);
    
    fprintf('Case 2 completed successfully!\n');
    fprintf('Final energy error: %.4f%%\n', energyChange2);
    
    % Save results for Case 2
    save('Case2_HeterogeneousStrainEnergy.mat', 'totalEnergyArr2', 'grainBoundaryEnergyArr2', 'strainEnergyArr2', 's2', 'time2', 'pacc2', 'prex2', 'energyChange2');
    
catch ME
    fprintf('Error in Case 2: %s\n', ME.message);
end

fprintf('\n=== Simulation Summary ===\n');
fprintf('Both simulations completed!\n');
fprintf('Results saved to:\n');
fprintf('  - Case1_UniformStrainEnergy.mat\n');
fprintf('  - Case2_HeterogeneousStrainEnergy.mat\n');
fprintf('\nPlots and intermediate snapshots are automatically generated during simulation.\n');
fprintf('Check the figures for grain structure evolution.\n'); 