

function analizeFasesFija(){
    $msg.salida  +="Analisis del fichero de entrada: ";
     
     $arrayLogFases =$msg.arrayLogFases  -Split "\[INFO\]\s+===== Fase" ;
     $arrayInfoFases =$msg.arrayInfoFases;
     $arraySalidaFases = [Object[]]::new($arrayInfoFases.length) 
     $salidaFichero = New-Object -TypeName PSCustomObject
   
      

          $salidaFichero = New-Object -TypeName PSCustomObject
    $salidaFichero  | Add-Member -MemberType NoteProperty -Name anagrama  -Value $null
    $salidaFichero | Add-Member -MemberType NoteProperty -Name resultadoVal  -Value  $null
    $salidaFichero | Add-Member -MemberType NoteProperty -Name resultadoRev  -Value  $null
    $salidaFichero | Add-Member -MemberType NoteProperty -Name fechaRev  -Value  $null
    $salidaFichero | Add-Member -MemberType NoteProperty -Name fechaLog  -Value  $null


     # comprobamos que en el log hay el numero de fases esperado
     if($($arrayLogFases.Count-1) -ne $arrayInfoFases.Count) {
        $msg.salida  +=" Error -> El numero de fases encontradas en el log no es el esperado. NO se ha generado fichero de salida.";
        $msg.arraySalida = $null;
        $msg.ret = -1;
         return ;
     }
     
     # extraigo las fechas
     $nPos = 0;
     $fechaLog;
     $fechaRev;
     if(($nPos = $arrayLogFases[0].IndexOf("Fecha actual:")) -ge 1) {
        $fechaLog = $arrayLogFases[0].Substring($($nPos+14),27);
        echo $($fechaLog+"  chache------------------------------------------------------------------------------->")
     }
     if(($nPos = $arrayLogFases[0].indexOf("fases del dia:")) -ge 1) {
        $fechaRev = $arrayLogFases[0].Substring($($nPos+15),8);
         echo $($fechaRev+"  jose------------------------------------------------------------------------------->")
     }
     
     $numFasesNoEncontradas = 0;
     $numFasesNoDiariasNoEjecutadas = 0;
     $numFasesOK = 0;
     $numFasesKO = 0;
     $numFasesDU = 0;
     $msgPosibleKOEncontrado;
    
     $msgPosibleOKEncontrado;
     
     
     $nombreFase;
     $tipoEjecucionFase;
     $diaEjecucionFase;
     $msgNoLogFase;
     $msgUnicoOKFase;
     $estanTodosMsgPosiblesKOFase;
     $arrayMsgPosiblesKOFase;

     

     for($i=0;$i -lt $arrayInfoFases.length;$i++) {
      echo $("indice   ---   __________"+$i);
         # extraemos la información de las fases

        $nombreFase =$arrayInfoFases[$i][0];
        echo $("nombreFase ->"+ $nombreFase);

        $tipoEjecucionFase =$arrayInfoFases[$i][1];
        echo $("tipoEjecucionFase ->"+ $tipoEjecucionFase);

         $diaEjecucionFase =$arrayInfoFases[$i][2];
         echo $("diaEjecucionFase ->"+ $diaEjecucionFase);

        $msgNoLogFase =$arrayInfoFases[$i][3];
        echo $("msgNoLogFase ->"+ $msgNoLogFase);

        $msgUnicoOKFase =$arrayInfoFases[$i][4];
        echo $("msgUnicoOKFase ->"+ $msgUnicoOKFase);

         $estanTodosMsgPosiblesKOFase =$arrayInfoFases[$i][5];
         echo $("estanTodosMsgPosiblesKOFase ->"+ $estanTodosMsgPosiblesKOFase);

         $arrayMsgPosiblesKOFase =$arrayInfoFases[$i][6];
         echo $("arrayMsgPosiblesKOFase ->"+ $arrayMsgPosiblesKOFase);

        echo $arrayLogFases.Count;
         # buscamos la fase en el log
         $faseEncontrada= [bool]::Parse('false');
         $indiceEncontrada;
         $nombreArrayLogFases="";
          for($s=1;$s -lt $arrayLogFases.Count;$s++) {
          
         
              if($arrayLogFases[$s].IndexOf($nombreFase) -ge 0) {
            $nombreArrayLogFases=$arrayLogFases[$s].Substring($arrayLogFases[$s].IndexOf($nombreFase),8);
            }
           
             if($nombreArrayLogFases -contains $nombreFase  ){
                 $faseEncontrada = [bool]::Parse('true');
                 echo $("encontrada fase en: "+$nombreArrayLogFases+ " "+$nombreFase+" indice "+ $s);
                 $indiceEncontrada=$s;
                 break;
                 }
             
            }
            
         
         if(!$faseEncontrada) {
             $arraySalidaFases[$i] =$nombreFase +=(" => Fase no encontrada en el log!!!");
             $numFasesNoEncontrada++;
             continue;
         }
         
         echo  $("Comrpueba msgNoLogFase  "+$msgNoLogFase)
         # fase encontrada. Si no es diaria, comprobamos si no se ha ejecutado
          echo $("Comprueba si no se ha ejecutado   "+$arrayLogFases[$indiceEncontrada].indexOf($msgNoLogFase))
         #echo $("numero del índice"+$arrayLogFases[$i+1])
         if ($tipoEjecucionFase -ne  "D" -and ($arrayLogFases[$indiceEncontrada].indexOf($msgNoLogFase)) -ge 1) {
             $tipoEjecucionMsgFase;
             
             switch($tipoEjecucionFase) {
                  "S"{
                    $tipoEjecucionMsgFase = "SEMANAL";
                     break;
                 }
                  "M"{
                    $tipoEjecucionMsgFase = "MENSUAL";
                     break;
                  }
                  "P"{
                    $tipoEjecucionMsgFase = "PUNTUAL";
                     break;
                  }
                 default{
                    $tipoEjecucionMsgFase = "DESCONOCIDA";
                 }
             }
            
             $arraySalidaFases[$i] = $nombreFase +(" => No se ha encontrado log. Ejecucion ")+($tipoEjecucionMsgFase)+(".");
             if($diaEjecucionFase -ne  $null) {
                 $arraySalidaFases[$po] = $arraySalidaFases[$i]+" Se ejecuta "+$diaEjecucionFase+ ".";
                 $po++
             }
             $numFasesNoDiariasNoEjecutadas++;
             continue;
         }
         
        <#
         
         INI - MOD - JORUILOP - 20201118
         # o es fase diaria, o es fase no diaria que sÃ­ se ha encontrado log
         
         # si hay mensaje unico de OK
         if$msgUnicoOKFase -ne = null) {
             if(arrayLogFases[j].indexOf$msgUnicoOKFase) -lt 1) {
                 arraySalidaFases[$i] =$nombreFase +=(" => Ejecución CORRECTA");
                 $numFasesOK++;
                 continue;
             } else {
                 arraySalidaFases[$i] =$nombreFase +=(" => Ejecución INCORRECTA!!!");
                 numFasesKO++;
                 continue;
             }
         } 
         FIN - MOD - JORUILOP - 20201118 
        #>
         
         # no hay mensaje unico de OK o no lo he encontrado
        $msgPosibleKOEncontrado = [bool]::Parse('false');
         
         for($k=0; $k -lt $arrayMsgPosiblesKOFase.length; $k++) {
         
      
           
             if($arrayLogFases[$($i+1)].indexOf($arrayMsgPosiblesKOFase[$k]) -ge 1){
              
              echo $("Encontrado un KO"+ $arrayMsgPosiblesKOFase[$k]+" indice "+ $k+ "resultado" )
                $msgPosibleKOEncontrado = [bool]::Parse('true');
                 break;
             }  
         }
         
         
        
        $msgPosibleOKEncontrado = [bool]::Parse('false');
         if($msgUnicoOKFase -ne  $null) {
            
             for($l=0; $l -lt $msgUnicoOKFase.length; $l++) {
            echo $("Se va a comprobar este ok "+ $msgUnicoOKFase[$l] )
             
                 if($arrayLogFases[$indiceEncontrada].indexOf($msgUnicoOKFase[$l]) -ge 1){
                 echo $("Encontrado un OK. Indexof"+ $arrayLogFases[$indiceEncontrada].indexOf($msgUnicoOKFase[$l]))
                # echo $("------------------////"+ $arrayLogFases[$($i+1)]);
                    $msgPosibleOKEncontrado = [bool]::Parse('true');
                     break;
                 } 
                 
             }
             }
            
           echo $("******msgPosibleOKEncontrado ->"+ $msgPosibleOKEncontrado);
            echo $("******msgPosibleKOEncontrado ->"+ $msgPosibleKOEncontrado);
           
         
         if($msgPosibleKOEncontrado -and $msgPosibleOKEncontrado){
         $arraySalidaFases[$po] =$nombreFase +" => Ejecución CORRECTA";
                     $numFasesOK++;
                     $po++
         }elseif($msgPosibleKOEncontrado) {
             $arraySalidaFases[$po] =$nombreFase +(" => Ejecución INCORRECTA!!!");
             $numFasesKO++;
             $po++
         } else {
             if($estanTodosMsgPosiblesKOFase) {
                 $arraySalidaFases[$po] =$nombreFase +(" => Ejecución CORRECTA");
                 $numFasesOK++;
                 $po++
             } else {
                
                 # si hay mensaje unico de OK
                 if($msgPosibleOKEncontrado) {
                     $arraySalidaFases[$po] =$nombreFase +" => Ejecución CORRECTA";
                     $numFasesOK++;
                     $po++
                 } else {
                     $arraySalidaFases[$po] =$nombreFase +" => Ejecución INCIERTA: No se ha configurado mensaje unico de OK y no se han encontrado los posibles mensajes de KO informados (podría haber otros).";
                     $numFasesDU++;
                     $po++
                 }
                  $msgPosibleKOEncontrado=[bool]::Parse('false');
                
                 #arraySalidaFases$i =$nombreFase +=(" => Ejecución INCIERTA: No se ha configurado mensaje unico de OK y no se han encontrado los posibles mensajes de KO informados (podrí­a haber otros).");
                 #numFasesDU++;
                 
             }
         }
           echo  $arraySalidaFases[$po]
     }
     
     $msg.salida +=("-> Fecha del log a analizar: ")+$fechaLog+(". `r");
     $msg.salida +=("-> Fecha a revisar: ")+$fechaRev+(". `r");
     $msg.salida +=("-> Revisión de fases terminada. `r");
     $msg.salida +=("-> Resumen: `r");
     $msg.salida +=("  - Numero TOTAL de fases revisadas: ")+$arrayInfoFases.length+(". `r");
     if($numFasesNoEncontradas -lt 0){$msg.salida +=("  - Número de fases NO encontradas en el log: ")+($numFasesNoEncontradas)+(". `r")};
     if($numFasesNoDiariasNoEjecutadas -lt 0){ $msg.salida +=("  - Numero de fases NO DIARIAS que NO se han ejecutado (comprobar en fichero de salida): ")+($numFasesNoDiariasNoEjecutadas)+(". `r")};
     if($numFasesOK -gt 0){ $msg.salida +=("  - Número de fases ejecutadas CORRECTAMENTE: ")+($numFasesOK)+(". `r")};
     if($numFasesKO -gt 0){ $msg.salida +=("  - Número de fases NO ejecutadas CORRECTAMENTE: ")+($numFasesKO)+(". `r")};
     if($numFasesDU -gt 0){ $msg.salida +=("  - Número de fases con resultado INCIERTO (comprobar en fichero de salida): ")+($numFasesDU)+(". "+'`r')};
     
     $salidaFichero.anagrama =$msg.anagrama;
     $salidaFichero.fechaLog =$fechaLog;
     $salidaFichero.fechaRev =$fechaRev;
     $salidaFichero.resultadoRev = $arraySalidaFases;
     $msg.salidaFichero = $salidaFichero;
     
     If(!(test-path "resultados"))
        {
      New-Item -ItemType Directory -Force -Path "resultados"
        }
    If(!(test-path "./resultados/logs"))
        {
      New-Item -ItemType Directory -Force -Path "./resultados/logs"
        }
     $msg.salidaFichero | ConvertTo-Json | % { [System.Text.RegularExpressions.Regex]::Unescape($_) } | Out-File -FilePath $("./resultados/"+$element[2]+".out")
      $msg.salida | ConvertTo-Json | % { [System.Text.RegularExpressions.Regex]::Unescape($_) } | Out-File -FilePath $("./resultados/logs/"+"Log-"+$element[2]+".out")
     }
     
    $msg.ret = 0;
    
function validateConfFija(){
    # extraigo el anagrama
    $msg.salida = "Anagrama: "+$msg.anagrama+". `r";
    
    $msg.salida = $msg.salida+"Validación del fichero de configuración: `r ";
    
     $arraySalidaFases =  [Object[]]::new($msg.payload.length) 
    
     
    
     $nombreFase;
     $tipoEjecucionFase;
     $diaEjecucionFase;
     $msgNoLogFase;
     $msgUnicoOKFase;
     $estanTodosMsgPosiblesKOFase;
     $arrayMsgPosiblesKOFase;
   
     $ret = 0;
    for( $i=0;$i -le $msg.payload.length-1;$i++) {
        $payloadSmall=$msg.payload[$i] 
     
        if($msg.payload[$i].length -ne 7) {
            
            $num=$i+1;
            $arraySalidaFases[$i] = "Elemento "+$num+" => El número de atributos no es correcto.";
            $ret = -1;
            continue;
        }
        
        # extraemos la información de las fases
        $nombreFase = $msg.payload[$i][0];
        $tipoEjecucionFase = $msg.payload[$i][1];
        $diaEjecucionFase = $msg.payload[$i][2];
        $msgNoLogFase = $msg.payload[$i][3];
        $msgUnicoOKFase = $msg.payload[$i][4];
        $estanTodosMsgPosiblesKOFase = $msg.payload[$i][5];
        $arrayMsgPosiblesKOFase = $msg.payload[$i][6];
       
        # comprobaciones del nombre
        if($nombreFase -eq "") {
            $arraySalidaFases[$i] = "$null => El campo 1 no puede ser '$null'.";
            $ret = -1;
            continue;
        }
        
        # comprobaciones del tipo y dí­a de ejecución
        if($tipoEjecucionFase -eq "") {
            $arraySalidaFases[$i] = $nombreFase+" => El campo 2 no puede ser '$null'.";
            $ret = -1;
            continue;
        } 
        if ($tipoEjecucionFase -ne "D" -and $tipoEjecucionFase -ne "P" -and $tipoEjecucionFase -ne "S" -and $tipoEjecucionFase -ne "M") {
            $arraySalidaFases[$i] = $nombreFase+" => El campo 2 solo puede ser 'D', 'P', 'S' o 'M'.";
            $ret = -1;
            continue;
        }
        if(($tipoEjecucionFase -ne "D" -and $tipoEjecucionFase -ne "P") -and ($diaEjecucionFase -eq "" -or $msgNoLogFase -eq "")) {
            $arraySalidaFases[$i] = $nombreFase+" => Si el campo 2 no es ni 'D' ni 'P', los campos 3 y 4 no pueden ser '$null'.";
            $ret = -1;
            continue;
        }
        
        # comprobación del posible mensaje único de OK
        
        if($msgUnicoOKFase -ne $null) {
       
            $arraySalidaFases[$i] = $nombreFase+" => Formato correcto.";
            continue;
        }
        
        # comprobaciones de los posibles mensajes de KO y mensaje único de OK
        if($estanTodosMsgPosiblesKOFase -eq "" -or $arrayMsgPosiblesKOFase -eq "") {
            $arraySalidaFases[$i] = $nombreFase+" => Si el campo 5 es '$null', los campos 6 y 7 no pueden ser '$null'.";
            $ret = -1;
            continue;
        }
        if($arrayMsgPosiblesKOFase.length -eq 0) {
            $arraySalidaFases[$i] = $nombreFase+" => Si el campo 5 es '$null', el campo 7 no puede estar vací­o.";
            $ret = -1;
            continue;
        }
        
        $arraySalidaFases[$i] = $nombreFase+" => Formato correcto.";
    }
    
    if($ret -eq 0) {
        $msg.arraySalidaFases = $null;
        $msg.arrayInfoFases = $msg.payload;
        $msg.salida += "- El fichero de configuración es CORRECTO. `r";
        
    } else {
        $msg.arrayInfoFases = $null;
        $salidaFichero.anagrama = $msg.anagrama;
        $salidaFichero.resultadoVal = $arraySalidaFases;
        $msg.salidaFichero = $salidaFichero;
        
        $msg.salida = $msg.salida+"-> El fichero de configuración es INCORRECTO (compruebe el fichero de salida). `r";
        
    }
    
    $msg.ret = $ret;
    
   # return $msg;
    }
$urlNE = "./internal-storage-files\\files\\servs\\info_fases_NE.config";
$urlEN = "./internal-storage-files\\files\\servs\\info_fases_EN.config";
$urlPM = "./internal-storage-files\\files\\servs\\info_fases_PM.config";
$urlSE = "./internal-storage-files\\files\\servs\\info_fases_SE.config";
$urlUE = "./internal-storage-files\\files\\servs\\info_fases_UE.config";
$urlCOLX = "./internal-storage-files\\files\\servs\\info_fases_COLX.config";

$inUrlNE = "internal-storage-files\\files\\in\\log_NE.in";
$inUrlEN = "internal-storage-files\\files\\in\\log_EN.in";
$inUrlPM = "internal-storage-files\\files\\in\\log_PM.in";
$inUrlSE = "internal-storage-files\\files\\in\\log_SE.in";
$inUrlUE = "internal-storage-files\\files\\in\\log_UE.in";
$inUrlCOLX = "internal-storage-files\\files\\in\\log_L1_L3.in";





 $datosNE=@($urlNE,$inUrlNE,"NE");
 $datosEN=@($urlEN,$inUrlEN,"EN")
 $datosPM=@($urlPM,$inUrlPM,"PM")
 $datosSE=@($urlSE,$inUrlSE,"SE")
 $datosUE=@($urlUE,$inUrlUE,"UE")
 $datosCOLX=@($urlCOLX,$inUrlCOLX,"COLX")

 $objects= @($datosNE,$datosEN,$datosPM,$datosSE,$datosUE,$datosCOLX)
 #$objects= $datosPM;

 foreach ($element in $objects) {
 $po=0;
    clear
    $msg = New-Object -TypeName PSCustomObject
    $msg | Add-Member -MemberType NoteProperty -Name payload -Value ""
    $msg | Add-Member -MemberType NoteProperty -Name arraySalidaFases -Value  ""
    $msg | Add-Member -MemberType NoteProperty -Name arrayInfoFases -Value  ""
    $msg | Add-Member -MemberType NoteProperty -Name salida -Value  ""
    $msg | Add-Member -MemberType NoteProperty -Name salidaFichero -Value  ""
    $msg | Add-Member -MemberType NoteProperty -Name anagrama -Value  ""
    $msg | Add-Member -MemberType NoteProperty -Name arrayLogFases -Value  ""
    $msg | Add-Member -MemberType NoteProperty -Name nombre -Value  ""
    $msg | Add-Member -MemberType NoteProperty -Name ret -Value  ""
    $msg | Add-Member -MemberType NoteProperty -Name arraySalida -Value  ""
    $msg | Add-Member -MemberType NoteProperty -Name resultadoVal -Value  ""
    


    $ConfigObject = ""
    $inFileObject = ""

    


   
   $ConfigObject = Get-Content  $element[0] | ConvertFrom-Json 
    $inFileObjects=Get-Content $element[1]  -Raw
     $msg.anagrama=$element[2];
    
   
    
    <#
    $ConfigObject = Get-Content  $datosPM[0] | ConvertFrom-Json 
    $inFileObjects=Get-Content $datosPM[1]  -Raw
    $msg.anagrama=$datosPM[2];
    #>
    $tamanio=$ConfigObject[0]  ;



    $msg.payload=$ConfigObject;
    validateConfFija
    $msg.arrayLogFases = $inFileObjects;
    analizeFasesFija;
    
    
    $msg.arrayLogFases=""; 
    echo $msg.salidaFichero.resultadoRev
    
 }