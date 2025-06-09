function energyChange = testMCPottsHeterogeneous(n, s, E0, finalEnergy, strain_energy_map)
    % Test the final energy calculation for heterogeneous strain energy case
    
    total_en_calc = 0;
    grain_boundary_en_calc = 0;
    strain_en_calc = 0;

    % Calculate energies from scratch
    for i = 1:n
        for j = 1:n
            sij = s(i, j);
            sig = calculateEnergy(sij, s, n, i, j);
            grain_boundary_en_calc = grain_boundary_en_calc + E0 * (8 - sig) / 2;
            strain_en_calc = strain_en_calc + strainEnergyAssign(s, i, j, 1, 0, strain_energy_map);
        end
    end
    
    total_en_calc = grain_boundary_en_calc + strain_en_calc;
    
    % Calculate percentage error
    energyChange = 100 * abs(finalEnergy - total_en_calc) / abs(total_en_calc);
    
    fprintf('Final energy from simulation: %.2f J/mol\n', finalEnergy);
    fprintf('Calculated energy from scratch: %.2f J/mol\n', total_en_calc);
    fprintf('Energy error: %.4f%%\n', energyChange);
    
end 