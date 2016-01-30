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
diamonds[1:5, c(2,4,6)]
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


Podemos representar variables adicionales usando otras características estéticas 
(*_aesthetics_*) como forma, color o tamaño.

```{r, fig.width = 5.5, fig.height = 4}
ggplot(mpg, aes(x = displ, y = hwy, color = class)) + 
  geom_point()
```

![](imagenes/manicule2.jpg) Experimenta con los _aesthetics_ color (color), 
tamaño (size) y forma (shape).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  ¿Qué diferencia hay entre las variables 
categóricas y las continuas?

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  ¿Qué ocurre cuando combinas varios _aesthetics_?

El mapeo de las propiedades estéticas depende del tipo de variable, las 
variables discretas (por ejemplo, genero, escolaridad, país) se mapean a 
distintas escalas que las variables continuas (variables numéricas como edad, 
estatura, etc.):

&nbsp;    |Discreta      |Continua
----------|--------------|---------
Color     |Arcoiris de colores         |Gradiente de colores
Tamaño    |Escala discreta de tamaños  |Mapeo lineal entre el radio y el valor
Forma     |Distintas formas            |No aplica

La segunda parte de la instrucción de graficar (después del símbolo +) 
corresponde a las geometrías, *_geoms_*, que controlan el tipo de gráfica

```{r, fig.width = 5, fig.height = 4}
p <- ggplot(mpg, aes(x = displ, y = hwy))
p + geom_line() # en este caso no es una buena gráfica
```

¿Qué problema tiene la siguiente gráfica?

```{r, fig.width = 5, fig.height = 4}
p <- ggplot(mpg, aes(x = cty, y = hwy))
p + geom_point() 
p + geom_jitter() 
```

![](imagenes/manicule2.jpg) ¿Cómo podemos mejorar la siguiente gráfica?

```{r, fig.width = 5, fig.height = 4}
ggplot(mpg, aes(x = class, y = hwy)) + 
  geom_point() 
```

Intentemos reodenar los niveles de la variable clase

```{r, fig.width = 5, fig.height = 4}
ggplot(mpg, aes(x = reorder(class, hwy), y = hwy)) + 
    geom_point() 
```

Podemos probar otros geoms.
```{r, fig.width = 5, fig.height = 4}
ggplot(mpg, aes(x = reorder(class, hwy), y = hwy)) + 
    geom_jitter() 
ggplot(mpg, aes(x = reorder(class, hwy), y = hwy)) + 
    geom_boxplot() 
```

También podemos usar más de un geom!
```{r, fig.width = 5, fig.height = 3.5}
ggplot(mpg, aes(x = reorder(class, hwy), y = hwy)) + 
    geom_jitter() +
    geom_boxplot()
```

![](imagenes/manicule2.jpg) Lee la ayuda de _reorder_ y repite las gráficas 
anteriores ordenando por la mediana de _hwy_.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ¿Cómo harías
para graficar los puntos encima de las cajas de boxplot?

#### Paneles
Veamos ahora como hacer páneles de gráficas, la idea es hacer varios múltiplos 
de una gráfica donde cada múltiplo representa un subconjunto de los datos, es 
una práctica muy útil para explorar relaciones condicionales.

En ggplot podemos usar _facet\_wrap()_ para hacer paneles dividiendo los datos 
de acuerdo a las categorías de una sola variable

```{r, fig.width = 5, fig.height = 5}
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter() +
  facet_wrap(~ cyl)
```

También podemos hacer una cuadrícula de 2 dimensiones usando 
_facet\_grid(filas~columnas)_ 

```{r, fig.width = 8, fig.height = 2.5}
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter() +
  facet_grid(.~ class)
```
```{r, fig.width = 7, fig.height = 5}
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter() +
  facet_grid(drv ~ class)
```

Los páneles pueden ser muy útiles para entender relaciones en nuestros datos. En 
la siguiente gráfica es difícil entender si existe una relación entre radiación
solar y ozono:

```{r, fig.width = 4, fig.height = 3}
data(airquality)
ggplot(airquality, aes(x = Solar.R, y = Ozone)) + 
  geom_point() 
```

Veamos que ocurre si realizamos páneles separando por velocidad del viento

```{r, fig.width = 7, fig.height = 3, message = FALSE, warning = FALSE}
library(Hmisc)
airquality$Wind.cat <- cut2(airquality$Wind, g = 3) 
ggplot(airquality, aes(x = Solar.R, y = Ozone)) + 
  geom_point() +
  facet_wrap(~ Wind.cat)
```

Podemos agregar un suavizador (loess) para ver mejor la relación de las 
variables en cada panel.
```{r, fig.width = 7, fig.height = 3, warning = FALSE}
ggplot(airquality, aes(x = Solar.R, y = Ozone)) + 
  geom_point() +
  facet_wrap(~ Wind.cat) + 
  geom_smooth(span = 3)
```

![](imagenes/manicule2.jpg) Escribe algunas preguntas que puedan contestar con estos datos.

En ocasiones es necesario realizar transformaciones u obtener subconjuntos de los 
datos para poder responder preguntas de nuestro interés, por ejemplo, la base de 
datos que cargamos al inicio de esta sección (bnames) contiene los 1000 nombres 
de niña y niño mas populares en EUA entre 1880 y 2008.

```{r}
head(bnames)
```

Supongamos que queremos ver la tendencia del nombre "John", para ello debemos 
generar un subconjunto de la base de datos.

```{r,  fig.width = 5, fig.height = 3}
bnames_John <- bnames[bnames$name == "John", ]
ggplot(bnames_John, aes(x = year, y = percent)) +
  geom_point()
```
```{r,  fig.width = 5, fig.height = 3.7}
ggplot(bnames_John, aes(x = year, y = percent, color = sex)) +
  geom_line()
```

La preparación de los datos es un aspecto muy importante del análisis y suele ser
la fase que lleva más tiempo. Es por ello que el siguiente tema se enfocará en 
herramientas para hacer transformaciones de manera eficiente.

![](imagenes/manicule2.jpg) Tarea. Explora la base de datos msleep, estos datos 
están incluidos en el paquete ggplot2 para acceder a ellos basta con cargar el 
paquete:

```{r}
library(ggplot2)
head(msleep)
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; realiza al 
menos 3 gráficas y explica las relaciones que encuentres. Al menos una de las 
gráficas debe ser de páneles, si lo consideras interesante, puedes crear una 
variable categórica utilizando la función cut2 del paquete Hmisc. 


### Recursos
* Buscar ayuda: Google, [StackOverflow](http://stackoverflow.com/questions/tagged/r), 
[seekR](http://seekr.international). Para aprender más sobre un paquete o una función pueden visitar [Rdocumentation.org](http://www.rdocumentation.org/).
* Para aprender los comandos básicos de R [*Try R*](http://tryr.codeschool.com/) y 
[Datacamp](https://www.datacamp.com/) cuentan con excelentes cursos interactivos.
* Para aprender programación avanzada en R, el libro gratuito [Advanced R](http://adv-r.had.co.nz) de Hadley Wickham es una buena referencia. En particular es conveniente leer la [guía de estilo](http://adv-r.had.co.nz/Style.html) (para todos: principiantes, intermedios y avanzados). 
* Para mantenerse al tanto de las noticias de la comunidad de R pueden visitar [R-bloggers](http://www.r-bloggers.com).
* Para entretenerse en una tarde domingo pueden navegar los reportes en [RPubs](https://rpubs.com).
* [Lista de paquetes y recursos](https://github.com/qinwf/awesome-R#integrated-development-environment)
* Para aprender más de ggplot pueden ver la documentación con ejemplos en la 
página de [ggplot2](http://docs.ggplot2.org/current/).
* Otro recurso muy útil es el [acordeón de ggplot](https://www.rstudio.com/wp-content/uploads/2015/04/ggplot2-spanish.pdf)
