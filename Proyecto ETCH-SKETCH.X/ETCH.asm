;##################################### PABLO DARD”N ##############################
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 17320 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥ PROYECTO ETCH A SKETCH ¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥
#include "p16f887.inc"

; CONFIG1
; __config 0xFCD4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
 
GPR_VAR	    UDATA
ADC_value   RES 1
BANDERA	    RES 1
BANDERITA   RES 1
BANDERAS    RES 1
BANDERITAS  RES 1


RES_VECT    CODE    0X0000
    GOTO    SETUP
   
MAIN_PROG CODE                      ; let linker place main program

SETUP
    CALL    CONFIG_OSCILATOR		; configurar el oscilador a 4MHz
    CALL    CONFIG_IO			; TRIS0 como entrada, ANSEL0 como anal√≥gica
    ;CALL    CONFIG_ADC			; canal 0, fosc/8, adc on, justificado a la izquierda, Vref interno (0-5V)
   
LOOP:
    CALL    CONVERTIDORES
    CALL    DELAY_500US			; delay 
    BSF    ADCON0, GO			; EMPIECE LA CONVERSI√?N
    BTFSC   ADCON0, GO			; revisa que termin√≥ la conversi√≥n
    GOTO    $-1
    MOVF    ADRESH, W
    MOVWF   ADC_value
    CALL    CONTBIN
    GOTO    LOOP
;------------------------------SUBRUTINAS---------------------------------------
 
CONVERTIDORES:
    BCF	    PORTD, RD0
    BCF	    PORTD, RD1
    BTFSC   BANDERA, 0
    GOTO    CONVERTIDOR_1
CONVERTIDOR_0:
    BSF	    PORTD, RD1
    GOTO    CONV_FIN
CONVERTIDOR_1:
    BSF	    PORTD, RD0
    GOTO    CONV_FIN
CONV_FIN:    
    CALL    CONV_B0
    RETURN
CONV_B0:
    BTFSS   BANDERA, 0
    GOTO    COG_0
COG_1:
    BCF	    BANDERA, 0
    RETURN
COG_0:
    BSF	    BANDERA, 0
    RETURN
    
DELAY_500US:
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RETURN
;----------------------------CONFIGURACIONES----------------------------------    
CONFIG_IO:
    BANKSEL TRISA
    CLRF    TRISA
    COMF    TRISA
    CLRF    TRISB
    CLRF    TRISC
    CLRF    TRISD
    CLRF    TRISE
    BANKSEL ANSEL
    CLRF    ANSEL
    COMF    ANSEL
    CLRF    ANSELH
    BANKSEL PORTA
    CLRF    PORTA
    CLRF    PORTB
    CLRF    PORTC
    CLRF    PORTD
    RETURN

CONFIG_ADC0:
    BANKSEL ADCON1
    MOVLW   B'00000000'			;4Mhz oscilador
    MOVWF   ADCON1
    BANKSEL ADCON0
    MOVLW   B'00000001'			;RA0 Y RA1 COMO ENTRADA
    MOVWF   ADCON0
    BSF	    ANSEL,0			;RA0 COMO ANAL”GICO
    RETURN

    
CONFIG_ADC1:
    BANKSEL ADCON1
    MOVLW   B'00000000'			;4Mhz oscilador
    MOVWF   ADCON1
    BANKSEL ADCON0
    MOVLW   B'00000001'			;RA0 Y RA1 COMO ENTRADA
    MOVWF   ADCON0
    BSF	    ANSEL,1			;RA1 COMO ANAL”GICO
    RETURN    
    
CONFIG_OSCILATOR:
    BANKSEL OSCCON
    MOVLW   B'11000001'
    MOVWF   OSCCON
    RETURN
 
    
CONTBIN:
    MOVFW   ADC_value
    CALL    TABLA
    MOVWF   PORTC

TABLA:					;Tabla para codificar valores binarios a display para display de anodo comun. 
    ADDWF   PCL
    RETLW   B'11000000'	;0
    RETLW   B'11111001'	;1
    RETLW   B'10100100'	;2
    RETLW   B'10110000'	;3
    RETLW   B'10011001'	;4
    RETLW   B'10010010'	;5
    RETLW   B'10000010'	;6
    RETLW   B'11111000'	;7
    RETLW   B'10000000'	;8
    RETLW   B'10010000' ;9
















END