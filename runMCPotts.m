function [totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, s, time] = runMCPotts(s, MCS, n, q, pacc, prex, time, N, nconfig, temperature, E0, strain_energy, totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, total_en, grain_boundary_en, strain_en)
% Perform Monte Carlo steps

fig1 = figure(1);
ax1 = axes;
fig2 = figure(2);
ax2 = axes;
fig3 = figure(3);
ax3 = axes;

if strain_energy
    fig4 = figure(4);
    ax4 = axes;
else
    fig4 = 0; ax4 = 0;
end

set(groot, 'defaultLineLineWidth', 2);
set(groot, 'DefaultAxesFontSize', 18);
set(groot, 'DefaultAxesLineWidth', 2);

acc = 0;
R = 8.3144598;

if MCS == 0
    imagesc(ax1, s);

    if strain_energy
        load('customColormap.mat', 'CustomColormap');
        colormap(ax1, CustomColormap);
    else
        colormap(ax1, "gray");
    end

    axis(ax1, 'equal', 'off'); yticks(ax1, []); xticks(ax1, []);
    plotMCPotts(fig1, fig2, fig3, fig4, 0, true, false, false, false);
    disp('Initial state saved!');

end

for k = 1:nconfig

    % Start stopwatch timer
    tic;

    % Pick a site to change
    i = ceil(rand * n);
    j = ceil(rand * n);

    % Flip the spin and calculate energy change
    sijo = s(i, j);
    sij = sijo;

    sij = sij + ceil((q - 1) * rand);
    sij = sij - q * floor((sij - 1) / q);

    while strain_energy && sij == 1
        sij = sij + ceil((q - 1) * rand);
        sij = sij - q * floor((sij - 1) / q);
    end

    sign = calculateEnergy(sij, s, n, i, j);
    sigo = calculateEnergy(sijo, s, n, i, j);
    esn = double(sij ~= 1) * strain_energy;
    eso = double(sijo ~= 1) * strain_energy;

    del =- (sign - sigo) * E0;
    del_es = esn - eso;

    % Metropolis algorithm
    if temperature

        if del + del_es <= 0 || exp(- (del + del_es) / (R * temperature)) < rand
            s(i, j) = sij;
            grain_boundary_en = grain_boundary_en + del;
            strain_en = strain_en + del_es;
            total_en = grain_boundary_en + strain_en;
            acc = acc + 1;
        end

    elseif del + del_es <= 0
        s(i, j) = sij;
        grain_boundary_en = grain_boundary_en + del;
        strain_en = strain_en + del_es;
        total_en = grain_boundary_en + strain_en;
        acc = acc + 1;
    end

    % Every MCS add energy to the list
    if mod(k, N) == 0
        MCS = MCS + 1;
        grainBoundaryEnergyArr(MCS) = grain_boundary_en;
        strainEnergyArr(MCS) = strain_en;
        totalEnergyArr(MCS) = total_en;
        pacc(MCS) = 100 * acc / N;

        if strain_energy
            prex(MCS) = 100 * sum(s(:) == 1) / N;
        end

        % Stop stopwatch timer
        time(MCS) = toc;

        % Plot the configuration
        imagesc(ax1, s);

        if strain_energy
            load('customColormap.mat', 'CustomColormap');
            colormap(ax1, CustomColormap);
        else
            colormap(ax1, "gray");
        end

        axis(ax1, 'equal', 'off'); yticks(ax1, []); xticks(ax1, []);

        x = 1:MCS;

        % Plot energy vs. MCS
        plot(ax2, x, totalEnergyArr, x, grainBoundaryEnergyArr, x, strainEnergyArr);
        xlabel(ax2, 'MCS'); ylabel(ax2, 'Energy (J/mol)'); legend(ax2, ({'Total Energy', 'Grain Boundary Energy', 'Strain Energy'}), 'AutoUpdate', 'off');
        drawnow

        % Plot percent acceptance vs. MCS
        plot(ax3, x, pacc); xlabel(ax3, 'MCS'); ylabel(ax3, 'Percent Acceptance');
        drawnow

        if strain_energy
            % Plot percent recrystallization vs. MCS
            plot(ax4, x, prex); xlabel(ax4, 'MCS'); ylabel(ax4, 'Percent Recrystallization');
            drawnow
        end

        % Save the current state every 100 MCS
        if mod(MCS, 100) == 0
            saveMCPotts(s, MCS, n, q, pacc, prex, time, strain_energy, temperature, E0, totalEnergyArr, grainBoundaryEnergyArr, strainEnergyArr, total_en, grain_boundary_en, strain_en);

            if strain_energy
                plotMCPotts(fig1, fig2, fig3, fig4, MCS, true, true, true, true);
            else
                plotMCPotts(fig1, fig2, fig3, fig4, MCS, true, true, true, false);
            end

            disp(['State saved at MCS = ', num2str(MCS), '!']);
        end

        acc = 0;
    end

end

end
