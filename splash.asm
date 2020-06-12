        output "carga.bin"

    db   #fe               ; ID archivo binario, siempre hay que poner el mismo 0FEh
    dw   INICIO             ; dirección de inicio
    dw   FINAL - 1          ; dirección final
    dw   INICIO               ; dircción del programa de ejecución (para cuando pongas r en bload"nombre_programa", r)

    org 33280               ; org se utiliza para decirle al z80 en que posición de memoria empieza nuestro programa (es la 33280 en decimal), en hezadecimal sería #8200



INICIO:
    ;***********************musica****************/
    di	
	ld		hl,SONG-99		; hl vale la direccion donde se encuentra la cancion - 99
	call	PT3_INIT			; Inicia el reproductor de PT3
	ei
    ;***************Fin de música****************/
    call screen2x16
    call cargar_tiles_colores_y_screen1 ;cargamos la pantalla con la foto de presentación
    call CHGET ;esperamos a que se pulse un tecla, cuando se pulse cambiará la pantalla a screen screen2 (la 1)
    ret



;Es la pantalla con la foto
cargar_tiles_colores_y_screen1:
;Para comprender como se distrivuye la memoria del VDP ir a: https://sites.google.com/site/multivac7/files-images/TMS9918_VRAMmap_G2_300dpi.png
;-----------------------------Tileset -------------------------------------------
    ;screen1 es el splash_screen o pantalla incial con la foto de presentación
    ld hl, tiles_screen1 ; la rutina LDIRVM necesita haber cargado previamente la dirección de inicio de la RAM, para saber porqué he puesto 0000 fíjate este dibujo https://sites.google.com/site/multivac7/files-images/TMS9918_VRAMmap_G2_300dpi.png ,así es como está formado el VDP en screen 2
    ld de, #0000 ; la rutina necesita haber cargado previamente con de la dirección de inicio de la VRAM          
    ld bc, #1800; son los 3 bancos de #800
    ;call  LDIRVM ; Mira arriba, pone la explicación
    call depack_VRAM   
    ;call unpack 
;--------------------------------Colores--------------------------------------
    ld hl, color_screen1
    ld de, #2000 
    ld bc, #1800 ;son los 3 bancos de #800
    ;call  LDIRVM
    call depack_VRAM
    ;call unpack
;------------------------------Mapa o tabla de nombres-------------------------------
    ld hl, map_screen1
    ld de, #1800 
    ld bc, #300
    ;call  LDIRVM
    call depack_VRAM
    ;call unpack   
    ret
;*************************Final de cargar_pantalla_screen1 la de la foto**********************





   
inicializar_modo_pantalla:
    ;Cambiamos el modo de pantalla
    ld  a,2     ; La rutina CHGMOD nos obliga a poner en el registro a el modo de pantalla que queremos 
    call CHGMOD ; Mira arriba, pone la explicación, pone screen 2 y sprite de 16 sin apliar
    
    ld a,(RG1SAV) ;en esta dirección está el valor del el 1 registro de soo escritura del VDP, en el se controla el tamaño de los sprites
    or 00000010b ;vamos a obligarle a que trabaje con los sprites de 16 pixeles
    ;or 00000011b
    ;and 11111110b ; lo he comentado porque no quiero grande
    ld b,a 
    ld c,1
    call WRTVDP ;rutina que es escribe el valor en el reistro de solo escritura indicado previamente
    ret

screen2x16:
    ; 	pone los colores de tinta , fondo y borde
	ld      hl,FORCLR
	ld      [hl],15; le poneos el 15 en tinta que es el blanco
	inc     hl
	ld      [hl],1 ; le metemos 1 en fondo que es el negro
	inc		hl
	ld		[hl],1 ;en borde también el negro
	call    CHGCLR

;click off	
	xor	a		
	ld	[CLIKSW],a
		
;- screen 2
	ld a,2
	call CHGMOD;rutina de la bios que cambia el modo de screen

	;sprites no ampliados de 16x16
	ld b,0xe2
	ld c,1
	call 0x47

	ret

;************************************Final de inicializar_modo_pantalla********************

;Este include lleva la rutina de descompresion de los archivos a VRAM
;Hay que meterle previamente en el reg. hl la dirección de la RAM y en DE la VRAM
depack_VRAM:
    include "src/PL_VRAM_Depack.asm"

include "src/bios.asm"

;Este include lleva dentro la rutina depack para descomprimir archivos en ram
;la rutina unpack necesita que le metas previamente en el reg. hl la dirección de lso datos que uieres descomprimir y en de la direccion de la RAM
include "src/unpack.asm"






;Esta es la pantalla con la foto
tiles_screen1:
    incbin "src/screens/screen1/screen1.bin.chr.plet5"
color_screen1:
    incbin "src/screens/screen1/screen1.bin.clr.plet5"
map_screen1: 
    incbin "src/screens/screen1/screen1.bin.plet5"



;**********************************************/
;*********VARIABLES DEL SISTEMA****************/
;**********************************************/


screen_actual: db 0


buffer_de_colsiones: ds 768 ;es el mapa o tabla de nombres de VRAM copiada aquí

	include	"src/PT3_player.s"					;replayer de PT3
SONG:
	incbin "src/cancion2.pt3"			;musica de ejemplo




FINAL:











