-- Global variables and functions for hosts and taks
local sh = require("sh")
local fs = require("fs")

function write_cache_file(file, content)
    sh.mkdir("-p", ".cache")
    fs.write(".cache/" .. file, content)
end

function now()
    -- Get current date in seconds
    for line in sh.date("+%s"):lines() do return tonumber(line) end
end

function get_cache_file_timestamp(file)
    -- Get the last modification date of a file in seconds
    for line in sh.stat("-c", "%Y", ".cache/" .. file):lines() do return tonumber(line) end
end

function read_cache_file(file)
    -- Read the content of a file
    return fs.read(".cache/" .. file)
end

function aws_hosts_with_cache(filename, profile, region)
    -- Get the list of ec2 instances from AWS using myaws
    -- The list is cached for 10 minutes
    local file_timestamp = get_cache_file_timestamp(filename)
    if file_timestamp == nil or get_cache_file_timestamp(filename) - now() > 600 then
        write_cache_file(filename,
            sh.myaws("--profile", profile, "--region", region, "ec2", "ls", "-F",
                "PublicIpAddress Tag:Name InstanceId LaunchTime"):combinedOutput())
    end

    return read_cache_file(filename)
end

-- ------------------------------------------
-- OTHER UTILS FUNCTIONS FOR TASKS
-- ------------------------------------------
local env = require("env")
local target = env.get("TARGET")

function timestamp_to_date(timestamp)
    for line in sh.date("-d", "@" .. tostring(timestamp)):lines() do
        return line
    end
end

function elapsed_time(start, finish)
    spent_time = finish - start
    print("Elapsed time: " .. math.floor(spent_time / 60) .. " minutes and " ..
        (spent_time % 60) .. " seconds")
    return spent_time
end

function trim_output(Text)
    local Option1 = true -- true to remove line breaks
    local Option2 = true -- true to remove all spaces
    local Option3 = true -- true to remove spaces in the end of each line

    -- Script
    if Option1 and not Option2 and Option3 or Option1 and not Option2 and
        not Option3 then
        local String = Text:gsub("[\r\n%z]", " ") -- Removes line breaks
        return String
    end
    if not Option1 and Option2 and Option3 or not Option1 and Option2 and
        not Option3 then
        local String = Text:gsub("[ \t]", "") -- Removes all spaces
        return String
    end
    if Option1 and Option2 and Option3 or Option1 and Option2 and not Option3 then
        local String = Text:gsub("[ \n]", "") -- Removes line breaks/all spaces
        return String
    end
    if not Option1 and not Option2 and Option3 then
        local String = Text:gsub("[ \t]+%f[\r\n%z]", "") -- Removes spaces in the end of each line
        return String
    end
end

function table_join(table, separator)
    local result = ""
    for i, v in ipairs(table) do
        if i > 1 then result = result .. separator end
        result = result .. v
    end
    return result
end

-- capistrano like copy function
function capistrano(tmp_path_folder, dest)
    print("Capistrano like copy")
end

