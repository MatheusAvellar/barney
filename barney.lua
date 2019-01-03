local mem_run_start = 0
local mem_run_end = 0

local start_time
local start_frame_count
local reset_counter = 0

local run_time
local run_started = false
local run_over = false
local run_frame_count

local min = 0
local sec = 0


-- Previous record (update if restarting script)
local record = 560            -- (in seconds -> 560 = 9min 20s)
local record_str = "9min 20s" -- (in the format "0min 00s")

while true do
  -- Try to use main RAM
  if not memory.usememorydomain("68K RAM") then print("Oh no") end

  -- While run hasn't started, check if run has started
  if not run_started then
    -- Arbitrary RAM address that seems to work
    mem_run_start = memory.read_u16_be(0x2010)
  -- Otherwise, if run has started, check if it's over
  else
    -- Arbitrary RAM address that seems to work
    mem_run_end = memory.read_u16_be(0x45D4)
  end

  -- Arbitrary magic number that seems consistent
  if mem_run_start == 46000 and not run_started then
    -- Run has begun, get current time and wait until run is over
    run_started = true
    start_time = os.time()
    start_frame_count = emu.framecount()
    run_over = false
    print("(run start) @ " .. start_time)
  end

  -- Arbitrary magic numbers that seem consistent
  if(mem_run_end == 354
  or mem_run_end == 355) and not run_over then
    -- Run is now over, get elapsed time and wait until it's restarted
    run_over = true
    local time = os.time()
    print("(run end) @ " .. time)
    run_time = os.time() - start_time
    run_frame_count = emu.framecount() - start_frame_count
    run_started = false
    start_time = 0

    -- Calculate delta time from computer clock (imperfect, measured in seconds)
    min = math.floor(run_time/60)
    sec = run_time - min*60
    reset_counter = 1
    print("Real time ~" .. min .. "min " .. sec .. "s  [" .. run_time .. "s]")

    -- Calculate delta time from frame count (theoretical, assumes 60fps)
    local frame_time = run_frame_count/60
    local _min = math.floor(frame_time/60)
    local _sec = math.floor((frame_time - _min*60)*1000)/1000
    print("Frame time ~"
     .. _min .. "min "
     .. _sec .. "s [" .. run_frame_count .. " frames]")
  end

  -- Start the reset counter
  if reset_counter > 0 then
    reset_counter = reset_counter + 1
    -- After 500 frames, reset everything
    if reset_counter > 500 then
      -- If new run time is faster than record, update record
      if record > run_time then
        record = run_time
        -- Change "2s" to "02s"
        if sec < 10 then sec = "0"..sec end
        record_str = min .. "min " .. sec .. "s"

        print("It's a new record!\n")

        -- Signal local server to save run recording
        comm.httpGet("http://127.0.0.1:3000/")

      -- Otherwise, if there is a previous record, print it
      elseif record_str then
        print("Current record still " .. record_str)
        print("")
      end

      -- Reset everything
      mem_run_start = 0
      mem_run_end = 0
      reset_counter = 0
      run_started = false
      run_over = false
      run_frame_count = 0
      start_frame_count = 0
      min = 0
      sec = 0
    end
  end

  emu.frameadvance()
end