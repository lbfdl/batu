function strain_energy_map = generateStrainEnergyMap(s, n, seed)
    % Generate heterogeneous strain energy map
    % Randomly assigns Es = 2, 4, or 6 to each cell
    % Cells with spin = 1 will have Es = 0 (handled in strainEnergyAssign)
    
    if nargin > 2
        rng(seed); % Set random seed for reproducibility
    end
    
    % Create strain energy values: 2, 4, or 6
    strain_values = [2, 4, 6];
    
    % Generate random strain energy map
    strain_energy_map = zeros(n, n);
    for i = 1:n
        for j = 1:n
            % Only assign strain energy to non-recrystallized grains (s ~= 1)
            if s(i, j) ~= 1
                strain_energy_map(i, j) = strain_values(randi(3));
            end
        end
    end
    
end 