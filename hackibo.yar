
rule SimpleExecVe
{
    meta:
        sourceOrg = "Giovanni Analista"
        sourcePath = "basi_di_ceh.txt"
    strings:
        $string = {31c050682f2f7368682f62696e89e331c931d2b00bcd80}
    condition: 
        $string
}
rule Msfvenom
{
    meta:
        sourceOrg = "Giovanni Analista"
        sourcePath = "basi_di_ceh.txt"
    strings:
        $string = { 6a0b58995266682d6389e7682f736800682f62696e89e352e8080000002f62696e2f736800575389e1cd80 }
    condition: 
        $string
}
rule Msfvenom2
{
    meta:
        sourceOrg = "Giovanni Analista"
        sourcePath = "basi_di_ceh.txt"
    strings:
        $string = { bd401fc04edbd3d97424f45f33c9b10b316f1583effc036f11e2b575cb16acd8adcee3bfb8e89310c89e6307013d0ab9d4229eadefa41e2edfc677403074ef9c1929667d684d  }
    condition: 
        $string
}

rule Msfvenom3
{
    meta:
        sourceOrg = "Giovanni Analista"
        sourcePath = "basi_di_ceh.txt"
    strings:
        $string = { dbd4d97424f4bacc70dc975e29c9b10b31561a03  }
    condition: 
        $string
}

rule BinSh
{
    meta:
        sourceOrg = "Giovanni Analista"
        sourcePath = "basi_di_ceh.txt"
    strings:
        $string = { 682f2f7368682f62696e}
    condition: 
        $string

}
rule Int80
{
    meta:
        sourceOrg = "Giovanni Analista"
        sourcePath = "basi_di_ceh.txt"
    strings:
        $string = { cd80}
    condition: 
        $string

}


