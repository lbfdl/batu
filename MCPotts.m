% Monte Carlo simulation for 2D Potts model
% This function performs Monte Carlo simulations for a 2D Potts model, which
% is a lattice-based model used to study grain growth.
%
% Inputs:
% - nstep: Number of Monte Carlo steps (MCS) to perform.
% - MCS (optional): Monte Carlo Step to continue run from. Default is 0.
% - n (optional): Size of the lattice (n x n). Default is 40.
% - q (optional): The range of possible spin values (1 to q). Default is 4.
% - strain_energy (optional): Strain energy value (Es). Default is 0 J/mol.
% - temperature (optional): Temperature value. Default is 0 K.
% - E0 (optional): Grain boundary energy value (Egb). Default is 1000 J/mol.
%
% Outputs:
% - totalEnergyArr: Array of total energy at each MCS.
% - grainBoundaryEnergyArr: Array of grain boundary energy at each MCS.
% - strainEnergyArr: Array of strain energy at each MCS.
% - s: Final configuration of the lattice.
% - time: Elapsed time for the simulation at each MCS.
% - pacc: Array of acceptance percentages at each MCS.
% - prex: Array of recrystallization percentages at each MCS.
% - energyChange: Percentage error in the final energy (a test to ensure correctness).

function [totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, s, time, pacc, prex, energyChange] = MCPotts(nstep, varargin)

    rng('shuffle');

    % Parse the input parameters
    p = inputParser;
    errorMsgScalarPosNum = 'Value must be a scalar.';
    validScalarPosNum = @(x) assert(isnumeric(x) && isscalar(x) && (x >= 0), errorMsgScalarPosNum);

    addRequired(p, 'nstep', validScalarPosNum);
    addOptional(p, 'MCS', 0, validScalarPosNum);
    addOptional(p, 'n', 40, validScalarPosNum);
    addOptional(p, 'q', 4, validScalarPosNum);
    addOptional(p, 'strain_energy', 0, validScalarPosNum);
    addOptional(p, 'temperature', 0, validScalarPosNum);
    addOptional(p, 'E0', 1000, validScalarPosNum);
    parse(p, nstep, varargin{:});

    % Check if restarting from a previous run
    if p.Results.MCS
        [s, MCS, n, q, pacc, prex, time, strain_energy, temperature, E0, totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, total_en, grain_boundary_en, strain_en] = loadMCPotts(p.Results.MCS, p.Results.strain_energy, p.Results.temperature, p.Results.E0);
        N = n * n;
        nconfig = N * p.Results.nstep;
    else
        [s, MCS, n, q, pacc, prex, time, N, nconfig, strain_energy, temperature, E0, totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, total_en, grain_boundary_en, strain_en] = initMCPotts(p.Results.n, p.Results.nstep, p.Results.q, p.Results.strain_energy, p.Results.temperature, p.Results.E0);
    end

    % Perform Monte Carlo simulation
    [totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, s, time] = runMCPotts(s, MCS, n, q, pacc, prex, time, N, nconfig, temperature, E0, strain_energy, totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, total_en, grain_boundary_en, strain_en);

    % Test the final energy to ensure accurate updates
    energyChange = testMCPotts(n, s, E0, totalEnergyArr(end), strain_energy);

end
