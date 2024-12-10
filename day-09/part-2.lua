-- Day 09 - Part 2

local params = {...}
local day    = '09'
local part   = '2'

function run(input)
  local sum    = 0
  local blocks = {}

  local DOT    = '.'
  local SPACE  = ' '

  do -- Parse line into array of blocks
    for line in input:lines() do
      local file_id = 0

      for index = 1, #line do
        local file_length = string.sub(line, index, index)
        local block = DOT

        if index % 2 ~= 0 then
          block   = file_id
          file_id = file_id + 1
        end

        for j = 1, file_length do
          table.insert(blocks, block)
        end
      end
    end
  end

  -- Helper functions
  local find_previous_file   = nil
  local find_next_empty_slot = nil
  local swap_file_and_slot   = nil

  find_previous_file = function(index)
    while blocks[index] == DOT do
      blocks[index] = SPACE
      index = index - 1
    end

    local file = { first = index, last  = index, size  = 1, value = blocks[index] }

    while index > 0 and blocks[index - 1] == file.value do
      index = index - 1
      file.first = index
      file.size  = file.size + 1
    end

    return file
  end

  find_next_empty_slot = function(index, file_size)
    local slot = nil

    while blocks[index] ~= DOT and index <= #blocks do
      index = index + 1
    end

    if index < #blocks then
      slot = { first = index, last  = index, size  = 1}

      while blocks[index + 1] == DOT do
        index = index + 1

        slot.last = slot.last + 1
        slot.size = slot.size + 1

        if slot.size == file_size then break end
      end

      if slot.size ~= file_size then
        return find_next_empty_slot(index + 1, file_size)
      end
    end

    return slot
  end

  swap_file_and_slot = function(file, slot)
    for i = 0, file.size - 1, 1 do
      blocks[file.first + i], blocks[slot.first + i] = SPACE, blocks[file.first + i]
    end
  end

  do -- Move blocks from end to empty start positions
    local backwards_cursor = #blocks
    local rearranged_files = {}

    while backwards_cursor > 0 do
      local file = find_previous_file(backwards_cursor)

      backwards_cursor = file.first - 1

      if rearranged_files[file.value] == nil then
        rearranged_files[file.value] = true

        local slot = find_next_empty_slot(0, file.size)

        if slot ~= nil and slot.first < file.last then
          swap_file_and_slot(file, slot)
        end
      end
    end
  end

  do -- Checksum of re-arranged blocks
    for index, block in ipairs(blocks) do
      if block ~= SPACE then
        sum = sum + (index - 1) * block
      end
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
