# Sujet 1 : Ecrire de l'assembleur



## Exo 1 : 

En utilisant uniquement des OR, AND, NOT, créer un code qui permet de réaliser un XOR.

```assembleur
org 100h

; XOR
mov al,A
not al
mov bl,B
and al,bl
mov cl,A
mov dl,B
not dl
and cl,dl
or al,cl

ret

A db 1010b
B db 1101b

ret
```



## Exo 2 :

En utilisant uniquement le opérations logiques OR, AND, NOT et XOR, créer un additionneur.

```assembleur
org 100h

; additionneur
mov al,A
mov bl,B
xor al,bl
; Z résultat de XOR stocké en al  (A XOR B = Z)
mov cl,C  
and cl,al
; E resultat AND stocké dans cl   (Z AND C = E)
mov dl,C
xor al,dl
; S résultat de XOR stocké en al
; S est la somme  (Z XOR C = S)
mov bl,B
mov dl,A
and bl,dl
; R résultat de AND stocké en bl (B AND A = R)
or cl,bl
;retenue de sortie stockée en cl 


ret

A db 00001111b
B db 00110011b
C db 01010101b

ret
```



## Exo 3 :

Créer un programme qui affiche dans la sortie standard une chaîne de caractère définie dans le code.

```assembleur
org 100h

mov ah,09h
mov dx,Offset msg
int 21h 

msg db "My string$"
```



## Exo 4 :

Créer une boucle qui calcule et affiche les chiffres de 1 à 10.

```asselbleur
org 100h

   MOV CX,1
INCREMENTATION:
   CMP CX,10
   JA FININCREMENTATION
   MOV BX,CX
   SHL BX,1
   INC CX
   JMP INCREMENTATION
FININCREMENTATION:
```

