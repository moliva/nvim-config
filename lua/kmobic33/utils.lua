local M = {}


-- Copies the contents of thte current table to a new one
M.copy_table = function(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in pairs(orig) do
      copy[orig_key] = orig_value
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end


--- Dumps the content of a given table into a string
M.dump = function(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. M.dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

--- Returns the file extension for a given string, e.g. /Users/myuser/myfile.txt -> .txt
M.get_file_extension = function(url)
  return url:match("^.+(%..+)$")
end

--- Given a `criterion` function receiving a key and value and returning a boolean and a table `tab`, returns the index of the first item in the table that matches the criterion.
M.find_index = function(criterion, tab)
  for k, v in ipairs(tab) do
    if criterion(k, v) then
      return k
    end
  end

  return nil
end

return M
