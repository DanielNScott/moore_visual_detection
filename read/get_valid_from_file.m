function [valid_msk, valid_trls] = get_valid_from_file(ps, dqual)

% Get the session info
[id, year, month, day] = parse_date_image(ps.fname);

% Get mouse_num for dqual indexing
ind1 = find(dqual.ids == id);

% Get date_num for dqual indexing
ind2 = find(all(dqual.date_array == [id, year, month, day],2));

% Get valid data mask
valid_msk  =      dqual.mouse{ind1}.valid{ind2}.msk;
valid_trls = find(dqual.mouse{ind1}.valid{ind2}.msk);

end