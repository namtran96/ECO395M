library(plyr)
library(tidyverse)
library(FNN)
library(gridExtra)

####################### PART 1 #######################

greenbuildings = read.csv('../Data Files/greenbuildings.csv')

g1 <- ddply(greenbuildings, "green_rating", summarise, rent.mean=mean(Rent), leasing.mean=mean(leasing_rate), gas.mean=mean(Gas_Costs), electric.mean=mean(Electricity_Costs), age.mean=mean(age))
c3 = c("A","B")
g1 = cbind(g1,c3)
bar1 <- ggplot(g1, aes(green_rating, rent.mean,fill = c3)) +
  geom_bar(stat='identity',width= .75) +
  scale_x_continuous(breaks = seq(0,1)) +
  scale_fill_manual("legend", values = c("A" = "gray27", "B" = "forestgreen")) +
  labs(
    title = "Higher rent in green buildings",
    x = "Green Status",
    y = "Rent"
  ) +
  theme_classic()+
  theme(axis.title.x=element_blank())+
  theme(legend.position = "none")


bar2 <- ggplot(g1, aes(green_rating,leasing.mean, fill = c3)) +
  geom_bar(stat='identity',width= .75) +
  scale_x_continuous(breaks = seq(0,1)) +
  scale_fill_manual("legend", values = c("A" = "gray27", "B" = "forestgreen")) +
  labs(
    title = "Higher leasing rates in green buildings",
    x = "Green Status",
    y = "Leasing Rates"
  ) +
  theme_classic()+
  theme(axis.title.x=element_blank())+
  theme(legend.position = "none")


bar3 <- ggplot(g1, aes(green_rating, gas.mean, fill = c3)) +
  geom_bar(stat='identity',width= .75) +
  scale_x_continuous(breaks = seq(0,1)) +
  scale_fill_manual("legend", values = c("A" = "gray27", "B" = "forestgreen")) +
  labs(
    title = "Lower gas costs in green buildings",
    x = "Green Status",
    y = "Gas Costs" 
  ) +
  theme_classic()+
  theme(axis.title.x=element_blank())+
  theme(legend.position = "none")


bar4 <-ggplot(g1, aes(green_rating, electric.mean, fill= c3)) +
  geom_bar(stat='identity',width= .75 ,aes(fill = )) +
  scale_x_continuous(breaks = seq(0,1)) +
  scale_fill_manual("legend", values = c("A" = "gray27", "B" = "forestgreen")) +
  labs(
    title = "Higher electricity costs in green buildings",
    y = "Electricty Costs"
  ) +
  theme_classic()+
  theme(axis.title.x=element_blank())+
  theme(legend.position = "none")

grid.arrange(bar1,bar2,bar4,bar3, ncol=2, nrow=2) #first set of graphs

greenbuildings = greenbuildings %>%
  mutate(age.quantile = ntile(age,10))
greenbuildings$age.quantile = factor(greenbuildings$age.quantile)

g2 <- ddply(greenbuildings, "age.quantile", summarise, age.rent=mean(Rent), age.leasing=mean(leasing_rate))

age.bar <- ggplot(g2, aes(age.quantile, age.rent )) +
  geom_bar(stat='identity',width=.5) +
  theme_light()+
  labs(
    title = "Decreasing rent as age increases",
    y = "Rent",
    x = "Quantile"
  )
  

age.scatter <- ggplot(greenbuildings, aes(age,Rent))+
  geom_point(aes(color = age.quantile)) +
  geom_smooth(se = FALSE,color= "red") +
  scale_color_hue(l=55, c=70) +
  theme_light()+
  theme(legend.position = "bottom")+
  labs(
    title= "",
    y = "Rent",
    x = "Age",
    color='Quantile'
  )

greenbuildings = greenbuildings %>%
  mutate(green.factor = factor(greenbuildings$green_rating))

g3 <- ddply(greenbuildings, "green.factor", summarise, age.mean=mean(age),age.median= median(age))

age.density <- ggplot(greenbuildings, aes(x=age, fill = green.factor)) +
  geom_density(alpha=.4)+
  scale_fill_manual(values=c("#999999", "forestgreen", "#56B4E9"))+
  scale_color_manual(values=c("#999999", "forestgreen", "#56B4E9")) +
  geom_vline(data=g3, aes(xintercept=age.median, color=green.factor),
             linetype="dashed")+
  labs(
    title= "Higher distribution of green ratings in lower age ranges",
    y = "Density",
    x = "Age",
    fill ='Green Rating',
    color = 'Median Age'
  )+
  theme_light()

age.grid = grid.arrange(age.bar,age.scatter,age.density, ncol=3, nrow=1) #second set of graphs


####################### PART 2 #######################

ABIA = read.csv('../Data Files/ABIA.csv')

ABIA= ABIA %>%
  mutate(TimeofDay=
           ifelse(between(ABIA$CRSDepTime,0,600), "Early Morning", 
                  ifelse(between(ABIA$CRSDepTime,601,1200),"Morning" , 
                         ifelse(between(ABIA$CRSDepTime,1201,1800),"Afternoon",
                                ifelse(between(ABIA$CRSDepTime,1801,2400),"Night",0)
                        )
                  )
           )
  )
ABIA$TimeofDay= factor(ABIA$TimeofDay)
g4 <- ddply(ABIA, "TimeofDay", summarise, DelayTime.mean=mean(na.exclude(DepDelay)))


Time.Delay <-ggplot(g4, aes(x = reorder(TimeofDay, -DelayTime.mean), y = DelayTime.mean))+
  geom_bar(stat='identity',width=.5,fill= "lightpink", colour="black") +
  scale_y_continuous(breaks = seq(-2,24,2))+
  labs(
    title = "Increasing delay times throughout the day",
    y = "Departure Delay in Minutes"
  )+
  theme_bw()+
  theme(axis.title.y=element_blank())+
  coord_flip()

ABIA= ABIA %>%
  mutate(Season=
           ifelse(between(ABIA$Month,3,5), "Spring", 
                  ifelse(between(ABIA$Month,6,8),"Summer" , 
                         ifelse(between(ABIA$Month,9,11),"Autumn",
                                ifelse(between(ABIA$Month,1,2)|ABIA$Month == 12,"Winter",0)
                         )
                  )
           )
  )
g5 <- ddply(ABIA, "Season", summarise, DelaySeason.mean=mean(na.exclude(DepDelay)), DelaySeason.median=median(na.exclude(DepDelay)))

Season.Delay <- ggplot(g5, aes(x = reorder(Season, -DelaySeason.mean), y = DelaySeason.mean))+
  geom_bar(stat='identity',width=.5,fill= "tomato1", colour="black") +
  scale_y_continuous(breaks = seq(-2,24,2))+
  labs(
    title = "Decline in delay times during Autumn",
    y = "Departure Delay in Minutes"
  )+
  theme_bw()+
  theme(axis.title.y=element_blank())+
  coord_flip()

Season.Dist <- ggplot(ABIA, aes(x=DepDelay,fill= Season)) +
  geom_density(alpha=.6)+
  scale_fill_manual(values=c("darkorange2", "green3", "yellow", "ivory"))+
  facet_wrap(~Season,nrow = 2)+
  geom_vline(data=g5, aes(xintercept= DelaySeason.mean, color ="Mean"),
             linetype="F1") +
  scale_color_manual(values=c("grey22"))+
  scale_x_continuous(breaks = seq(0,900, 100)) +
  labs(
    title = "Seasonal departure delay distribution",
    y = "Density",
    x = "Departure Delay in Minutes"
  )+
  theme_bw()+
  theme(plot.caption = element_text(hjust = .85, face ="italic")) +
  guides(fill=FALSE)+
  theme(legend.title=element_blank())
g6 <- ddply(ABIA, "Dest", summarise, DelayDest.mean=mean(na.exclude(DepDelay)))
g6 <- na.omit(g6)
Dest.Delay <- ggplot(g6, aes(x = reorder(Dest,DelayDest.mean), y = DelayDest.mean))+
  geom_bar(stat='identity',width=.5,fill= "tomato1", colour="black") +
  labs(
    title = "Worst delay by destination",
    y = "Departure Delay in Minutes"
  )+
  scale_y_continuous(breaks = seq(-10,200,10))+
  theme_grey()+
  theme(axis.title.y=element_blank())+
  theme(text = element_text(size=10),axis.text.y = element_text(angle = 45,hjust = 1,vjust= 0))+
  coord_flip()
grid.arrange(Time.Delay, Season.Delay, Season.Dist, Dest.Delay, nrow = 2, ncol = 2)

####################### PART 3 #######################

sclass = read.csv('../Data Files/sclass.csv')

sclass350 = subset(sclass, trim == '350')

sclass65AMG = subset(sclass, trim == '65 AMG')

N = nrow(sclass350)
N_train = floor(0.8*N)
N_test = N - N_train

N350 = nrow(sclass350)
N_train350 = floor(0.8*N350)
N_test350 = N350 - N_train350

train_ind350 = sample.int(N350, N_train350, replace=FALSE)


D_train350 = sclass350[train_ind350,]
D_test350 = sclass350[-train_ind350,]

D_test350 = arrange(D_test350, mileage)

X_train = select(D_train350, mileage)
y_train = select(D_train350, price)
X_test = select(D_test350, mileage)
y_test = select(D_test350, price)

rmse = function(y, ypred) {
  sqrt(mean(data.matrix((y-ypred)^2)))
}

variables =1
iterations = 100
RMSE350 <- matrix(ncol=variables, nrow=iterations)

for (i in 3:iterations)
{
  knn = knn.reg(train = X_train, test = X_test, y = y_train, k=i)
  ypred_knn = knn$pred
  rmse1 <- rmse(y_test, ypred_knn)
  RMSE350[i,]<-rmse1
}

RMSE350 <-data.frame(RMSE350)
RMSE350<- mutate(RMSE350, k = (1:100))
RMSE350 <- RMSE350[-c(1,2),]
colnames(RMSE350)[colnames(RMSE350)=="RMSE350"] <- "rmse"


N = nrow(sclass65AMG)
N_train = floor(0.8*N)
N_test = N350 - N_train


train_ind = sample.int(N, N_train, replace=FALSE)

D_train = sclass65AMG[train_ind,]
D_test = sclass65AMG[-train_ind,]

D_test = arrange(D_test, mileage)
head(D_test)



X_train1 = select(D_train, mileage)
y_train1 = select(D_train, price)
X_test1 = select(D_test, mileage)
y_test1 = select(D_test, price)

variables =1
iterations = 100
RMSE65AMG <- matrix(ncol=variables, nrow=iterations)

for (i in 3:iterations)
{
  knn = knn.reg(train = X_train1, test = X_test1, y = y_train1, k=i)
  ypred_knn = knn$pred
  rmse2 <- rmse(y_test1, ypred_knn)
  RMSE65AMG[i,]<-rmse2
}

RMSE65AMG <-data.frame(RMSE65AMG)
RMSE65AMG <- mutate(RMSE65AMG, k = (1:100))
RMSE65AMG <- RMSE65AMG[-c(1,2),]
colnames(RMSE65AMG)[colnames(RMSE65AMG)=="RMSE65AMG"] <- "rmse"

ggplot(RMSE65AMG, aes(k , rmse))+
  geom_path(aes(x= k, y = rmse))+
  labs(
    title = "Extremely large rmse as k increases for 350 trim"
  )

ggplot(RMSE350, aes(k , rmse))+
  geom_path(aes(x= k, y = rmse))+
  labs(
    title = "Varying dips in rmse throughout k for 65 AMG trim"
  )

min(RMSE65AMG$rmse)
knnamg = knn.reg(train = X_train1, test = X_test1, y = y_train1, k=4)
ypred_knnamg = knnamg$pred
D_test$ypred_knnamg = ypred_knnamg

p_test = ggplot(data = D_test) + 
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey')+
  geom_path(aes(x = mileage, y = ypred_knnamg), color='red') +
  labs(
    title = "Prediction for 65 AMG"
  )+
  theme_bw()
p_test

min(RMSE350$rmse)
knn350= knn.reg(train = X_train, test = X_test, y = y_train, k=14)
ypred_knn350 = knn350$pred
D_test350$ypred_knn350 = ypred_knn350

p_test1 = ggplot(data = D_test350) + 
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey')+
  geom_path(aes(x = mileage, y = ypred_knn350), color='red') +
  labs(
    title = "Prediction for 350"
  )+
  theme_bw()
p_test1
