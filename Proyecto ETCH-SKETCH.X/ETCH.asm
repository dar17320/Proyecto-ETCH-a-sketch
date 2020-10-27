;##################################### PABLO DARDÓN ##############################
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 17320 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´ PROYECTO ETCH A SKETCH ´´´´´´´´´´´´´´´´´´´´
#include "p16f887.inc"

; CONFIG1
; __config 0xFCD4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
 
GPR_VAR	    UDATA
ADC		RES	1
W_TEMP		RES	1
STATUS_TEMP	RES	1
DISPLAY_LOW1	RES	1
DISPLAY_HIGH1	RES	1
VAR_DISPLAY1	RES	1
EJE1		RES	1
EJE2		RES	1
BANDERAS	RES	1


RES_VECT    CODE    0x0000		; processor reset vector
    GOTO    START			; go to beginning of program

ISR_VECT    CODE    0x0004              ; vector de interrupcion
PUSH:
    MOVWF   W_TEMP
    SWAPF   STATUS, W
    MOVWF   STATUS_TEMP
ISR:
    BTFSS   INTCON, T0IF
    GOTO    POP
    BCF	    INTCON, T0IF
    MOVLW   .217
    MOVWF   TMR0
    
    CALL    DISPLAY
      
ENCENDER_LED:
    BSF	    PORTA, RA7
    GOTO    POP
APAGAR_LED:
    BCF	    PORTA, RA7
    GOTO    POP
       
POP:
    SWAPF   STATUS_TEMP, W
    MOVWF   STATUS
    SWAPF   W_TEMP, F
    SWAPF   W_TEMP, W
    RETFIE
    
;-------------------------------PRINCIPAL---------------------------------------
MAIN_PROG CODE                     

START:
    CALL    CONFIG_OSCILATOR
    CALL    CONFIG_IO
    CALL    CONFIG_ADC			; canal 0, fosc/8, adc on, justificado a la izquierda, Vref interno (0-5V)
;    CALL    CONFIG_TMR0
;    CALL    CONFIG_INTERRUPT

LOOP:
    CALL    DELAY
    BSF	    ADCON0, GO
    BTFSC   ADCON0, GO
    GOTO    $-1
    MOVFW   ADRESH
    MOVWF   ADC
    CALL    VALORDISP
    CALL    DISPLAY
    GOTO    LOOP

CONFIG_IO:
    BANKSEL TRISA
    CLRF    TRISA
    COMF    TRISA
    CLRF    TRISB
    CLRF    TRISC
    CLRF    TRISD
    BANKSEL ANSEL
    CLRF    ANSEL
    COMF    ANSEL
    BANKSEL PORTA
    CLRF    PORTA
    CLRF    PORTB
    CLRF    PORTC
    CLRF    PORTD
    RETURN

CONFIG_ADC:
    BANKSEL ADCON1
    MOVLW   B'10000000'			;VOLTAJES DE ENTRADA COMO REFERENCIA/DERECHA
    MOVWF   ADCON1
    BANKSEL ADCON0
    MOVLW   B'01000001'			;AN0-ADC ENCENDIDO-FOSC/8
    MOVWF   ADCON0
    RETURN

CONFIG_OSCILATOR:
    BANKSEL OSCCON
    MOVLW   B'01100001'			; OSCILADOR INTERNO 4MHz
    MOVWF   OSCCON
    RETURN

;CONFIG_TMR0:
;    BANKSEL OPTION_REG
;    BCF	    OPTION_REG, T0CS    ;CICLO DE MAQUINA - 
;    BCF	    OPTION_REG, PSA     ;PRESCALER 8 BITS
;    BSF	    OPTION_REG, PS2
;    BSF	    OPTION_REG, PS1
;    BSF	    OPTION_REG, PS0
;    BANKSEL TMR0
;    MOVLW   .12
;    MOVWF   TMR0
;    BCF	    INTCON, T0IF
 ;   RETURN
     
;CONFIG_INTERRUPT:
;    BSF	    INTCON, GIE
;    BSF	    INTCON, T0IE
;    BCF	    INTCON, T0IF
;    RETURN    
    
    
;////////////////////////////////////// FUNCIONES DE LOOP ///////////////////////////////////////////////////////////

DELAY:
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

VALORDISP:
    MOVFW   ADC
    MOVWF   EJE1
    SWAPF   ADC,W
    MOVWF   EJE2

SEPARAR:
   MOVF    EJE1, W
   MOVWF   VAR_DISPLAY1		    ;Crea copia de la variable anterior
   ANDLW   B'00001111'
   MOVWF   DISPLAY_LOW1		    ;Mueve la copia a la variable del display
   ;/////////////////////////// REPITE CON SIGUIENTE VARIABLE //////////////////////////////////////////
   MOVF    EJE2, W
   MOVWF   VAR_DISPLAY1
   ANDLW   B'00001111'
   MOVWF   DISPLAY_HIGH1
   
   RETURN

DISPLAY:
    CLRF    PORTD
    BTFSC   BANDERAS, 0
    GOTO    DISPLAY_1
DISPLAY_0:
    MOVF    DISPLAY_LOW1, W
    CALL    TABLA_7SEG
    MOVWF   PORTC
    BSF	    PORTD, RD0			;selecciona el display
    GOTO    DISP_FINA
DISPLAY_1:
    MOVF    DISPLAY_HIGH1, W
    CALL    TABLA_7SEG
    MOVWF   PORTC
    BSF	    PORTD, RD1
    GOTO    DISP_FINA
DISP_FINA:    
    CALL    TOGGLE_A0
    RETURN
   
    
TOGGLE_A0:
    BTFSS   BANDERAS, 0
    GOTO    TOG_A0
TOG_A1:
    BCF	    BANDERAS, 0
    RETURN
TOG_A0:
    BSF	    BANDERAS, 0
    RETURN



TABLA_7SEG:					;Tabla para codificar valores binarios a display para display de anodo comun. 
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