install.packages("devtools")
devtools::install_github("luca-scr/GA")
library(GA)
install.packages('GA')

f<-function(x) 
{
  resultado=2*x+5
  if (resultado<20)
  {
  return(resultado-20)
  }
  else
  {
    return (20-resultado)
  }
}
  
resultado=ga('real-valued',fitness = f,min=c(-20),max=c(20),popSize = 10,maxiter = 20,monitor = 1, names=c('a'))
summary(resultado)$solution
plot(resultado)


mochila=data.frame(item=c('canivete','feijão','batatas','lanterna','saco de dormir','corda','bussola'),pontos=c(10,20,15,2,30,10,30),peso=c(1,5,10,1,7,5,1))

item<-function(y)
{
  pontos=0;
  peso=0;
  for (i in 1:7)
  {
    if (y[i]!=0)
    {
      pontos=pontos+mochila[i,2]
      peso=peso+mochila[i,3]
    }
  }
if (peso>15)
  {
  pontos=0
  }
  return(pontos)
}

resultado2=ga('binary',fitness = item,nBits = 7,popSize = 10,maxiter = 200,monitor = 1, names=c('canivete','feijão','batatas','lanterna','saco de dormir','corda','bussola'))
summary(resultado2)
plot(resultado2)


mapa<-read.csv(file.choose(),header = T,sep=';')

cidade<-function(z)
{
  dist=0
  for (i in 1:4)
  {
   cidade1=z[i]
   cidade2=z[i+1]
   dist=dist+mapa[cidade1,cidade2]
  }
   return(-dist)
}

resultado3<-ga(type='permutation',fitness = cidade,min=c(1,1,1,1,1),max=c(5,5,5,5,5),popSize = 10,maxiter = 5,monitor = 1,names = c('lindem','parika','lethem','rosignol','mew armsterdan'))
summary(resultado3)
              