WK = require("which-key")

function WK_register(prefix, mapping, opts)
  WK.register({ [prefix] = mapping }, opts)
end

function WK_register_leader(prefix, mapping, opts)
  WK_register("<leader>", { [prefix] = mapping }, opts);
end

function WK_register_dleader(prefix, mapping, opts)
  WK_register_leader("<leader>", { [prefix] = mapping }, opts);
end
