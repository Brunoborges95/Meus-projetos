

install.packages('expert')
library('expert')

X<-list(EXP1<-list(SEM1<-c(75,80,85),SEM2<-c(10,15,20),INT<-c(650,800,850)),
        EXP2<-list(SEM1<-c(80,90,95),SEM2<-c(25,30,35),INT<-c(500,600,700)),
        EXP3<-list(SEM1<-c(65,70,80),SEM2<-c(20,25,30),INT<-c(450,650,800)))

X2<-list(EXP1<-list(INT<-c(650,800,850)),
        EXP2<-list(INT<-c(500,600,700)),
        EXP3<-list(INT<-c(450,650,800)))
#quantis
prob_quantil<-c(0.1,0.5,0.9)

#valoraes verdadeiros
semverd<-c(80,25)

#modelo e inferência
inf<-expert(X,'ms',prob,semverd)
hist(inf)
inf_manual<-expert(X2,'weights',prob_quantil,w=c(.1,.7,.2))
hist(inf_manual)

