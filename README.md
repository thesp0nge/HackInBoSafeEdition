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

* Una macchina Windows XP come target. Per avere una virtual machine con XP, è
  possibile seguire questo tutorial:
  https://www.makeuseof.com/tag/download-windows-xp-for-free-and-legally-straight-from-microsoft-si/
* In alternativa va benissimo qualsiasi macchina Windows 7 o 8 a cui avremo disabilitato [DEP e ASLR](https://311hrs.wordpress.com/2019/05/26/disable-dep-aslr-on-windows-7/)

* Sulla macchina Windows andrà installato:
  + [Vulnserver](https://github.com/stephenbradshaw/vulnserver)
  + [OllyDBG](http://www.ollydbg.de/)



