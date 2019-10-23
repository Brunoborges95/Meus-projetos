import matplotlib.pyplot as plt
import numpy as np
import tensorflow as tf


(prev_trein, class_trein),(prev_test,class_test)=tf.keras.datasets.mnist.load_data()

prev_trein=prev_trein.astype('float32')/255
prev_test=prev_test.astype('float32')/255

class_dummy_trein=tf.keras.utils.to_categorical(class_trein)
class_dummy_test=tf.keras.utils.to_categorical(class_test)

prev_trein=prev_trein.reshape(len(prev_trein),np.prod(prev_trein.shape[1:]))
prev_test=prev_test.reshape(len(prev_test),np.prod(prev_test.shape[1:]))
#o autoencoder vai codficar e decodificar a imagem, depois comparando a imagem codificada com a decodificada
autoencoder=tf.keras.models.Sequential()
autoencoder.add(tf.keras.layers.Dense(units=32,activation='relu', input_dim=784)) #layer[0] codifica
autoencoder.add(tf.keras.layers.Dense(units=784, activation='sigmoid'))#layr[1] decodifica
autoencoder.summary()
autoencoder.compile(optimizer='adam',loss='binary_crossentropy',metrics=['accuracy'])
autoencoder.fit(prev_trein,prev_trein,batch_size=256,epochs=50,validation_data=(prev_test,prev_test))

dim_original=tf.keras.layers.Input(shape=(784,))
camada_encoder=autoencoder.layers[0]
#o modelo encoder recebe como input dim_original e como output a camada_encoder
encoder=tf.keras.models.Model(dim_original,camada_encoder(dim_original))

#codificando os previsores
prev_trein_cod=encoder.predict(prev_trein)
prev_test_cod=encoder.predict(prev_test)

#classificação sem redução dimensionalidade
c1=tf.keras.Sequential()
#definir o numero de neurnios como (entrada+saida)/2=(784+10)/2
c1.add(tf.keras.layers.Dense(units=397,activation='relu',input_dim=784))
c1.add(tf.keras.layers.Dense(units=397,activation='relu'))
c1.add(tf.keras.layers.Dense(units=10,activation='softmax'))
c1.compile(optimizer='adam',loss='categorical_crossentropy', metrics=['accuracy'])
c1.fit(prev_trein.reshape(60000,784),class_dummy_trein, batch_size=256, epochs=100,validation_data=(prev_test.reshape(10000,784),class_dummy_test))


#classificação com redução dimensionalidade
c1=tf.keras.Sequential()
#definir o numero de neurnios como (entrada+saida)/2=(784+10)/2
c1.add(tf.keras.layers.Dense(units=397,activation='relu',input_dim=32))
c1.add(tf.keras.layers.Dense(units=397,activation='relu'))
c1.add(tf.keras.layers.Dense(units=10,activation='softmax'))
c1.compile(optimizer='adam',loss='categorical_crossentropy', metrics=['accuracy'])
c1.fit(prev_trein_cod,class_dummy_trein, batch_size=256, epochs=100,validation_data=(prev_test_cod,class_dummy_test))
