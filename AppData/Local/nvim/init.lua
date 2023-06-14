-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

function dump(InputObject)
  if type(InputObject) == "table" then
    local s = "{ "
    for k, v in pairs(InputObject) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(InputObject)
  end
end

require("nvim-treesitter.install").compilers = { "clang" }

print("Treesitter compilers:", dump(require("nvim-treesitter.install").compilers))
