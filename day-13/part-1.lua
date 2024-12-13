-- Day 13 - Part 1

local params = {...}
local day    = '13'
local part   = '1'

function run(input)
  local sum = 0
  local machines = {}

  do
    local i = 1
    machines[i] = {}

    for line in input:lines() do
      if line == '' then
        i = i + 1
        machines[i] = {}
      else
        if string.match(line, 'Button A:') then
          machines[i].ax = tonumber(string.match(line, 'X%+(%d+)'))
          machines[i].ay = tonumber(string.match(line, 'Y%+(%d+)'))
        elseif string.match(line, 'Button B:') then
          machines[i].bx = tonumber(string.match(line, 'X%+(%d+)'))
          machines[i].by = tonumber(string.match(line, 'Y%+(%d+)'))
        else
          machines[i].px = tonumber(string.match(line, 'X=(%d+)'))
          machines[i].py = tonumber(string.match(line, 'Y=(%d+)'))
        end
      end
    end
  end

  for _, m in ipairs(machines) do
    local a = (m.by * m.px - m.bx * m.py) / (m.by * m.ax - m.bx * m.ay)
    local b = (m.ay * m.px - m.ax * m.py) / (m.ay * m.bx - m.ax * m.by)

    if a == math.floor(a) and b == math.floor(b) then
      sum = sum + (a * 3) + (b * 1)
    end
  end

  return math.floor(sum)
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
