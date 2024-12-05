-- Day 05 - Part 1

local params = {...}
local day    = '05'
local part   = '1'

function run(input)
  local sum     = 0
  local rules   = {}
  local updates = {}

  for line in input:lines() do
    if line ~= '' then
      if string.find(line, '|') == nil then
        local update = {}

        for number in string.gmatch(line, '%d+') do
          table.insert(update, number)
        end

        table.insert(updates, update)
      else
        local before, after = string.match(line, '(%d+)|(%d+)')

        rules[tostring(before .. '|' .. after)] = true
        rules[tostring(after .. '|' .. before)] = false
      end
    end
  end

  local function validate_update_order(update, rules)
    for i, number in ipairs(update) do
      for j = i + 1, #update do
        local right_order_key = tostring(number .. '|' .. update[j])

        if rules[right_order_key] == false then
          return false
        end
      end
    end

    return true
  end

  for _, update in ipairs(updates) do
    if validate_update_order(update, rules) then
      local middle_index = (#update + 1) / 2

      sum = sum + update[middle_index]
    end
  end

  return sum
end

function load_input_file()
  -- current script path, because input files are relative to it
  local script_path = debug.getinfo(1,"S").source:sub(2):match("(.*/)") or ''
  local filename = 'part-1.txt'

  if params[1] == 'test' then
    filename = 'part-1-test.txt'
  end

  return io.open(script_path .. 'input/' .. filename, 'r')
end

print('Day ' .. day .. ' - part ' .. part)
print('-----------------\n')

local result = run(load_input_file())
print('Result: ' .. result)
