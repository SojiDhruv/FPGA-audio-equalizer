function output_mem(f, n, name)
    ext = ".coe";
    filepath = append(name, ext);
    file = fopen(filepath, 'w');

    if file == -1
        error('File could not be opened.');
    end

    fprintf(file, 'memory_initialization_radix = 10;\n');
    fprintf(file, 'memory_initialization_vector = ');
   
    f = f .* (2^15);
    f = round(f);

    for i = 1:n
        fprintf(file, ',\n%d', f(i));
    end

    fprintf(file, ';\n');
end