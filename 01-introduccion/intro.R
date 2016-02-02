### Introducción a R
# Teresa Ortiz, Alicia Mastretta
# Febrero 2015"

# la siguiente instrucción solo se corre una vez, es decir, si inicio una nueva
# sesión de R no hace falta volver a ejecutarla
install.packages("readr")

# cargamos el paquete readr, esta instrucción (library(readr)) se corre cada 
# vez que utilizo el paquete en una sesión de R
library(readr)
# read_csv es una función que aporta el paquete readr 
print(read_csv)

# instala ggplot2 y dplyr


### Estructuras de datos
a <- c(5, 2, 4.1, 7, 9.2)
a
a[1]
a[2]
a[2:4]

b <- a + 10
b

d <- sqrt(a)
d
a + d
10 * a
a * d

# secuencias
ejemplo_1 <- 1:10
ejemplo_1
ejemplo_2 <- seq(0, 1, 0.25)
ejemplo_2

# funciones sobre vectores
# media del vector
mean(a)
# suma de sus componentes
sum(a)
# longitud del vector
length(a)

# también podemos construir vectores de caracteres:
frutas <- c('manzana', 'manzana', 'pera', 'plátano', 'fresa')
frutas

# podemos juntar vectores del mismo tamaño en tablas que se llaman `data.frame` 
tabla <- data_frame(n = 1:5, valor = a, fruta = frutas)
tabla
tabla_2 <- data.frame(n = 1:5, valor = a, fruta = frutas)
tabla_2

# el data.frame diamonds está incluido en el paquete ggplot2
library(ggplot2)
head(diamonds)
str(diamonds)

# extraemos los primeros cinco renglones
diamonds[1:5, ]
# extraemos los primeros cinco renglones y las columnas 2,4,6
diamonds[1:5, c(2, 4, 6)]
# también podemos extraer columnase usando $: extraemos la columna x
head(diamonds$x)

# ¿Que extraemos con las siguientes 2 instrucciones?
diamonds[diamonds$x == diamonds$y, ]
diamonds[-(1:53929), c("carat", "price")]


### Datos faltantes
# ¿Qué regresan las siguientes expresiones?
5 + NA
NA / 2
sum(c(5, 4, NA))
mean(c(5, 4,  NA))
NA < 3
NA == 3
NA == NA


sum(c(5, 4, NA), na.rm = TRUE)
mean(c(5, 4, NA), na.rm = TRUE)

# lógica terniaria
edad_Juan <- NA
edad_Esteban <- NA
edad_Juan == edad_Esteban
edad_Jose <- 32
# Juan es menor que José?
edad_Juan < edad_Jose


### Cargar datos
library(readr)
bnames <- read_csv("data/bnames.csv")
bnames
str(bnames)

getwd()

# para datos de excel se recomienda el paquete *readxl*
library(readxl)
conapo <- read_excel("data/conapo_2010.xls", sheet = "mun_carencias")
conapo

# Podemos guardar un data.frame usando la instrucción write_csv.
write_csv(conapo, path = "salidas/conapo.csv")


# También podemos guardar objetos creados en R usando
mi_vector <- c('uno','dos','tres')
save(mi_vector, file = 'salidas/vector_uno.Rdata')
rm('mi_vector')
mi_vector
load('salidas/vector_uno.Rdata')
mi_vector
saveRDS(mi_vector, file ='salidas/vector_dos.Rdata')
nuevo_vector <- readRDS(file = 'salidas/vector_dos.Rdata')
nuevo_vector

## Visualización 
# Gráficas de dispersión
library(ggplot2) 
?mpg
# primeras líneas
head(mpg)  
# estructura de la base
str(mpg)
# resumen general
summary(mpg)
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()


# Podemos representar variables adicionales usando otras características 
# (*_aesthetics_*) como forma, color o tamaño.

ggplot(mpg, aes(x = displ, y = hwy, color = class)) + 
  geom_point()

p <- ggplot(mpg, aes(x = displ, y = hwy))
p + geom_line() # en este caso no es una buena gráfica

p <- ggplot(mpg, aes(x = cty, y = hwy))
p + geom_point() 
p + geom_jitter() 

ggplot(mpg, aes(x = class, y = hwy)) + 
  geom_point() 

ggplot(mpg, aes(x = reorder(class, hwy), y = hwy)) + 
    geom_point() 

ggplot(mpg, aes(x = reorder(class, hwy), y = hwy)) + 
    geom_jitter() 
ggplot(mpg, aes(x = reorder(class, hwy), y = hwy)) + 
    geom_boxplot() 

ggplot(mpg, aes(x = reorder(class, hwy), y = hwy)) + 
    geom_jitter() +
    geom_boxplot()

# paneles
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter() +
  facet_wrap(~ cyl)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter() +
  facet_grid(.~ class)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter() +
  facet_grid(drv ~ class)

data(airquality)
ggplot(airquality, aes(x = Solar.R, y = Ozone)) + 
  geom_point() 

library(Hmisc)
airquality$Wind.cat <- cut2(airquality$Wind, g = 3) 
ggplot(airquality, aes(x = Solar.R, y = Ozone)) + 
  geom_point() +
  facet_wrap(~ Wind.cat)

ggplot(airquality, aes(x = Solar.R, y = Ozone)) + 
  geom_point() +
  facet_wrap(~ Wind.cat) + 
  geom_smooth(span = 3)

head(bnames)

bnames_John <- bnames[bnames$name == "John", ]
ggplot(bnames_John, aes(x = year, y = percent)) +
  geom_point()

ggplot(bnames_John, aes(x = year, y = percent, color = sex)) +
  geom_line()
library(ggplot2)
