#!/bin/bash
sed  -e 's/[\r\n]//g'  estaciones/estacion1.csv > et1.0    #Organiza y limpia los datos
sed -r 's%$%;Estacion1\r%g' et1.0 > et1.1
sed -r 's%VEL;Estacion1%VEL;Estacion%g' et1.1 > R1.csv
sed  -e 's/[\r\n]//g'  estaciones/estacion2.csv > et2.0
sed -r 's%$%;Estacion2\r%g' et2.0 > et2.1
sed -r 's%VEL;Estacion2%VEL;Estacion%g' et2.1 > R2.csv
sed  -e 's/[\r\n]//g'  estaciones/estacion3.csv > et3.0
sed -r 's%$%;Estacion3\r%g' et3.0 > et3.1
sed -r 's%VEL;Estacion3%VEL;Estacion%g' et3.1 > R3.csv
sed  -e 's/[\r\n]//g'  estaciones/estacion4.csv > et4.0
sed -r 's%$%;Estacion4\r%g' et4.0 > et4.1
sed -r 's%VEL;Estacion4%VEL;Estacion%g' et4.1 > R4.csv
awk 'FNR==1 && NR!=1{next;}{print}' R1.csv R2.csv R3.csv R4.csv > estaciones.csv
sed -r 's%,%.%g' estaciones.csv > out.0
sed -r 's%;%,%g' out.0 > out.1
sed -r 's%,,%,\\N,%g' out.1> out.2
grep -v \\N  out.2 >  out.3
sed -r 's|(^[0-9])/([0-9]{2})/([0-9]{2})|0\1/\2/\3|g' out.3 > out.4
sed -r 's|([0-9]{2})/([0-9]{2})/([0-9]{2})|20\3/\2/\1|g' out.4 > out.5
sed -r 's|,([0-9]):|,0\1:|g' out.5 > out.csv
csvsql --query 'SELECT Estacion, strftime("%m",DATE(FECHA)) as Mes, AVG(VEL) as Velocidad from Out group by Mes, Estacion;' out.csv > velocidad-por-mes.csv
csvsql --query 'SELECT Estacion, strftime("%Y",DATE(FECHA)) as Ano, AVG(VEL) as Velocidad from Out group by Ano, Estacion;' out.csv > velocidad-por-ano.csv
csvsql --query 'SELECT Estacion, strftime("%H",HHMMSS) as Hora, AVG(VEL) as Velocidad from Out group by Hora, Estacion;' out.csv > velocidad-por-hora.csv
rm out* 
rm R*.csv               #Borra los intermedios
rm et*
rm estaciones.csv
