
import serial
import time
import sys

#COMUNICACION SERIAL DE PIC CON LA CUMPU

# Configurar el puerto serial. Elejir el puerto en el que aparece en su computadora y la velocidad
ser= serial.Serial(port='COM4',baudrate=9600, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE,bytesize=serial.EIGHTBITS, timeout=0)

# loop infinito
while 1:
    #borrar el buffer para iniciar en cero
    ser.flushInput()
    ser.flushOutput()
    #esperar un tiempo para recibir datos
    time.sleep(.3)
    #leer dato serial
    recibido1=ser.read() #readline lee hasta encontrar el enter ASCII "A"h
    #escribir dato serial
    ser.write(recibido1)
    #convertir a número de 8 bits e imprimir el dato recibido
    numero = ord(recibido1)
    print(numero)
    # RECUERDEN CONECTAR EL RX del pic AL TX de la compu
