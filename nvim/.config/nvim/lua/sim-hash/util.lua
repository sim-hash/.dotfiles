local M = {}

function M.remap(mode, rhs, lhs, bufopts, desc)
  if bufopts == nil then
    bufopts = {}
  end
  bufopts.desc = desc
  vim.keymap.set(mode, rhs, lhs, bufopts)
end

function M.map(mode, rhs, lhs, bufopts, desc)
  if bufopts == nil then
    bufopts = {}
  end
  bufopts.desc = desc
  vim.keymap.set(mode, rhs, lhs, bufopts)
end

function M.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end



--function dump(o)
--   if type(o) == 'table' then
--      local s = '{ '
--      for k,v in pairs(o) do
--         if type(k) ~= 'number' then k = '"'..k..'"' end
--         s = s .. '['..k..'] = ' .. dump(v) .. ','
--      end
--      return s .. '} '
--   else
--      return tostring(o)
--   end
--end


return M
