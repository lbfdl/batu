function [s, MCS, n, q, pacc, prex, time, strain_energy, temperature, E0, totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, total_en, grain_boundary_en, strain_en] = loadMCPotts(MCS, new_strain_energy, new_temperature, new_E0)
    % Load Monte Carlo Potts model state from file

    % Check if the file exists
    filename = sprintf('MCPotts_%d.mat', MCS);
    
    if ~exist(filename, 'file')
        error('File %s does not exist.', filename);
    end

    % Load the variables from the file
    load(filename, 's', 'MCS', 'n', 'q', 'pacc', 'prex', 'time', 'strain_energy', 'temperature', 'E0', 'totalEnergyArr', 'grainBoundaryEnergyArr', 'strainEnergyArr', 'total_en', 'grain_boundary_en', 'strain_en');

    % Update parameters if new values are provided
    if nargin > 1 && ~isempty(new_strain_energy)
        strain_energy = new_strain_energy;
    end
    if nargin > 2 && ~isempty(new_temperature)
        temperature = new_temperature;
    end
    if nargin > 3 && ~isempty(new_E0)
        E0 = new_E0;
    end

    % Recalculate strain energy if it has changed
    if nargin > 1 && ~isempty(new_strain_energy)
        strain_en = 0;
        for i = 1:n
            for j = 1:n
                strain_en = strain_en + strainEnergyAssign(s, i, j, 1, new_strain_energy, []);
            end
        end
        total_en = grain_boundary_en + strain_en;
    end

    fprintf('Loaded state from MCS = %d\n', MCS);

end
