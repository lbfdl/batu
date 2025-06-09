function plotMCPotts(fig1, fig2, fig3, fig4, MCS, conf, ener, acc, rex)
    % Save figures to output directory

    if ~exist('output', 'dir')
        mkdir('output');
    end

    % Save configuration figure
    if conf
        file_name_configuration = ['configuration_', num2str(MCS), '.png'];
        filepath_configuration = fullfile('output', file_name_configuration);
        exportgraphics(fig1, filepath_configuration);
    end

    % Save energy figure
    if ener
        file_name_energy = ['energy_', num2str(MCS), '.png'];
        filepath_energy = fullfile('output', file_name_energy);
        exportgraphics(fig2, filepath_energy);
    end

    % Save percent acceptance figure
    if acc
        file_name_acc = ['acc_', num2str(MCS), '.png'];
        filepath_acc = fullfile('output', file_name_acc);
        exportgraphics(fig3, filepath_acc);
    end

    % Save percent recrystallization figure
    if rex
        file_name_acc = ['rex_', num2str(MCS), '.png'];
        filepath_acc = fullfile('output', file_name_acc);
        exportgraphics(fig4, filepath_acc);
    end

end
