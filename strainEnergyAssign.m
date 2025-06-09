function [strainEnergy] = strainEnergyAssign(s, i, j, grainID, strain_energy, strain_energy_map)
    % Assign strain energy based on the spin value
    % If strain_energy_map is provided, use heterogeneous assignment
    % Otherwise, use uniform assignment
    
    if nargin < 6 || isempty(strain_energy_map)
        % Uniform strain energy assignment (original behavior)
        if s(i, j) ~= grainID
            strainEnergy = strain_energy;
        else
            strainEnergy = 0;
        end
    else
        % Heterogeneous strain energy assignment using the map
        if s(i, j) ~= grainID
            strainEnergy = strain_energy_map(i, j);
        else
            strainEnergy = 0;
        end
    end

end
