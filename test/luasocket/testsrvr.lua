local uv = require("lluv");

socket = require("lluv.luasocket");
host = host or "127.0.0.1";
port = port or "8383";

local function spawn(fn, ...) coroutine.wrap(fn)(...) end

local function fiber(...) uv.defer(spawn, ...) end

local function main()
    server = assert(socket.bind(host, port));
    ack = "\n";
    while 1 do
        print("server: waiting for client connection...");
        control = assert(server:accept());
        while 1 do 
            command, emsg = control:receive();
            if emsg == "closed" then
                control:close()
                break
            end
            assert(command, emsg)
            assert(control:send(ack));
            print(command);
            ((loadstring or load)(command))();
        end
    end
end

fiber(main)

uv.run()