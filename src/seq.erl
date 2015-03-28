-module(seq).
-author('komm@siphost.su').
-export([new/1, getseq/2, updateseq/3, bs/3, flatten/1]).

new(Length)->
   [{1, Length, false}]
.

getseq(Number, Sec)->
    case [{X,Y,Z} || {X,Y,Z} <- Sec,  X=<Number, Y>=Number] of
    [] ->
        false
    ;
    [{Min, Max, Value}] ->
        {Min, Max, Value}
    ;
    [{Min, Max, Value} | _] ->
        {Min, Max, Value}
    end
.

updateseq(Number, Sec, NewValue)->
    lists:map(fun
        ({Min, Max, _}) when (Min =< Number) and (Max >= Number)->
           {Min, Max, NewValue} 
        ;  
        (Value)->
           Value
        end,
    Sec )
.

bisection(_, [], _)->
    []
;
bisection(Number, [ {Number, Number, _} | Seq], NewValue) ->
       [{Number, Number, NewValue}| bisection(Number, Seq, NewValue)]
;
bisection(Number, [ {Number, Max, Value} | Seq], NewValue) when Max >= Number ->
       [{Number, Number, NewValue} , {Number+1, Max, Value} | bisection(Number, Seq, NewValue)]
;
bisection(Number, [ {Min, Number, Value} | Seq], NewValue) when Min =< Number ->
       [{Min, Number-1, Value}, {Number, Number, NewValue} | bisection(Number, Seq, NewValue)]
;
bisection(Number, [ {Min, Max, Value} | Seq], NewValue) when (Min =< Number) and (Max >= Number) ->
       [{Min, Number-1, Value}, {Number, Number, NewValue},{Number+1, Max, Value} | bisection(Number, Seq, NewValue)]
;
bisection(Number, [Other| Seq], NewValue)->
       [Other | bisection(Number, Seq, NewValue)]
.

bs([], Seq, _)->
    Seq
;
bs([Number | Numbers], Seq, NewValue)->
    NewSeq = bs(Number, Seq, NewValue),
    bs(Numbers, NewSeq, NewValue)
;
bs(Number, Seq, NewValue)->
       lists:flatten(bisection(Number, Seq, NewValue))
.

flatten([])->
    []
;
flatten([H|T])->
    lists:flatten([flatten(H, T)])
.

flatten( Prev, [])->
      Prev
;
flatten({PrevMin, _PrevMax, Value}, [{_Min, Max, Value} | Seq])->
        New = {PrevMin, Max, Value},
        [ flatten(New, Seq)]
;
flatten( Prev, [{_Min, _Max, _Value} = New | Seq])->
        [ Prev | flatten(New, Seq)]
.










