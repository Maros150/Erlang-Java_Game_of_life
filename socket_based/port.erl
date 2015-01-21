-module(port).
-compile(export_all).

play() ->
	Sock = open(),
	%get_msg(Sock),
	send(Sock,43).


open() -> 
	{ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0}, {active, false}]),
	{ok, Sock} = gen_tcp:accept(LSock),
	Sock.

send(Sock,Data) ->
	gen_tcp:send(Sock,<<Data>>).

get(Sock) ->
	gen_tcp:recv(Sock,0).

close(Sock) ->
	gen_tcp:close(Sock).

get_msg(Sock) ->
	case gen_tcp:recv(Sock, 0) of
		{ok, Data} ->
			io:format("Data received: ~p~n", [Data]),
			Data;
		{error, closed} ->
			io:format("Socket closed.~n"),
			ok;
		Val ->
			io:format("Val: ~p~n", [Val])
	end.