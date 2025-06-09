function energyChange = testMCPotts(n, s, E0, total_energy, strain_energy)
    % Calculate the percentage error in the final energy to ensure accurate updates

    % Initialize energy test variables
    grain_boundary_energy_test = 0;
    strain_energy_test = 0;

    % Iterate over each lattice site
    for i = 1:n

        for j = 1:n
            % Obtain spin value at current site
            sij = s(i, j);

            % Calculate the energy contribution at current site
            sig = calculateEnergy(sij, s, n, i, j);

            % Accumulate the energy contribution from current site
            grain_boundary_energy_test = grain_boundary_energy_test + E0 * (8 - sig) / 2;

            % Check for strain energy
            if sij ~= 1
                strain_energy_test = strain_energy_test + strain_energy;
            end

        end

    end

    % Add strain energy to the total energy
    total_energy_test = grain_boundary_energy_test + strain_energy_test;

    % Calculate the energy change percentage
    energyChange = (total_energy - total_energy_test) / total_energy_test;
end
