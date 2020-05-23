# x86 shellcoding cakestar

## Introduzione

Quando facciamo un penetration test, il più delle volte utilizziamo exploit già
pronti o usiamo strumenti come msvfenom per creare un payload con qualche
opzione particolare.

Esistono situazioni dove hai bisogno di essere più creativo: devi evitare
l'antivirus, devi nasconderti dall'IDS o semplicemente vuoi divertirti un po'
ed avere il pieno controllo del codice che sarà eseguito sulla macchina.

Ecco, in questo talk vedremo come creare 2 shellcode veramente semplici in
ambiente Linux x86 e, partendo da un codice funzionante, andremo ad aggiungere
tecniche di offuscamento, egg hunting e polimorfismo per far evolvere il nostro
payload.

Il bypass dell'antivirus forse non sarà garantito, ma il divertimento... quello
sì.

## A chi è rivolto?

Penetration tester Analisti SOC Sviluppatori

## Livello di difficoltà

BASSO

## Skill richieste

Conoscenze base di assembler x86
Sapere cos'è una _system call_
Un pizzico di python o ruby o il linguaggio che più vi piace a cui accodare il
nostro shellcode.

## Cosa mi serve

* Una macchina virtuale Linux per lo sviluppo (scriveremo assembler per x86, quindi a 32 bit).
  * Ubuntu 20.04
  * apt install apt install python3 gcc-multilib nasm gdb
  * peda: https://github.com/longld/peda
  * clonate l'archivio https://github.com/thesp0nge/HackInBoSafeEdition
  * Disabilito ASLR "echo 0 > /proc/sys/kernel/randomize_va_space"

## Preparo la vittima

Ho bisogno di compilare il programma vittima per iniziare le esercitazioni.

``` sh
$ ./compile.sh pwnme.c
$ sudo "chown root:root pwnme"
$ sudo "chmod +s pwnme"
```

## L'inizio della nostra storia

Da una analisi precedente sappiamo che il software pwnme è vulnerabile a buffer
overflow. Il contenuto del file pwnme.txt, necessario al funzionamento del
nostro tool, vieme copiato in una variabile, purtroppo senza fare un controllo
sulla lunghezza dei dati letti da file.

Nel caso il file di testo sia costituito da troppi caratteri, dopo 136 byte
avremmo la sovrascittura del registro EIP e di fatto, l'inizio della nostra
storia. 
