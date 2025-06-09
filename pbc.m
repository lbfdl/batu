function i = pbc(i, n)
    % Apply periodic boundary condition to index i

    i = i - n * floor((i - 1) / n);
end
