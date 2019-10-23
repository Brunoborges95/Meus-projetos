
import pandas as pd
import numpy as np
import xgboost
from sklearn.preprocessing import LabelEncoder,OneHotEncoder
from sklearn.model_selection import train_test_split
import datetime
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error
from sklearn.ensemble import RandomForestRegressor
from sklearn.svm import SVR
from sklearn.neural_network import MLPRegressor


#Leio a base de dados ajustando o formato das variáveis com data
base=pd.read_csv('Previsibilidade de Alta - Base 1.csv',sep=';', parse_dates=['Data Entrada Atendimento','Data Alta Atendimento','Nascimento Paciente'], 
    date_parser=lambda x: pd.to_datetime(x, format='%d/%m/%Y %H:%M'))
#Removo duplicações no id de atendimento.
base=base.drop_duplicates(['Atendimento'])


#Adiciono um variável para encontrar a idade do paciente. (Uma sugestão seria categorizá-los por faixa etária)
idade=base['Data Entrada Atendimento'] - base['Nascimento Paciente']
#idade que o paciente tinha quando deu entrada no atendimento
idade=pd.to_timedelta(idade)
idade=idade/pd.offsets.Minute(1)
base['Idade']=idade/365

#Separo a base em dois tipo: Entre os pacientes que vão fazer uma cirurgia e aqueles que não vão
base_semcirurgia=base.loc[base['Cód Cirurgião']==-1]
#Houve muitas dados repetidos, o que reduziu o tamanho dos dados para pacientes que vão fazer cirurgia
base_comcirurgia=base.loc[base['Cód Cirurgião']!=-1]

#Escolho previsores mais adequados. Exclui variáveis óbvias como numero de atendimento e outras que poderiam prejudicar o desempenho do modelo.
#Outras variáveis são muito correlacionadas daí escolho apenas uma delas. Como tirei pacientes que vão fazer cirurgias muitas variáveis acabam ficando nulas
previsores1=base_semcirurgia.iloc[:,[2,4,5,8,10,12,13,14,18,15,20,21,22,23,24,25,37]]

#preencho valores nan com ). Isso servi´ra como uma nova categoria
previsores1= previsores1.fillna(0).values
#Para categorizar preciso transformar todos as variáveis (com exceção da idade) em strings
previsores1[:,[0,1,2,3,4,5,6,7,8,9,10,11,12,13]] = previsores1[:,[0,1,2,3,4,5,6,7,8,9,10,11,12,13]].astype(str)
#output da tabela, o que quero prever, tempo de atendimento dado em dias (sugestão categorizar o output em intervalos de 24 horas e transformar em um problema de classificação)
#Transformar o modelo num problema de classificação poderia ser até mais interessante
regressor1=base_semcirurgia['Data Alta Atendimento']-base_semcirurgia['Data Entrada Atendimento']
regressor1 = pd.to_timedelta(regressor1)
regressor1=(regressor1/pd.offsets.Minute(1))
regressor1=regressor1/1440
#categorização das variáveis
labelencoder_previsores = LabelEncoder()
variaveis_categoricas=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
for i in variaveis_categoricas:
    previsores1[:,i] = labelencoder_previsores.fit_transform(previsores1[:,i])
    
ase3=pd.DataFrame(previsores1)
#verificar correlação entre as variáveis
base3.corr(method='pearson')
DeSC=base3.describe()
base3.values

#verifiquei quetransofrmar em variáveis dummy melhora o resultado (nova tabela com 517 variáveis)    
onehotencoder = OneHotEncoder(categorical_features = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])
previsores1 = onehotencoder.fit_transform(previsores1).toarray()

#Comparei normalizar as categorias com one hot encoder e obtive um resultado pior. Não aplicar o StandarScaler 
#scaler_x = StandardScaler()
#previsores1 = scaler_x.fit_transform(previsores1)
 #sepra entre base de dados de treinamento e validação (10% para validação)(Sugestão cross-validation com 10 etapas)   
X1_treinamento, X1_teste, y1_treinamento,y1_teste = train_test_split(previsores1, regressor1, test_size=0.1, random_state=0)

"""
O XGBoost é um ótimo algoritmo. Devido ao tempo excessivo de processamento não consegui performar o modelo
regressorXGBoost = xgboost.XGBRegressor(colsample_bytree=0.4,
                 gamma=0,                 
                 learning_rate=0.07,
                 max_depth=3,
                 min_child_weight=1.5,
                 n_estimators=10000,                                                                    
                 reg_alpha=0.75,
                 reg_lambda=0.45,
                 subsample=0.6,
                 seed=42)
regressorXGBoost.fit(X1_treinamento, y1_treinamento)
"""
"""
from keras.wrappers.scikit_learn import KerasRegressor
regressor = KerasRegressor(build_fn = criar_rede,
                           epochs = 100,
                           batch_size = 300)
resultados = cross_val_score(estimator = regressor,
                             X = previsores, y = preco_real,
                             cv = 10, scoring = 'mean_absolute_error')
"""
#Suport Vector Regressor com kernel linear e restrição -6. Melhor resultado MAE=2.86
#Aplico Random Forest com 500 árvores. MAE=3.35
regressorRF = RandomForestRegressor(n_estimators = 500)
regressorRF.fit(X1_treinamento, y1_treinamento)
previsoesRF = regressorRF.predict(X1_teste)

regressorSVR = SVR(kernel = 'linear',gamma='auto',C=6,verbose=True)
regressorSVR.fit(X1_treinamento, y1_treinamento)
previsoesRF = regressorSVR.predict(X1_teste)

#REdes neurais com 128 neurônios na camada oculta (Sugestão: Usar o Tensorflow). MAE igual a 4.27
regressorMLP = MLPRegressor(hidden_layer_sizes = (128,128))
regressorMLP.fit(X1_treinamento, y1_treinamento)
previsoesMLP = regressor.predict(X1_teste)

score = regressor.score(X1_treinamento, y1_treinamento)
maeRF = mean_absolute_error(y1_teste, previsoesRF)
maeSVR = mean_absolute_error(y1_teste, previsoesSVR)
maeSMLP = mean_absolute_error(y1_teste, previsoesMLP)



#Base com pacientes que fizeram cirurgia
previsores2=base_comcirurgia.iloc[:,[2,4,5,8,10,12,13,14,18,15,20,21,22,23,24,25,27,28,30,31,32,33,34,35,36,37]]
previsores2= previsores2.fillna(0).values
previsores2[:,0:26] = previsores2[:,0:26].astype(str)



regressor2=base_comcirurgia['Data Alta Atendimento']-base_comcirurgia['Data Entrada Atendimento']
regressor2 = pd.to_timedelta(regressor2)
regressor2=regressor2/pd.offsets.Minute(1)
regressor2=regressor2/1440
variaveis_categoricas=list(range(25))
for i in variaveis_categoricas:
    previsores2[:,i] = labelencoder_previsores.fit_transform(previsores2[:,i])
base3=pd.DataFrame(previsores2)
base3.describe()
    
base3=pd.DataFrame(previsores2)
scaler_x = StandardScaler()
previsores2 = scaler_x.fit_transform(previsores2)
X2_treinamento, X2_teste, y2_treinamento,y2_teste = train_test_split(previsores2, regressor2, test_size=0.25, random_state=0)

#Para o random forest MAE=1.44
regressorRF.fit(X2_treinamento, y2_treinamento)
previsoes2RF = regressorRF.predict(X2_teste)

#Para o SVR, MAE=1.511
regressorSVR.fit(X2_treinamento, y2_treinamento)

previsoes2SVR = regressorSVR.predict(X2_teste)

mae_2RF = mean_absolute_error(y2_teste, previsoes2RF)
mae_2SVR = mean_absolute_error(y2_teste, previsoes2SVR)
