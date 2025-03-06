-- Example of essh lua use

task "install_essh_utils" {
    script_file = "https://raw.githubusercontent.com/sevir/essh_utils/refs/heads/main/install_essh.sh"
}

-- Example of remote task for installing essh_utils
task "install_essh_utils:remote" {
    backend = "remote",
    prepare = select_host,
    script_file = "https://raw.githubusercontent.com/sevir/essh_utils/refs/heads/main/install_essh.sh"
}

-- Load drivers without warning errors when not found the library
pcall(require, 'drivers')

-- Now you can use the functions and drivers in your tasks
task "test_lua" {
    driver = "essh-lua",
    script = [=[
        -- Optional: Load functions from libs (you will have is you have executed the install_essh_utils task)
        -- If you are not using any functions from libs, you can remove this line
        require "functions"

        print("Hello world from Essh-Lua")
    ]=]
}