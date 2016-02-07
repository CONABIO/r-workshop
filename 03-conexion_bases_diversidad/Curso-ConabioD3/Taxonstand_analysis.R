
library(Taxonstand)
library(taxize)
#library(taxizesoap)
#library(spocc)
library(reshape)
library(vegan)
#library(ade4)
library(rinat)
library(ggmap)
library(ggdendro)
library(ggplot2)
library(traits)
library(TR8)
library(repmis)


#getwd()
#Seleccion del directorio en Mac
#setwd("~/Dropbox/JANO/2016/Conabio/Curso-R/")

#Seleccion del directorio en PC
#setwd("C:\\Users\\aponce\\Dropbox\\JANO\\2016\\Conabio\\AC-PROMAC\\Reunion_Mariela\\Mariela_Fuentes\\")
#dir()
#Inventario <- read.table("RawData.txt", head=T, sep=",")
#summary(Inventario)
#str(Inventario)
#dim(Inventario)
#head(Inventario)
#head(Inventario)[,1:14]

#Bajarlo Directametne del dropbox

#https://www.dropbox.com/sh/x7becmm6k1sargo/AABgIiY12S1zqqqLjF9HNlila?dl=0


myfilename <- "RawData.csv"
mykey <- "78s6jvpbtys23nb"

Inventario <- source_DropboxData(myfilename, key=mykey, sep=",", head=T) #funcion del paquete repmis
head(Inventario)

attach(Inventario)
Tabla1 <- aggregate(Inventario[,-c(1:12)], by=list(Labranza, Tecnica, Muestreo), FUN=sum, na.rm = T)
dim(Tabla1)
detach(Inventario)
names(Tabla1)
names(Tabla1)[1:3] <- c("Labranza", "Tecnica", "Muestreo")
dim(Tabla1)

Tabla2 <- within(Tabla1, name.complete <- paste(Tabla1[,1],Tabla1[,2], Tabla1[,3], sep='.'))
Tabla2
dim(Tabla2)
Tabla3 <- data.frame(Tabla2[,-57], row.names=Tabla2$name.complete)
Tabla3
dim(Tabla3)

Inventario1 <- list(Var=Tabla3[,1:3], Val=Tabla3[,-c(1:3)])
Nom1 <- names(Inventario1$Val)
names(Inventario1)
names(Inventario1$Val)
names(Inventario1$Var)

summary(Inventario1$Val)

Nom1 <- names(Inventario1$Val)
Nom1
class(Nom1)

Nom2 <- colsplit(Nom1, "_", c("Genus","Species"))
head(Nom2)

#Para juntar los valores en una sola columna
Nom3 <- within(Nom2[,1:2], name.complete <- paste(Nom2[,1],Nom2[,2], sep=' '))
names(Nom3)
head(Nom3)
nrow(Nom3)

Code1 <- paste("spp", seq(1:nrow(Nom3)), sep='.')
Code1
class(Code1)
nrow(Nom3)

#Star with Taxonstand
#Para una sola especie
#help(TPLck)
LL <- TPLck("Gossypium hirsutum")
LL


#Stop here!!!
#Stop here!!!
#Stop here!!!
r1 <- TPL(Nom3$name.complete, corr=T, version=1.1)
r1
head(r1,2)
names(r1) #se ve los encabezados que se obtuvieron
dim(r1)
r1$Plant.Name.Index
r1$Taxonomic.status
True_D <- data.frame(Nom3,r1[,c(6,8,9,10,12,14,15)])
dim(True_D)
head(True_D)
names(True_D)
getwd()

#Seleccion del directorio en Mac
#setwd("~/Dropbox/JANO/2016/Conabio/Curso-R/")

#Seleccion del directorio en PC
setwd("C:\\Users\\aponce\\Dropbox\\JANO\\2016\\Conabio\\Curso-R\\")

write.table(True_D, file="VegCorrecTaxonstand.txt", row.name=T, col.name=T, sep="\t")

#True_D <- read.table("VegetationCorrected.txt", head=T, sep="\t")

#Using taxize for one species
LL1<- tnrs(query = "Gossypium hirsutum", source = "iPlant_TNRS")
LL1

#Using taxize
Tabla6 <- tnrs(query = Nom3$name.complete, source = "iPlant_TNRS")
Tabla6
write.table(Tabla6, file="VegCorrecTaxize.txt", row.name=T, col.name=T, sep="\t")

ls()

#########
#Ejercicio. Con el documento Flora_domcesticada.xls checa cuales son sinonimias y en caso de error taxon?mico
#adicionar a la tabla original la nueva  informaci?n y su autoridad
#El documento se llama "Flora_domesticada.xls"
#Nota: Eviten usar los nombres o asignaciones hechas antes, pq se necesitan para la siguiente parte de la 
#Clase



########

#Conexion a Naturalista
#iNaturalist

True_D1 <- True_D[True_D$Plant.Name.Index=="TRUE",]
dim(True_D1)
dim(True_D1)
names(True_D1)
True_D1
Nombres_iNat <- paste(True_D1[,7],True_D1[,8], sep=' ')

Data1 <- get_inat_obs(query=Nombres_iNat[43], quality="research")

Data1
Data1$scientific_name
names(Data1)
#El primer renglon son los datos de Nestor

map <- get_map(location = "Mexico", zoom = 5, source = "google")
p <- ggmap(map, fullpage = TRUE)
p
#Ahora adicionamos los datos
p+ geom_point(aes(x = longitude, y = latitude, colour = scientific_name), size=4,data = Data1)


#Cargar un proyecto en particular
## By project
#El proyecto que creo Nestor en iNaturalist se llama: inifap_algodonero
bugs1 <- get_inat_obs_project("inifap_algodonero",type = "observations", raw = FALSE)

#Ahora se muestran los datos que cargaron tanto Valeria como Nestor
bugs1

#Ahora hacer el mapa con los valores de los bichos
#Primero es para obtener el mapa de Obregon
map <- get_map(location = "Ciudad Obregon", zoom = 9, source = "google")
ggmap(map, fullpage = TRUE)

#Ahora adicionamos los datos de los dos registros adicionados por Valeria y N??stor
ggmap(map, fullpage = TRUE)+ geom_point(aes(x = Longitude, y = Latitude, colour = Scientific.name), size=4,data = bugs1)

#Para hacer el cluster de los datos

phylogeny <- phylomatic_tree(Nombres_iNat, method="phylomatic")
plot(phylogeny)

#funcion del paquete traits

#devtools::install_github("ropensci/traits")
#Especies invasoras en el GISD http://www.issg.org/database/welcome/

Nombres_iNat
Nombres_iNat[4]
g_invasive(Nombres_iNat[4])
eol_invasive_(Nombres_iNat[4], dataset='gisd')
sci2comm(Nombres_iNat[43], db="itis")


#Buscar traits of vegetation

library(TR8)
head(available_tr8)
my_traits <- c("h_max", "h_min", "le_area")

my_Data <- tr8(species_list=Nombres_iNat, download_list=my_traits)
print(my_Data)

###########################
#Diversidad Alfa

Inventario1 <- list(Var=Tabla3[,1:3], Val=Tabla3[,-c(1:3)])
head(Inventario1)

SpecNum <-specnumber(Inventario1$Val) ## #rowSums(BCI > 0)#  Species   	richness
ShannonD <- diversity(Inventario1$Val)#Shannon entropy
Pielou <- ShannonD/log(SpecNum)#Pielou's evenness
Simp <- 1-(diversity(Inventario1$Val, "simpson"))#        Indice de dominacia de Simpson
TablaF <- data.frame(Inventario1$Var,SpecNum, ShannonD, Simp, Pielou)
print(TablaF)

p <- ggplot(TablaF, aes(Tecnica,ShannonD, fill=Labranza))
p+geom_boxplot()+geom_jitter()


#Diversidad Beta
help(betadiver)
Beta1 <- betadiver(Inventario1$Val, "w")
Beta1
Clust <- hclust(Beta1, "ward.D")
plot(Clust)
p1<-ggdendrogram(Clust, rotate=TRUE)
p1



attach(Inventario)
Tabla1a <- aggregate(Inventario[,-c(1:12)], by=list(Labranza, Tecnica), FUN=sum, na.rm = T)
dim(Tabla1a)
detach(Inventario)
names(Tabla1a)
names(Tabla1a)[1:2] <- c("Labranza", "Tecnica")
Factor1 <- paste(Tabla1a[,1],Tabla1a[,2], sep=".")
Tabla1b <- data.frame(Tabla1a[,-c(1,2)])


#############################################
##############Para Rarefraccion
#Variable "Tabla" debe tener el mismo numero de renglones que la variable "factor"
#Variable "factor" debe tener distinto nombre



RarefraccionCC <- function(Tabla,factor){
  require(vegan)
  Tabla1 <- data.frame(Tabla, row.names=factor)
  raremax <- min(rowSums(Tabla1))
  col1 <- seq(1:nrow(Tabla1)) #Para poner color a las lineas
  lty1 <- c("solid","dashed","longdash","dotdash")
  rarecurve(Tabla1, sample = raremax, col = "black", lty=lty1, cex = 0.6)
  #Para calcular el numero de especies de acuerdo a rarefraccion
  UUU <- rarefy(Tabla1, raremax)
  print(UUU)
}
RarefraccionCC(Tabla1b,Factor1)

#############################################
####Para Calcular Renyi#######
#Variable "Tabla" debe tener el mismo numero de renglones que la variable "factor"
#Variable "factor" debe tener distinto nombre


RenyiCC <- function(Tabla, factor){
  require(vegan) #Paquete para la funcion "renyi"
  require(ggplot2)#Paquete para hacer la funcion "qplot"
  require(reshape)#Paquete para la funcion "melt"
  Tabla <- data.frame(Tabla, row.names=factor)
  mod <- renyi(Tabla)
  vec <- seq(1:11)
  mod1 <- data.frame(vec,t(mod))
  mod2 <- melt(mod1, id=c("vec"))
  mod2
  #mod2$variable <- as.numeric(mod2$variable)
  orange <- qplot(vec, value, data = mod2, colour = variable, geom = 	"line")+theme_bw()
  orange+scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10,11), 		labels=c("0","0.25","0.5","1","2","4","8","16","32","64","Inf"))
}

RenyiCC(Tabla1b,Factor1)


