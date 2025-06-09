function saveMCPotts(s, MCS, n, q, pacc, prex, time, strain_energy, temperature, E0, totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, total_en, grain_boundary_en, strain_en)
    % Save variables to a file named 'restart-(MCS).mat'

    if ~exist('output', 'dir')
        mkdir('output');
    end

    % Create file name and filepath
    file_name = ['restart_', num2str(MCS)];
    filepath = fullfile('output', file_name);

    % Save variables to the file
    save(filepath, 's', 'MCS', 'n', 'q', 'pacc', 'prex', 'time', 'strain_energy', 'temperature', 'E0', 'totalEnergyArr', 'grainBoundaryEnergyArr', 'strainEnergyArr', 'total_en', 'grain_boundary_en', 'strain_en');
end
