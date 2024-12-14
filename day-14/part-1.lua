-- Day 14 - Part 1

local params = {...}
local day    = '14'
local part   = '1'

local areas = {
  test = { cols = 11,  rows = 7   },
  real = { cols = 101, rows = 103 }
}

function run(input, area)
  local robots    = {}
  local seconds   = 100
  local mid_col   = (area.cols - 1) / 2
  local mid_row   = (area.rows - 1) / 2
  local quadrants = { tr = 0, tl = 0, br = 0, bl = 0}

  do -- create robots
    for line in input:lines() do
      local robot = { p = {}, v = {} }

      robot.p.col = tonumber(line:match('p=(%d+),'))
      robot.p.row = tonumber(line:match('p=%d+,(%d+)'))
      robot.v.col = tonumber(line:match('v=(-?%d+),'))
      robot.v.row = tonumber(line:match('v=.+,(-?%d+)'))

      table.insert(robots, robot)
    end
  end

  do -- predict positions and quadrants in x seconds
    for _, robot in ipairs(robots) do
      local final_col = (robot.p.col + (robot.v.col * seconds)) % area.cols
      local final_row = (robot.p.row + (robot.v.row * seconds)) % area.rows

      if final_row ~= mid_row and final_col ~= mid_col then
        local q_key = ''
          .. (final_row < mid_row and 't' or '')
          .. (final_row > mid_row and 'b' or '')
          .. (final_col < mid_col and 'l' or '')
          .. (final_col > mid_col and 'r' or '')

        quadrants[q_key] = quadrants[q_key] + 1
      end
    end
  end

  return quadrants.tl * quadrants.tr * quadrants.bl * quadrants.br
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

local area   = params[1] == 'test' and areas.test or areas.real
local result = run(load_input_file(), area)
print('Result: ' .. result)
