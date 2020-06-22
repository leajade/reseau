#  Sujet 2 : Débugger et désassembler des programmes compilés

## Présentation du sujet

Quelques définitions s'imposent :

- débugger

   : exécuter un programme "pas à pas", c'est à dire instruction par instruction

  - cela permet de voir l'état des variables internes au programme en temps réel
  - cela peut aussi permettre de modifier le comportement du programme à la volée, pendant son exécution

- désassembler

   : regarder le code machine (l'assembleur) d'un programme compilé

  - on peut alors étudier la logique interne du programme

Ce sujet sera donc dédié à l'assembleur, mais plutôt sur l'étude de codes déjà écrits, *via* l'utilisation d'outils permettant de débugger ou désassembler des programmes. Ce sont un peu les rudiments d'une discipline de la sécurité offensive appelée *cracking*.

## Préliminaire

- logique booléenne
  - strictement essentiel d'avoir en tête le principe de la logique booléenne
    - valeurs "vrai" ou "faux"
    - opérations logiques "et", "ou" et "non"
- instructions assembleur basique
  - arithmétique
    - ADD, MUL, etc
  - logique
    - AND, OR, NOT

Vous aurez besoin d'un débuggeur et un désassembleur pour ce sujet. Il en existe des tas, je vous conseille :

- débugger : gdb (avec gdb-peda éventuellement)
- désassembleur : ghidra ou IDA

## Exercices

### Hello World

- commencer par coder puis compiler un programme Hello World en C

  - ce programme doit simplement afficher "Hello World!" dans le terminal lorsqu'il est lancé

    ```c
    ➜  Desktop cat hello.c 
    #include <stdio.h>
    int main(){
    	char *str="Hello World";
    	puts(str);
    	return 0;
    }
    ```

    ```bash
    ➜  Desktop gcc hello.c 
    ```
    
    Mon programme compilé de hello.c est a.out
  
- désassembler le programme et mettre en évidence

  - où est stockée la chaîne de caractère "Hello World"

    La chaîne de caractère "Hello World" est stocké dans la mémoire de l'ordinateur.
  
    ```bash
    gdb-peda$ n
    [----------------------------------registers-----------------------------------]
    RAX: 0x100000fa2 ("Hello World")
    RBX: 0x0 
    RCX: 0x7ffeefbffc58 --> 0x7ffeefbffca0 ("executable_path=/Users/leaduvigneau/Desktop/a.out")
    RDX: 0x7ffeefbffbb0 --> 0x7ffeefbffcfa ("SHELL=/bin/sh")
    RSI: 0x7ffeefbffba0 --> 0x7ffeefbffcd8 ("/Users/leaduvigneau/Desktop/a.out")
    RDI: 0x100000fa2 ("Hello World")
    RBP: 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
    RSP: 0x7ffeefbffb60 --> 0x0 
    RIP: 0x100000f6e (<main+30>:	call   0x100000f80)
    R8 : 0x0 
    R9 : 0x0 
    R10: 0x0 
    R11: 0x0 
    R12: 0x0 
    R13: 0x0 
    R14: 0x0 
    R15: 0x0
  EFLAGS: 0x306 (carry PARITY adjust zero sign TRAP INTERRUPT direction overflow)
    [-------------------------------------code-------------------------------------]
     0x100000f5f <main+15>:	lea    rax,[rip+0x3c]        # 0x100000fa2
       0x100000f66 <main+22>:	mov    QWORD PTR [rbp-0x10],rax
     0x100000f6a <main+26>:	mov    rdi,QWORD PTR [rbp-0x10]
    => 0x100000f6e <main+30>:	call   0x100000f80
       0x100000f73 <main+35>:	xor    ecx,ecx
       0x100000f75 <main+37>:	mov    DWORD PTR [rbp-0x14],eax
     0x100000f78 <main+40>:	mov    eax,ecx
       0x100000f7a <main+42>:	add    rsp,0x20
  Guessed arguments:
    arg[0]: 0x100000fa2 ("Hello World")
  [------------------------------------stack-------------------------------------]
    0000| 0x7ffeefbffb60 --> 0x0 
    0008| 0x7ffeefbffb68 --> 0x0 
    0016| 0x7ffeefbffb70 --> 0x100000fa2 ("Hello World")
    0024| 0x7ffeefbffb78 --> 0x4036 ('6@')
  0032| 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
    0040| 0x7ffeefbffb88 --> 0x7fff5a3e53d5 (<dispatch_logfile+2245>:	mov    edi,eax)
    0048| 0x7ffeefbffb90 --> 0x0 
    0056| 0x7ffeefbffb98 --> 0x1 
    [------------------------------------------------------------------------------]
    Legend: code, data, rodata, value
    0x0000000100000f6e in main ()
    ```
  
    La chaine de caractère "Hello World" est stockée dans le registre RDI à l'adresse 0x100000fa2.
  
  - comment elle est affichée dans le terminal
  
    ```bash
    ➜  Desktop ./a.out 
    Hello World
    ```
  

### Winrar crack

Winrar est un programme qui permet de manipuler des archives (`.rar`, `.zip`, etc).

Winrar est un programme payant qui possède une version d'évaluation. Une fois cette période d'évaluation dépassée, le programme nous rappelle régulièrent qu'il est nécessaire d'acheter le produit pour continuer à l'acheter (oupa).

Le but de cette section est de crack Winrar afin d'avoir une version utilisable comme une version achetée. (j'ai testé avec la version que j'avais sous la main : 5.4)

Il existe 10000 tutos pour crack Winrar sur le web, je vous laisse partir sur ça. C'est un peu le cas d'école de référence :)

#memo : 

```
➜  Desktop sudo gdb ./a.out
Password:
GNU gdb (GDB) 9.2
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-apple-darwin18.7.0".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./a.out...
(No debugging symbols found in ./a.out)
gdb-peda$ b main
Breakpoint 1 at 0x100000f54
gdb-peda$ r
Starting program: /Users/leaduvigneau/Desktop/a.out 
[New Thread 0xc03 of process 1526]
[New Thread 0x1703 of process 1526]
[New Thread 0x2903 of process 1526]
warning: `/BuildRoot/Library/Caches/com.apple.xbs/Binaries/Libc_darwin/install/TempContent/Objects/Libc.build/libsystem_darwin.dylib.build/Objects-normal/x86_64/bsd.o': can't open to read symbols: No such file or directory.
warning: `/BuildRoot/Library/Caches/com.apple.xbs/Binaries/Libc_darwin/install/TempContent/Objects/Libc.build/libsystem_darwin.dylib.build/Objects-normal/x86_64/darwin_vers.o': can't open to read symbols: No such file or directory.
warning: `/BuildRoot/Library/Caches/com.apple.xbs/Binaries/Libc_darwin/install/TempContent/Objects/Libc.build/libsystem_darwin.dylib.build/Objects-normal/x86_64/dirstat.o': can't open to read symbols: No such file or directory.
warning: `/BuildRoot/Library/Caches/com.apple.xbs/Binaries/Libc_darwin/install/TempContent/Objects/Libc.build/libsystem_darwin.dylib.build/Objects-normal/x86_64/dirstat_collection.o': can't open to read symbols: No such file or directory.
warning: `/BuildRoot/Library/Caches/com.apple.xbs/Binaries/Libc_darwin/install/TempContent/Objects/Libc.build/libsystem_darwin.dylib.build/Objects-normal/x86_64/err.o': can't open to read symbols: No such file or directory.
warning: `/BuildRoot/Library/Caches/com.apple.xbs/Binaries/Libc_darwin/install/TempContent/Objects/Libc.build/libsystem_darwin.dylib.build/Objects-normal/x86_64/exception.o': can't open to read symbols: No such file or directory.
warning: `/BuildRoot/Library/Caches/com.apple.xbs/Binaries/Libc_darwin/install/TempContent/Objects/Libc.build/libsystem_darwin.dylib.build/Objects-normal/x86_64/init.o': can't open to read symbols: No such file or directory.
warning: `/BuildRoot/Library/Caches/com.apple.xbs/Binaries/Libc_darwin/install/TempContent/Objects/Libc.build/libsystem_darwin.dylib.build/Objects-normal/x86_64/mach.o': can't open to read symbols: No such file or directory.
warning: `/BuildRoot/Library/Caches/com.apple.xbs/Binaries/Libc_darwin/install/TempContent/Objects/Libc.build/libsystem_darwin.dylib.build/Objects-normal/x86_64/stdio.o': can't open to read symbols: No such file or directory.
warning: `/BuildRoot/Library/Caches/com.apple.xbs/Binaries/Libc_darwin/install/TempContent/Objects/Libc.build/libsystem_darwin.dylib.build/Objects-normal/x86_64/stdlib.o': can't open to read symbols: No such file or directory.
warning: `/BuildRoot/Library/Caches/com.apple.xbs/Binaries/Libc_darwin/install/TempContent/Objects/Libc.build/libsystem_darwin.dylib.build/Objects-normal/x86_64/string.o': can't open to read symbols: No such file or directory.
warning: `/BuildRoot/Library/Caches/com.apple.xbs/Binaries/Libc_darwin/install/TempContent/Objects/Libc.build/libsystem_darwin.dylib.build/Objects-normal/x86_64/variant.o': can't open to read symbols: No such file or directory.
[----------------------------------registers-----------------------------------]
RAX: 0x100000f50 (<main>:	push   rbp)
RBX: 0x0 
RCX: 0x7ffeefbffc58 --> 0x7ffeefbffca0 ("executable_path=/Users/leaduvigneau/Desktop/a.out")
RDX: 0x7ffeefbffbb0 --> 0x7ffeefbffcfa ("SHELL=/bin/sh")
RSI: 0x7ffeefbffba0 --> 0x7ffeefbffcd8 ("/Users/leaduvigneau/Desktop/a.out")
RDI: 0x1 
RBP: 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
RSP: 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
RIP: 0x100000f54 (<main+4>:	sub    rsp,0x20)
R8 : 0x0 
R9 : 0x0 
R10: 0x0 
R11: 0x0 
R12: 0x0 
R13: 0x0 
R14: 0x0 
R15: 0x0
EFLAGS: 0x246 (carry PARITY adjust ZERO sign trap INTERRUPT direction overflow)
[-------------------------------------code-------------------------------------]
   0x100000f4e:	add    BYTE PTR [rax],al
   0x100000f50 <main>:	push   rbp
   0x100000f51 <main+1>:	mov    rbp,rsp
=> 0x100000f54 <main+4>:	sub    rsp,0x20
   0x100000f58 <main+8>:	mov    DWORD PTR [rbp-0x4],0x0
   0x100000f5f <main+15>:	lea    rax,[rip+0x3c]        # 0x100000fa2
   0x100000f66 <main+22>:	mov    QWORD PTR [rbp-0x10],rax
   0x100000f6a <main+26>:	mov    rdi,QWORD PTR [rbp-0x10]
[------------------------------------stack-------------------------------------]
0000| 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
0008| 0x7ffeefbffb88 --> 0x7fff5a3e53d5 (<dispatch_logfile+2245>:	mov    edi,eax)
0016| 0x7ffeefbffb90 --> 0x0 
0024| 0x7ffeefbffb98 --> 0x1 
0032| 0x7ffeefbffba0 --> 0x7ffeefbffcd8 ("/Users/leaduvigneau/Desktop/a.out")
0040| 0x7ffeefbffba8 --> 0x0 
0048| 0x7ffeefbffbb0 --> 0x7ffeefbffcfa ("SHELL=/bin/sh")
0056| 0x7ffeefbffbb8 --> 0x7ffeefbffd08 ("TERM=xterm-256color")
[------------------------------------------------------------------------------]
Legend: code, data, rodata, value

Thread 3 hit Breakpoint 1, 0x0000000100000f54 in main ()
gdb-peda$ n
[----------------------------------registers-----------------------------------]
RAX: 0x100000f50 (<main>:	push   rbp)
RBX: 0x0 
RCX: 0x7ffeefbffc58 --> 0x7ffeefbffca0 ("executable_path=/Users/leaduvigneau/Desktop/a.out")
RDX: 0x7ffeefbffbb0 --> 0x7ffeefbffcfa ("SHELL=/bin/sh")
RSI: 0x7ffeefbffba0 --> 0x7ffeefbffcd8 ("/Users/leaduvigneau/Desktop/a.out")
RDI: 0x1 
RBP: 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
RSP: 0x7ffeefbffb60 --> 0x0 
RIP: 0x100000f58 (<main+8>:	mov    DWORD PTR [rbp-0x4],0x0)
R8 : 0x0 
R9 : 0x0 
R10: 0x0 
R11: 0x0 
R12: 0x0 
R13: 0x0 
R14: 0x0 
R15: 0x0
EFLAGS: 0x306 (carry PARITY adjust zero sign TRAP INTERRUPT direction overflow)
[-------------------------------------code-------------------------------------]
   0x100000f50 <main>:	push   rbp
   0x100000f51 <main+1>:	mov    rbp,rsp
   0x100000f54 <main+4>:	sub    rsp,0x20
=> 0x100000f58 <main+8>:	mov    DWORD PTR [rbp-0x4],0x0
   0x100000f5f <main+15>:	lea    rax,[rip+0x3c]        # 0x100000fa2
   0x100000f66 <main+22>:	mov    QWORD PTR [rbp-0x10],rax
   0x100000f6a <main+26>:	mov    rdi,QWORD PTR [rbp-0x10]
   0x100000f6e <main+30>:	call   0x100000f80
[------------------------------------stack-------------------------------------]
0000| 0x7ffeefbffb60 --> 0x0 
0008| 0x7ffeefbffb68 --> 0x0 
0016| 0x7ffeefbffb70 --> 0x7ffeefbffb90 --> 0x0 
0024| 0x7ffeefbffb78 --> 0x100004036 (mov    rdi,QWORD PTR [rbp-0x8])
0032| 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
0040| 0x7ffeefbffb88 --> 0x7fff5a3e53d5 (<dispatch_logfile+2245>:	mov    edi,eax)
0048| 0x7ffeefbffb90 --> 0x0 
0056| 0x7ffeefbffb98 --> 0x1 
[------------------------------------------------------------------------------]
Legend: code, data, rodata, value
0x0000000100000f58 in main ()
gdb-peda$ n
n[----------------------------------registers-----------------------------------]
RAX: 0x100000f50 (<main>:	push   rbp)
RBX: 0x0 
RCX: 0x7ffeefbffc58 --> 0x7ffeefbffca0 ("executable_path=/Users/leaduvigneau/Desktop/a.out")
RDX: 0x7ffeefbffbb0 --> 0x7ffeefbffcfa ("SHELL=/bin/sh")
RSI: 0x7ffeefbffba0 --> 0x7ffeefbffcd8 ("/Users/leaduvigneau/Desktop/a.out")
RDI: 0x1 
RBP: 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
RSP: 0x7ffeefbffb60 --> 0x0 
RIP: 0x100000f5f (<main+15>:	lea    rax,[rip+0x3c]        # 0x100000fa2)
R8 : 0x0 
R9 : 0x0 
R10: 0x0 
R11: 0x0 
R12: 0x0 
R13: 0x0 
R14: 0x0 
R15: 0x0
EFLAGS: 0x306 (carry PARITY adjust zero sign TRAP INTERRUPT direction overflow)
[-------------------------------------code-------------------------------------]
   0x100000f52 <main+2>:	mov    ebp,esp
   0x100000f54 <main+4>:	sub    rsp,0x20
   0x100000f58 <main+8>:	mov    DWORD PTR [rbp-0x4],0x0
=> 0x100000f5f <main+15>:	lea    rax,[rip+0x3c]        # 0x100000fa2
   0x100000f66 <main+22>:	mov    QWORD PTR [rbp-0x10],rax
   0x100000f6a <main+26>:	mov    rdi,QWORD PTR [rbp-0x10]
   0x100000f6e <main+30>:	call   0x100000f80
   0x100000f73 <main+35>:	xor    ecx,ecx
[------------------------------------stack-------------------------------------]
0000| 0x7ffeefbffb60 --> 0x0 
0008| 0x7ffeefbffb68 --> 0x0 
0016| 0x7ffeefbffb70 --> 0x7ffeefbffb90 --> 0x0 
0024| 0x7ffeefbffb78 --> 0x4036 ('6@')
0032| 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
0040| 0x7ffeefbffb88 --> 0x7fff5a3e53d5 (<dispatch_logfile+2245>:	mov    edi,eax)
0048| 0x7ffeefbffb90 --> 0x0 
0056| 0x7ffeefbffb98 --> 0x1 
[------------------------------------------------------------------------------]
Legend: code, data, rodata, value
0x0000000100000f5f in main ()
gdb-peda$ n
[----------------------------------registers-----------------------------------]
RAX: 0x100000fa2 ("Hello World")
RBX: 0x0 
RCX: 0x7ffeefbffc58 --> 0x7ffeefbffca0 ("executable_path=/Users/leaduvigneau/Desktop/a.out")
RDX: 0x7ffeefbffbb0 --> 0x7ffeefbffcfa ("SHELL=/bin/sh")
RSI: 0x7ffeefbffba0 --> 0x7ffeefbffcd8 ("/Users/leaduvigneau/Desktop/a.out")
RDI: 0x1 
RBP: 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
RSP: 0x7ffeefbffb60 --> 0x0 
RIP: 0x100000f66 (<main+22>:	mov    QWORD PTR [rbp-0x10],rax)
R8 : 0x0 
R9 : 0x0 
R10: 0x0 
R11: 0x0 
R12: 0x0 
R13: 0x0 
R14: 0x0 
R15: 0x0
EFLAGS: 0x306 (carry PARITY adjust zero sign TRAP INTERRUPT direction overflow)
[-------------------------------------code-------------------------------------]
   0x100000f54 <main+4>:	sub    rsp,0x20
   0x100000f58 <main+8>:	mov    DWORD PTR [rbp-0x4],0x0
   0x100000f5f <main+15>:	lea    rax,[rip+0x3c]        # 0x100000fa2
=> 0x100000f66 <main+22>:	mov    QWORD PTR [rbp-0x10],rax
   0x100000f6a <main+26>:	mov    rdi,QWORD PTR [rbp-0x10]
   0x100000f6e <main+30>:	call   0x100000f80
   0x100000f73 <main+35>:	xor    ecx,ecx
   0x100000f75 <main+37>:	mov    DWORD PTR [rbp-0x14],eax
[------------------------------------stack-------------------------------------]
0000| 0x7ffeefbffb60 --> 0x0 
0008| 0x7ffeefbffb68 --> 0x0 
0016| 0x7ffeefbffb70 --> 0x7ffeefbffb90 --> 0x0 
0024| 0x7ffeefbffb78 --> 0x4036 ('6@')
0032| 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
0040| 0x7ffeefbffb88 --> 0x7fff5a3e53d5 (<dispatch_logfile+2245>:	mov    edi,eax)
0048| 0x7ffeefbffb90 --> 0x0 
0056| 0x7ffeefbffb98 --> 0x1 
[------------------------------------------------------------------------------]
Legend: code, data, rodata, value
0x0000000100000f66 in main ()
gdb-peda$ n
[----------------------------------registers-----------------------------------]
RAX: 0x100000fa2 ("Hello World")
RBX: 0x0 
RCX: 0x7ffeefbffc58 --> 0x7ffeefbffca0 ("executable_path=/Users/leaduvigneau/Desktop/a.out")
RDX: 0x7ffeefbffbb0 --> 0x7ffeefbffcfa ("SHELL=/bin/sh")
RSI: 0x7ffeefbffba0 --> 0x7ffeefbffcd8 ("/Users/leaduvigneau/Desktop/a.out")
RDI: 0x1 
RBP: 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
RSP: 0x7ffeefbffb60 --> 0x0 
RIP: 0x100000f6a (<main+26>:	mov    rdi,QWORD PTR [rbp-0x10])
R8 : 0x0 
R9 : 0x0 
R10: 0x0 
R11: 0x0 
R12: 0x0 
R13: 0x0 
R14: 0x0 
R15: 0x0
EFLAGS: 0x306 (carry PARITY adjust zero sign TRAP INTERRUPT direction overflow)
[-------------------------------------code-------------------------------------]
   0x100000f58 <main+8>:	mov    DWORD PTR [rbp-0x4],0x0
   0x100000f5f <main+15>:	lea    rax,[rip+0x3c]        # 0x100000fa2
   0x100000f66 <main+22>:	mov    QWORD PTR [rbp-0x10],rax
=> 0x100000f6a <main+26>:	mov    rdi,QWORD PTR [rbp-0x10]
   0x100000f6e <main+30>:	call   0x100000f80
   0x100000f73 <main+35>:	xor    ecx,ecx
   0x100000f75 <main+37>:	mov    DWORD PTR [rbp-0x14],eax
   0x100000f78 <main+40>:	mov    eax,ecx
[------------------------------------stack-------------------------------------]
0000| 0x7ffeefbffb60 --> 0x0 
0008| 0x7ffeefbffb68 --> 0x0 
0016| 0x7ffeefbffb70 --> 0x100000fa2 ("Hello World")
0024| 0x7ffeefbffb78 --> 0x4036 ('6@')
0032| 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
0040| 0x7ffeefbffb88 --> 0x7fff5a3e53d5 (<dispatch_logfile+2245>:	mov    edi,eax)
0048| 0x7ffeefbffb90 --> 0x0 
0056| 0x7ffeefbffb98 --> 0x1 
[------------------------------------------------------------------------------]
Legend: code, data, rodata, value
0x0000000100000f6a in main ()
gdb-peda$ n
[----------------------------------registers-----------------------------------]
RAX: 0x100000fa2 ("Hello World")
RBX: 0x0 
RCX: 0x7ffeefbffc58 --> 0x7ffeefbffca0 ("executable_path=/Users/leaduvigneau/Desktop/a.out")
RDX: 0x7ffeefbffbb0 --> 0x7ffeefbffcfa ("SHELL=/bin/sh")
RSI: 0x7ffeefbffba0 --> 0x7ffeefbffcd8 ("/Users/leaduvigneau/Desktop/a.out")
RDI: 0x100000fa2 ("Hello World")
RBP: 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
RSP: 0x7ffeefbffb60 --> 0x0 
RIP: 0x100000f6e (<main+30>:	call   0x100000f80)
R8 : 0x0 
R9 : 0x0 
R10: 0x0 
R11: 0x0 
R12: 0x0 
R13: 0x0 
R14: 0x0 
R15: 0x0
EFLAGS: 0x306 (carry PARITY adjust zero sign TRAP INTERRUPT direction overflow)
[-------------------------------------code-------------------------------------]
   0x100000f5f <main+15>:	lea    rax,[rip+0x3c]        # 0x100000fa2
   0x100000f66 <main+22>:	mov    QWORD PTR [rbp-0x10],rax
   0x100000f6a <main+26>:	mov    rdi,QWORD PTR [rbp-0x10]
=> 0x100000f6e <main+30>:	call   0x100000f80
   0x100000f73 <main+35>:	xor    ecx,ecx
   0x100000f75 <main+37>:	mov    DWORD PTR [rbp-0x14],eax
   0x100000f78 <main+40>:	mov    eax,ecx
   0x100000f7a <main+42>:	add    rsp,0x20
Guessed arguments:
arg[0]: 0x100000fa2 ("Hello World")
[------------------------------------stack-------------------------------------]
0000| 0x7ffeefbffb60 --> 0x0 
0008| 0x7ffeefbffb68 --> 0x0 
0016| 0x7ffeefbffb70 --> 0x100000fa2 ("Hello World")
0024| 0x7ffeefbffb78 --> 0x4036 ('6@')
0032| 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
0040| 0x7ffeefbffb88 --> 0x7fff5a3e53d5 (<dispatch_logfile+2245>:	mov    edi,eax)
0048| 0x7ffeefbffb90 --> 0x0 
0056| 0x7ffeefbffb98 --> 0x1 
[------------------------------------------------------------------------------]
Legend: code, data, rodata, value
0x0000000100000f6e in main ()
gdb-peda$ n
Hello World
[----------------------------------registers-----------------------------------]
RAX: 0xa ('\n')
RBX: 0x0 
RCX: 0x1000a566c --> 0xefc0000000000000 
RDX: 0x0 
RSI: 0x120a8 
RDI: 0x7fff90d36f58 --> 0x4d555458 ('XTUM')
RBP: 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
RSP: 0x7ffeefbffb60 --> 0x0 
RIP: 0x100000f73 (<main+35>:	xor    ecx,ecx)
R8 : 0x130a8 
R9 : 0x7fff90d36f78 --> 0x0 
R10: 0x0 
R11: 0x7fff90d36f70 --> 0x0 
R12: 0x0 
R13: 0x0 
R14: 0x0 
R15: 0x0
EFLAGS: 0x202 (carry parity adjust zero sign trap INTERRUPT direction overflow)
[-------------------------------------code-------------------------------------]
   0x100000f66 <main+22>:	mov    QWORD PTR [rbp-0x10],rax
   0x100000f6a <main+26>:	mov    rdi,QWORD PTR [rbp-0x10]
   0x100000f6e <main+30>:	call   0x100000f80
=> 0x100000f73 <main+35>:	xor    ecx,ecx
   0x100000f75 <main+37>:	mov    DWORD PTR [rbp-0x14],eax
   0x100000f78 <main+40>:	mov    eax,ecx
   0x100000f7a <main+42>:	add    rsp,0x20
   0x100000f7e <main+46>:	pop    rbp
[------------------------------------stack-------------------------------------]
0000| 0x7ffeefbffb60 --> 0x0 
0008| 0x7ffeefbffb68 --> 0x0 
0016| 0x7ffeefbffb70 --> 0x100000fa2 ("Hello World")
0024| 0x7ffeefbffb78 --> 0x4036 ('6@')
0032| 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
0040| 0x7ffeefbffb88 --> 0x7fff5a3e53d5 (<dispatch_logfile+2245>:	mov    edi,eax)
0048| 0x7ffeefbffb90 --> 0x0 
0056| 0x7ffeefbffb98 --> 0x1 
[------------------------------------------------------------------------------]
Legend: code, data, rodata, value
0x0000000100000f73 in main ()
gdb-peda$ 
[----------------------------------registers-----------------------------------]
RAX: 0xa ('\n')
RBX: 0x0 
RCX: 0x0 
RDX: 0x0 
RSI: 0x120a8 
RDI: 0x7fff90d36f58 --> 0x4d555458 ('XTUM')
RBP: 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
RSP: 0x7ffeefbffb60 --> 0x0 
RIP: 0x100000f75 (<main+37>:	mov    DWORD PTR [rbp-0x14],eax)
R8 : 0x130a8 
R9 : 0x7fff90d36f78 --> 0x0 
R10: 0x0 
R11: 0x7fff90d36f70 --> 0x0 
R12: 0x0 
R13: 0x0 
R14: 0x0 
R15: 0x0
EFLAGS: 0x346 (carry PARITY adjust ZERO sign TRAP INTERRUPT direction overflow)
[-------------------------------------code-------------------------------------]
   0x100000f6a <main+26>:	mov    rdi,QWORD PTR [rbp-0x10]
   0x100000f6e <main+30>:	call   0x100000f80
   0x100000f73 <main+35>:	xor    ecx,ecx
=> 0x100000f75 <main+37>:	mov    DWORD PTR [rbp-0x14],eax
   0x100000f78 <main+40>:	mov    eax,ecx
   0x100000f7a <main+42>:	add    rsp,0x20
   0x100000f7e <main+46>:	pop    rbp
   0x100000f7f <main+47>:	ret
[------------------------------------stack-------------------------------------]
0000| 0x7ffeefbffb60 --> 0x0 
0008| 0x7ffeefbffb68 --> 0x0 
0016| 0x7ffeefbffb70 --> 0x100000fa2 ("Hello World")
0024| 0x7ffeefbffb78 --> 0x4036 ('6@')
0032| 0x7ffeefbffb80 --> 0x7ffeefbffb90 --> 0x0 
0040| 0x7ffeefbffb88 --> 0x7fff5a3e53d5 (<dispatch_logfile+2245>:	mov    edi,eax)
0048| 0x7ffeefbffb90 --> 0x0 
0056| 0x7ffeefbffb98 --> 0x1 
[------------------------------------------------------------------------------]
Legend: code, data, rodata, value
0x0000000100000f75 in main ()
gdb-peda$ q
➜  Desktop ./a.out 
Hello World
➜  Desktop gcc hello.c -v
Apple LLVM version 10.0.1 (clang-1001.0.46.4)
Target: x86_64-apple-darwin18.6.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
 "/Library/Developer/CommandLineTools/usr/bin/clang" -cc1 -triple x86_64-apple-macosx10.14.0 -Wdeprecated-objc-isa-usage -Werror=deprecated-objc-isa-usage -emit-obj -mrelax-all -disable-free -disable-llvm-verifier -discard-value-names -main-file-name hello.c -mrelocation-model pic -pic-level 2 -mthread-model posix -mdisable-fp-elim -fno-strict-return -masm-verbose -munwind-tables -target-sdk-version=10.14 -target-cpu penryn -dwarf-column-info -debugger-tuning=lldb -target-linker-version 450.3 -v -resource-dir /Library/Developer/CommandLineTools/usr/lib/clang/10.0.1 -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk -I/usr/local/include -Wno-atomic-implicit-seq-cst -Wno-framework-include-private-from-public -Wno-atimport-in-framework-header -Wno-quoted-include-in-framework-header -fdebug-compilation-dir /Users/leaduvigneau/Desktop -ferror-limit 19 -fmessage-length 148 -stack-protector 1 -fblocks -fencode-extended-block-signature -fregister-global-dtors-with-atexit -fobjc-runtime=macosx-10.14.0 -fmax-type-align=16 -fdiagnostics-show-option -fcolor-diagnostics -o /var/folders/yh/v8b_xl9j2wb8_b13crprxk500000gn/T/hello-ec2789.o -x c hello.c
clang -cc1 version 10.0.1 (clang-1001.0.46.4) default target x86_64-apple-darwin18.6.0
ignoring nonexistent directory "/Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/local/include"
ignoring nonexistent directory "/Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/Library/Frameworks"
#include "..." search starts here:
#include <...> search starts here:
 /usr/local/include
 /Library/Developer/CommandLineTools/usr/lib/clang/10.0.1/include
 /Library/Developer/CommandLineTools/usr/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include
 /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks (framework directory)
End of search list.
 "/Library/Developer/CommandLineTools/usr/bin/ld" -demangle -lto_library /Library/Developer/CommandLineTools/usr/lib/libLTO.dylib -no_deduplicate -dynamic -arch x86_64 -macosx_version_min 10.14.0 -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk -o a.out /var/folders/yh/v8b_xl9j2wb8_b13crprxk500000gn/T/hello-ec2789.o -L/usr/local/lib -lSystem /Library/Developer/CommandLineTools/usr/lib/clang/10.0.1/lib/darwin/libclang_rt.osx.a
➜  Desktop cat hello.c 
#include <stdio.h>
int main(){
	char *str="Hello World";
	puts(str);
	return 0;
}
➜  Desktop 

```

