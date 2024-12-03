-- Day 03 - Part 2

local params = {...}
local day    = '03'
local part   = '2'

function run(input)
  local sum   = 0
  local donts = 0
  local text  = input:read("*all")

  text, donts = string.gsub(text, "don't%(%)", "⛔️")
  text        = string.gsub(text, "do%(%)",    "✅")

  for i = 1, donts, 1 do
    text = string.gsub(text, "⛔️[^✅]+(⛔️)", "%1")
    text = string.gsub(text, "⛔️[^✅]+(✅)", "%1")
  end

  text = string.gsub(text, "⛔️.+$", "")

  for instruction in string.gmatch(text, "mul%((%d+,%d+)%)") do
    local product = 1

    for number in string.gmatch(instruction, "(%d+)") do
      if #(tostring(number)) < 4 then
        product = product * number
      end
    end

    sum = sum + product
  end

  return sum
end

Helpers = {}

function load_input_file()
  -- current script path, because input files are relative to it
  local script_path = debug.getinfo(1,"S").source:sub(2):match("(.*/)") or ''
  local filename = 'part-1.txt'

  if params[1] == 'test' then
    filename = 'part-2-test.txt'
  end

  return io.open(script_path .. 'input/' .. filename, 'r')
end

print('Day ' .. day .. ' - part ' .. part)
print('-----------------\n')

local result = run(load_input_file())
print('Result: ' .. result)
