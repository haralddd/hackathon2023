using WebSockets: serve, writeguarded, readguarded, @wslog, open, 
    HTTP, Response, ServerWS, with_logger, WebSocketLogger



#= 
SYNX websocket setup


ghostAddress = {{ domain }}/{{ service }}/{{ objectID }}

serviceURL = wss://websocket.cioty.com/{{ ghostAddress }}/channel

token = {{ token }}

=#


ghostAddress = "group5.cioty.com/health-status/1"
type = "string"
serviceURL = "wss://websocket.cioty.com/$ghostAddress/$string"
token = "aToken_36d8715e3531fd8e8c01fcbfd26bf5af1908e14f15014d2d14817b568bc0bb0e"

base_body = "sender=haralg"    


# Create websocket server
# function streamCSV(ws_server)
#     while true
#         for i in 1:chunk_size:num_rows
#             chunk = df[i:min(i+chunk_size-1, num_rows), :]
#             data_send = base_body * "&data=" * string(objecttable(chunk))
#             @wslog "Sending chunk $i to $ws_server"
#             writeguarded(ws_server, data_send)
#             sleep(wait_time)
#         end
#     end
# end

# begin
#     function handler(req)
#         @wslog "Somebody wants a http response"
#         Response(200)
#     end
#     function wshandler(ws_server)
#         @wslog "A client opened this websocket connection"

#         writeguarded(ws_server, "Hello")
#         readguarded(ws_server)
#     end
#     serverWS = ServerWS(handler, wshandler)
#     servetask = @async with_logger(WebSocketLogger()) do
#         serve(serverWS, port = 8000)
#         "Task ended"
#     end
# end

open(serviceURL) do ws_client
    @wslog "Connected to $serviceURL"
    writeguarded(ws_client, "{\"token\":\"$token\"}")
    @wslog "Sent token"
    data, success = readguarded(ws_client)
    
end;

put!(serverWS.in, "close!")