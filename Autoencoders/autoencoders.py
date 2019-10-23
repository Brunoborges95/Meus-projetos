import matplotlib.pyplot as plt
import numpy as np
import tensorflow as tf

(prev_trein, _),(prev_test,_)=tf.keras.datasets.mnist.load_data()

prev_trein=prev_trein.astype('float32')/255
prev_test=prev_test.astype('float32')/255

prev_trein=prev_trein.reshape(len(prev_trein),np.prod(prev_trein.shape[1:]))
prev_test=prev_test.reshape(len(prev_test),np.prod(prev_test.shape[1:]))
#o autoencoder vai codficar e decodificar a imagem, depois comparando a imagem codificada com a decodificada
autoencoder=tf.keras.models.Sequential()
autoencoder.add(tf.keras.layers.Dense(units=32,activation='relu', input_dim=784)) #layer[0] codifica
autoencoder.add(tf.keras.layers.Dense(units=784, activation='sigmoid'))#layr[1] decodifica
autoencoder.summary()
autoencoder.compile(optimizer='adam',loss='binary_crossentropy',metrics=['accuracy'])
autoencoder.fit(prev_trein,prev_trein,batch_size=256,epochs=100,validation_data=(prev_test,prev_test))

dim_original=tf.keras.layers.Input(shape=(784,))
camada_encoder=autoencoder.layers[0]
#o modelo encoder recebe como input dim_original e como output a camada_encoder
encoder=tf.keras.models.Model(dim_original,camada_encoder(dim_original))
encoder.summary()

#codificação
im_codificada=encoder.predict(prev_test)
#decocdificação
im_decodificada=autoencoder.predict(prev_test)


numero_imagens= 10
imagens=np.random.randint(prev_test.shape[0], size=numero_imagens)

#visualização da imagem codificada
im_gerada_teste=[]
im_codificada_teste=[]
for i, n in enumerate(imagens):
    im_gerada_teste.append(prev_test[i].reshape(28,28))
    im_codificada_teste.append(im_codificada[i].reshape(4,8))
    
    
