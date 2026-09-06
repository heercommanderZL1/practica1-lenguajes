:- use_module(library(readutil)).

% 1. Leer el archivo binario completo
cargar_pbm(Ruta, Bytes) :-
    read_file_to_codes(Ruta, Bytes, [type(binary)]).

% 2. Verificar si un pixel (X,Y) es negro (1)
pixel_negro(X, Y, Bytes, DataOffset, BytesPorFila) :-
    ByteIndex is DataOffset + (Y * BytesPorFila) + (X // 8),
    BitIndex is 7 - (X mod 8),
    nth0(ByteIndex, Bytes, Byte),
    Bit is (Byte >> BitIndex) /\ 1,
    Bit =:= 1.

% 3. Funcion f(X) -> Altura (Conteo consecutivo desde abajo hacia arriba)
f(X, Bytes, DataOffset, Alto, BytesPorFila, Altura) :-
    YInicial is Alto - 1,
    contar_negros_columna(X, YInicial, Bytes, DataOffset, BytesPorFila, 0, Altura).

% Caso base / Contar mientras sea negro
contar_negros_columna(X, Y, Bytes, DataOffset, BytesPorFila, Acc, Altura) :-
    Y >= 0,
    pixel_negro(X, Y, Bytes, DataOffset, BytesPorFila),
    !,
    YSiguiente is Y - 1,
    AccSiguiente is Acc + 1,
    contar_negros_columna(X, YSiguiente, Bytes, DataOffset, BytesPorFila, AccSiguiente, Altura).

% Caso de parada: Se encontro un pixel blanco o se llego al tope de la imagen
contar_negros_columna(_, _, _, _, _, Altura, Altura).

% 4. Construccion declarativa de la lista M y calculo de la Suma de Riemann
calcular_area :-
    cargar_pbm('../curva_binaria_P4.pbm', Bytes),
    Ancho = 567, 
    Alto = 319, 
    BytesPorFila = 71,
    
    % Calcular offset para ignorar el encabezado PBM binario
    length(Bytes, TotalBytes),
    DataOffset is TotalBytes - (Alto * BytesPorFila),
    
    % Construccion declarativa de M usando findall/3
    MaxX is Ancho - 1,
    findall(Altura, (between(0, MaxX, X), f(X, Bytes, DataOffset, Alto, BytesPorFila, Altura)), M),
    
    % Suma de Riemann (Area en pixeles cuadrados)
    sum_list(M, Area),
    format('Imagen cargada: ~wx~w pixeles~n', [Ancho, Alto]),
    format('Area calculada: ~w pixeles cuadrados~n', [Area]).