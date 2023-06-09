% Use this editor as a MiniZinc scratch book
% PARÁMETROS
int: n;   % Número de equipos
int: Min; % El mínimo de gira
int: Max; % El máximo de gira

array[1..n, 1..n] of int: D; % Matriz de distancias entre ciudades


% VARIABLES
array[1..2*(n-1), 1..n] of var -n..n: Cal; % Matriz de fechas (objetivo)
array[1..2*(n-1), 1..n] of var 0..Max: ContadorGiras; % Contador de Max de giras (objetivo)
array[1..2*(n-1), 1..n] of var 0..Max: ContadorPermanencias; % Contador de Max de giras (objetivo)


% RESTRICCIONES
constraint forall(i in 1..2*(n-1), j in 1..n)(Cal[i, j] != 0); % No es posible el cero 

% Elementos de las columnas distintos 
constraint forall(i in 1..2*(n-1))(                        
  forall(k in 1..n , j in 1..n where k < j)(Cal[i, k] != Cal[i, j])
);

% Elementos de las filas distintos 
constraint forall(j in 1..n)(
  forall(k in 1..2*(n-1), i in 1..2*(n-1) where k < i)(Cal[k, j] != Cal[i, j])
);


% Si un equipo juega de local en una fecha, el equipo contrincante jugará de visitante
constraint forall(i in 1..2*(n-1)) (
    forall (j in 1..n) (
        if Cal[i,j] > 0 then
            Cal[i, Cal[i,j]] = -j
        else
            Cal[i, abs(Cal[i,j])] = j
        endif
    )
);

%Hay un partido de ida y un partido de vuelta
constraint forall(j,k in 1..n where k != j)(
            exists(i1, i2 in 1..2*(n-1))( Cal[i1, j] = k /\ Cal[i2,j] = -k )
);


%No se pueden jugar partidos de vuelta hasta acabar con los partidos de ida
constraint forall(j in 1..n)(
              forall(k,i in 1..(n-1) where k<i)(
                abs(Cal[i,j]) != abs(Cal[k,j])
              )
);


% No puede repetirse un partido en dos fechas consecutivas
constraint forall(i in 1..2*(n-1)-1) (forall (j in 1..n) (abs(Cal[i,j]) != abs(Cal[i+1,j])));


%No se puede superar el máximo de giras consecutivas
constraint forall(i in 1..2*(n-1))(
           forall(j in 1..n)(
              if Cal[i,j] < 0 then
                if i==1 then
                ContadorGiras[i,j] = 1
              else ContadorGiras[i,j] = ContadorGiras[i-1,j] + 1
              endif
              else ContadorGiras[i,j] = 0
                
              endif
           )  
);

%No se puede superar el máximo de permanencias consecutivas
constraint forall(i in 1..2*(n-1))(
           forall(j in 1..n)(
              if Cal[i,j] > 0 then
                if i==1 then
                  ContadorPermanencias[i,j] = 1
                else ContadorPermanencias[i,j] = ContadorPermanencias[i-1,j] + 1
              endif
              else ContadorPermanencias[i,j] = 0
                
              endif
           )  
);

%Debe haber un mínimo de giras consecutivas
constraint forall(j in 1..n)(
           forall(i in 2..2*(n-1))(
              if i == 2*(n-1) then 
                  if Cal[i,j] < 0 then 
                   ContadorGiras[i,j]>=Min
                  endif
             else
                if (Cal[i,j] > 0)then 
                  if(Cal[i-1,j] < 0)
                    then ContadorGiras[i-1,j]>=Min              
                  endif               
                endif
              endif
           )  
);

%Debe haber un mínimo de permanencias consecutivas
constraint forall(j in 1..n)(
           forall(i in 2..2*(n-1))(
              if i == 2*(n-1) then 
                  if Cal[i,j] > 0 then 
                   ContadorPermanencias[i,j]>=Min
                  endif
             else
                if (Cal[i,j] < 0)then 
                  if(Cal[i-1,j] > 0)
                    then ContadorPermanencias[i-1,j]>=Min              
                  endif               
                endif
              endif
           )  
);



% Función objetivo
var int: objective = sum(j in 1..n)(
    sum(i in 1..2*(n-1))(
        if i == 1 then
            if Cal[i,j] < 0 then
                D[abs(Cal[i,j]), j]
            else
                0
            endif
        else 
            if Cal[i,j] > 0 then
                if Cal[i-1,j] < 0 then
                    D[abs(Cal[i-1,j]), j]
                else
                    0
                endif
            else
                if i == 2*(n-1) then
                  if Cal[i-1,j] < 0 then
                      D[abs(Cal[i-1,j]), abs(Cal[i,j])] + D[abs(Cal[i,j]), j]
                  else
                      D[abs(Cal[i,j]), j] + D[abs(Cal[i,j]), j]
                  endif
                else
                  if Cal[i-1,j] < 0 then
                      D[abs(Cal[i-1,j]), abs(Cal[i,j])]
                  else
                      D[abs(Cal[i,j]), j]
                  endif                   
                endif
            endif
        endif
    )
);

% SOLUCIÓN
solve minimize objective;

output["Costo de viajes: \(objective) \n"]++
[
      if j > 1 then " " else "" endif ++
       show(Cal[i, j])
    ++
    if j = n then "\n" else "" endif
    | i in 1..2*(n-1), j in 1..n
  ]
  
 
% [
%       if j > 1 then " " else "" endif ++
%        show(Contador[i, j])
%     ++
%     if j = n then "\n" else "" endif
%     | i in 1..2*(n-1), j in 1..n
%   ];