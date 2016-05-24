# paquete para leer archivos con datos (por ejemplo, archivos csv)
library("readr")

# paquete para hacer bucles (loops) eficientemente
library("plyr")

# SQL para data frames (básicamente)
library("dplyr")

# Limpieza de datos
library("tidyr")

# Leer archivo 
pew <- read.delim(file = "http://stat405.had.co.nz/data/pew.txt",
  header = TRUE, stringsAsFactors = FALSE, check.names = F)

# Visualizar datos de distintas formas

# Hacer una tabla en una nueva pestaña
View(pew)

# Ver los primeros registros de la tabla
head(pew)

# Ver cada columna, su tipo de datos y ejemplos de valores
# paquete dplyr
glimpse(pew)

# Paquete tidyr, funciones principales:

# Gather: pasar de una matriz de sitios por especies, a una
# lista de especies:

# pasar de:
# sitio especie1 especie2
# 1         5       0 
# 2         3       2

# a:
# sitio especie abundancia
#   1     1         5
#   1     2         0
#   2     1         3
#   2     2         2

pew_lista <- gather(pew, "ingreso", "n", -religion)
View(pew_lista)

# spread: el proceso contrario a gather.

pew_matriz <- spread(pew_lista, ingreso, n)
?spread
# key: variable que queremos poner como nombres de columnas
# value: variable valor
View(pew_matriz)

# Separate: separar varias variables que están en la misma columna,
# en columnas separadas.
df <- data.frame(x = c(NA, "a_b", "a_d", "b_c"))
df

# c(): hacer un vector en R, ejemplo c(2,4)
df_separado <- separate(df, x, c("variable1", "variable2"))
#por default me lo separa en caracteres "raros" (no alfanuméricos)
?separate

# Paquete dplyr: funcionalidades principales

# select: seleccionar columnas de un data frame (df) y crear un data frame nuevo
# con ellas.

# filter: fitrar registros de un df (de acuerdo a cierta regla) y crear un nuevo
# df con ellos,

# mutate/transmute: crear nuevas variables a partir de variables en mi df original,
# y ponerlas en un nuevo df.

# arrange: ordenar registros por valor de una (o más variables), y regresar un nuevo
# df con los registros ordenados.

# join: unir dos tablas (como en SQL), por medio de una llave (campo en común)
# y regresar el resultado en un nuevo df.

# group_by: agrupar registros por el valor de una o más variables, para calcular
# resúmenes por grupo (summarise) o variables que valen lo mismo para todo el grupo
# (mutate), y regresar el resutado en un nuevo df.

# operador pipeline: %>%:
# ¿Qué significa f(x) %>% g(2)?
# calcúlame f(x), y el resultado lo pones como primer argumento en g: resultando
# g(resultado de aplicar f a x, 2)

# aplica f a x y lo que resulte mételo a g y calcula, y así sucesivamente.

## conectándonos al SNIB y obteniendo datos para aplicarles las funciones anteriores:
# SNIB es MySQL entonces es muy fácil
# SQLite es muy fácil
# PostgreSQL es muy fácil
# Oracle es difícil porque su código no es abierto y no lo quieren dar a conocer
# SQL Server (Microsoft) también difícil
# Access también difícil

## Para conectarnos a una base de datos MySQL, primero necesitamos instalar el
# paquete RMySQL

#ya que lo tenemos:

# 0. cargamos dplyr (ya lo tenemos)
# 1. usamos la función src_mysql() (ó src_sqlite() ó src_postgres(), de dplyr
# para conectarnos a la base de datos. Esta función me regresa la conexión a la
# base de datos
# 2. vimos que dplyr es como un SQL, se usa en lugar de SQL para extraer información
# de las bases de datos.
# 3. como las tablas en las bases de datos pueden ser muy grandes, las funciones
# anteriores, AL TRABAJAR CON BASES DE DATOS sólo obtienen los registros cuando
# ésto se solicita explícitamente (comando collect())

?src_mysql

# Conexión a la base de datos, utilizando las credenciales del SNIB
base_input <- src_mysql(dbname = "geoportal", host = "172.16.1.139", port = 3306,
  user = "lectura", password = "xxxxx")

# Enlistando las tablas de la base a la que estamos conectados.
src_tbls(base_input)

# Vamos a ver qué variables tienen esas tablas:

tbl(base_input, "InformacionGeoportal20160208") %>%
  colnames()

# Haciendo un query:

tabla_porites_acropora <- tbl(base_input, "InformacionGeoportal20160208") %>%
  
  # del resultado de tbl (la tabla), seleccióname esas columnas
  select(
    latitud,
    longitud,
    clasevalida,
    familiavalida,
    generovalido,
    especievalida
  ) %>%
  
  # seleccióname los registros que cumplan con la siguiente condición
  filter(
    # == es una comparación: 2 == 3 FALSE 2 == 2 TRUE (por eso usamos <- para
    # asignar y no confundirnos con ==). Si quiero más de uno, uso %in% en un vector
    generovalido %in% c("Porites", "Acropora")
  ) %>%
  
  # el query no se realioza hasta que colectamos los datos
  collect()

# Ya que tengo mis datos en un df de R, y puedo trabajarlos.
View(tabla_porites_acropora)

tabla_porites_acropora_2 <- tabla_porites_acropora %>%
  separate(
    especievalida, c("genero", "especie")
  ) %>%
  mutate(
    nombre_cientifico = paste(genero, especie, sep = " ")
  )

cuenta_corales <- tabla_porites_acropora_2 %>%
  group_by(nombre_cientifico) %>%
  tally()

# Escribiendo archivo :
write_csv(cuenta_corales, "cuenta_corales.csv")

