1 ' Programa MSX Murcia 2020 / Program MSX Murcia 
1 ' MSX Basic'
1 ' Inicialización de 0-500 (Inicialización player e incialización enemigos está en 10000 y 20000)
1 ' Main de 1000-2000'
1 ' 5000-10000 Rutinas generales: sistema renderizado, captura teclado,etc ' 
1 ' Rutinas jugador 10000-20000'
1 ' Rutinas enemigo 20000-30000'



1 '------------------------'
1 '     Inicializando'
1 '------------------------'
1 ' Borramos la pantalla'
5 cls
1 ' Lo 1 es definir el color de caracteres blanco, fondo y margen
10 color 15,0,0
1 ' Lo 2 es comfigurar la pantalla con screen modo_video, tamaño_sprites'
1 ' el tamaño_sprite puede ser 0 (8x8px), 1 (8x8px ampliado), 2 (16x16 x), 3 (16x16px) ampliado'
20 screen 5,2
1 ' Desactivamos el sonido de las teclas
30 key off
1 ' Habilitamos las interrupciones con la barra espaciadora como disparo (si pones 1 el disparo es el joystyck) 
40 strig(0) on
1' Defimos a basic que haga que las variables de empiezan desde la a a la z sean enteras de 16 bits, en lugar de las de 32 que asigna por defecto
45 defint a-z
1 ' j representa el mvimeitno de l joystick
50 let j=0
1 ' k$ representa la tecla pulsada
60 let k$=""
1 ' Esta variable la utilizamos para cambiarle el sprite o plano al personaje / caza
80 let sp0=0
1 ' posicion personaje protagonista x e y
90 let px=10: let py=100
1 ' Vida del jugador / personaje / caza
100 let pv=180
1 ' Tiempo para completar la mision' 
110 get time ti$
1 ' Posicion fuego x, posicion fuego y y disparo activo'
130 fx=100: fy=100: da=0
1 ' variable de ayuda para el scrol'
140 let pp=0



1 '------------------------'
1 '       main'
1 '------------------------'
1 'Subrutina cargar fondo'
1010 gosub 8000
1 ' Cuando se pulse el botón de disparo (leer el manual MSX interrupciones on strig gosub ) ...'
1020 on strig gosub 11200
1 'Llamamos a la subrutina para poner nuestro sprite en la tabla patrones de sprite y color sprite'
1030 gosub 10000
1 ' Creamos un flujo para poder pintar en la pantalla, esto afectará a los input y print que tenga #numero'
1040 open "grp:" for output as #1
1 ' Subrutina mostrar información del juego'
1060 gosub 7000

   

1' Inicio blucle
    1 'Llamamos a la subrutina actualizar sprite personaje'
    2050 gosub 11000
    1 'llamamos a la subrutina para capturar el teclado'
    2060 gosub 5000
    1 ' Llamamos a la subrutina de los cursores / joystick
    2070 gosub 6000 
    1' Llamamos a la subrutina scroll horizontal de la carretera
    2080 gosub 8100
    1' Rutina actualiza disparo
    2090 gosub 11300
 1 ' El goto es como una especie de while para que vuelva  capturar el teclado y dibujar'
2100 goto 2050



1 '-----------------------------------------------------------------'
1 '---------------------General rutines------------------------------'
1 '-----------------------------------------------------------------'
1 '------------------------'
5000 'Subrutina de captura de teclado'
1 '------------------------'
    5010 k$=inkey$
    1 ' Mover jugador a la izquirda
    5020 if k$="o" then gosub 11090
    1 ' Mover jugador a la dereacha
    5030 if k$="p" then gosub 11050
    1 ' Mover jugeador abajo'
    5040 if k$="q" then gosub 11130
    1 ' Mover jugador arriba
    5050 if k$="a" then gosub 11170  
5080 return

1 ' ----------------------'
6000 'Subrutina captura movimiento joystick / cursores y boton de disparo'
1 ' ----------------------'
    1'1 Arriba, 2 arriba derecha, 3 derecha, 4 abajo derecha, 5 abajo, 6 abajo izquierda, 7 izquierda, 8 izquierda arriba
    6010 j=stick(0)
    6020 if j=3 then  gosub 11050
    6030 if j=7 then  gosub 11090
    6040 if j=1 then  gosub 11130
    6050 if j=5 then  gosub 11170
6080 return


1 ' Subrutina mostrar información
    1 ' Pintamos un rectangulo en la parte superior de la pantalla', color 14 gris claro, bf es un rectangulo relleno
    7000 line (0,0)-(256, 10), 14, bf
    7010 preset (10,0)
    7020 print #1, chr$(215)"  V: "pv"%  libres:"fre(0)
7030 return


1 ' Subrutina cargar fondo en 
    1 'Con esto vamos a cambiar la paleta de colores'
    8000 data 2,2,3,3,3,3,5,1,1,2,5,2,6,2,2,4,4,4,6,3,3,4,6,4
    8010 data 5,5,5,5,6,4,7,4,4,5,6,5,7,5,5,7,7,4,7,6,6,7,7,7
    1 ' Cuando trabajos con subrutinas perdemos el control del puntero read data y tenemos que poner restores linea'
    8020 restore 8000
    8030 FOR C=0 TO 15:READ R,G,B:COLOR=(C,R,G,B):NEXT
    1' lo metemos en la paginas 2
    8040 BLOAD"PAISAJE2.SC5",S,32768
    1 ' Copio las montañas de la página 1 a la de visualización
    8050 copy (0,0)-(255,210),1 to (0,0),0
    1'Copiamos las montañas
    8060 color=restore
8070 return 



1 ' Scrool horizontal de la carretera'
    1 'pp es una variable de ayda para el sroll
    8100 pp=pp+1
    1 'Cielo
    8120 if pp=255 then pp=0
    1 ' Copiamos la caretera que qeruemos que se mueva
    8170 copy  (0, 140)-(230, 180),1 to (256-pp,140)
8190 return
    


1 ' ------------------------------------------------------------------------------'
1 ' ----------------Rutinas plaer y disparo---------------------------------------'
1 ' ------------------------------------------------------------------------------'


1 '------------------------'
10000 'Subrutina definiendo nuestro sprite'
1 '------------------------'
    
    1 'Aquí le estamos definiendo el sprite 0 en la "tabla patrones de sprites" '
    1' El -1 es porque el bucle debe el 0 también se cuenta en el bucle
    10005 s=base(29)
    10010 for i=0 to (32*5)-1
        10020 read a
        10030 vpoke s+i,a
    10040 next i
    1' Sprite 0 caza mirando a la derecha
    10060 data 0,0,0,32,32,48,56,31
    10070 data 63,63,7,7,63,0,0,0
    10080 data 0,0,0,0,0,0,56,252
    10090 data 255,240,224,192,192,0,0,0 
    1 ' Sprite 1 raya
    10160 data 0,0,0,0,0,0,0,255
    10170 data 255,0,0,0,0,0,0,0
    10180 data 0,0,0,0,0,0,0,255
    10190 data 255,0,0,0,0,0,0,0
    1 ' Sprite 2 caza con las alas desplegadas
    10250 data 63,31,14,15,3,3,7,127
    10260 data 127,7,3,7,15,14,31,63
    10270 data 192,0,0,0,128,128,240,255
    10280 data 248,240,128,128,0,0,0,192
    1 ' Sprite 3 caza con las alas plegadas
    10350 data 0,0,0,0,0,63,7,127
    10360 data 127,7,63,0,0,0,0,0
    10370 data 0,0,0,0,0,192,240,255
    10380 data 248,240,192,0,0,0,0,0
    1 ' Sprite bala / disparo'
    10400 data 0,0,0,0,0,1,0,0
    10410 data 0,0,1,0,0,0,0,0
    10420 data 0,0,0,0,0,128,192,96
    10430 data 96,192,128,0,0,0,0,0


    1' Rellenamos la tabla de colores del sprite 0 
    10500 for i=0 to (16*4)-1
        10510 read a
        10520 vpoke &h7400+i, a
    10530 next i

    1' color Sprite 0 caza mirando a la derecha
    10540 DATA &H0F,&H05,&H0A,&H0A,&H0B,&H0B,&H05,&H0B
    10550 DATA &H0B,&H0B,&H05,&H0B,&H05,&H05,&H05,&H04
    1 ' Sprite 1 raya
    10560 DATA &H0F,&H05,&H0A,&H0A,&H0B,&H0B,&H05,&H0B
    10570 DATA &H0B,&H0B,&H05,&H0B,&H05,&H05,&H05,&H04
    1 ' Sprite 2 caza con las alas desplegadas
    10580 DATA &H0F,&H05,&H0A,&H0A,&H0B,&H0B,&H05,&H0B
    10590 DATA &H0B,&H0B,&H05,&H0B,&H05,&H05,&H05,&H04
    1 ' Sprite 3 caza con las alas plegadas
    10600 DATA &H0F,&H05,&H0A,&H0A,&H0B,&H0B,&H05,&H0B
    10610 DATA &H0B,&H0B,&H05,&H0B,&H05,&H05,&H05,&H04

10990 return



1 '------------------------'
11000 'Subrutina actualizar personaje'
1 '------------------------'
1 'Aquí le estamos poniendo en la "Tabla atributos de sprite' el plano o sprite 0, la posicion, el color y el sprite, nuestra nave
    11010 put sprite 0,(px,py),,sp0
    1' el sprite 4 es el disparo
    11020 put sprite 4,(fx,fy),6,4
11030 return

1 '------------------------'
11040 'Subrutinas mover '
1 '------------------------'
1 'Mover derecha
    11050 px=px+5
    11060 sp0=0
    11070 if px>=250-16 then px=250-16
11080 return
 1 ' Mover izquierda'
    11090 px=px-5
    1 ' le metemos el sprite 0 qu es el que mira al frente'
    11100 sp0=0
    11110 if px<=0 then px=0
11120 return
1 ' Mover arriba
    11130 py=py-5
    11140 sp0=2
    11150 if py<=10 then py=10
11160 return
1 ' Mover abajo'
    11170 py=py+5
    11180 sp0=3
    11185 if py >=160 then py=160
11190 return

1 ' Rutinas disparo'
    11200 da=0
    11260 fx=px
    11270 fy=py
11280 return

1 ' Subrutina actualiza disparo'
    11300 if da=0 then fx=fx+7
    11310 if fx >=250 then da=1
    11320 'fy=py
11320 return






19999 end