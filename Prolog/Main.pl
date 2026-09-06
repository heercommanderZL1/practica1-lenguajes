:- use_module(library(readutil)).

% 1. Leer archivo binario
cargar_pbm(Ruta, Bytes) :-
    read_file_to_codes(Ruta, Bytes, [type(binary)]).

% 2. Relacion para verificar si un pixel (X,Y) es negro (1) o blanco (0)
pixel_negro(X, Y, Bytes, Ancho, BytesPorFila) :-
    ByteIndex is Y * BytesPorFila + (X // 8),
    BitIndex is 7 - (X mod 8),
    nth0(ByteIndex, Bytes, Byte),
    Bit is (Byte >> BitIndex) /\ 1,
    Bit =:= 1.

% 3. Relacion f(X) -> Altura
f(X, Bytes, Ancho, Alto, BytesPorFila, Altura) :-
    findall(Y, (between(0, Alto-1, Y1), Y is Alto - 1 - Y1, pixel_negro(X, Y, Bytes, Ancho, BytesPorFila)), Ys),
    contar_consecutivos(Ys, Altura).

contar_consecutivos([Y|Resto], Altura) :-
    % Logica para contar desde abajo sin interrupciones
    contar_aux([Y|Resto], 0, Altura).
contar_aux([], Acc, Acc).
contar_aux([_|_], Acc, Acc). % Detener al hallar el primer blanco

% 4. Construccion declarativa de M y Suma
calcular_area :-
    cargar_pbm('../curva_binaria_P4.pbm', Bytes),
    Ancho = 567, Alto = 319, BytesPorFila = 71,
    
    % findall para construir la lista M de alturas
    MaxX is Ancho - 1,
    findall(Altura, (between(0, MaxX, X), f(X, Bytes, Ancho, Alto, BytesPorFila, Altura)), M),
    
    % Suma de la lista M
    sum_list(M, Area),
    format('Area calculada: ~w pixeles cuadrados~n', [Area]).