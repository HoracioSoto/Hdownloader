# HDownloader

## Escenario
Un grupo de fanáticos de series, música y apuntes de UTN con muy poca paciencia a la hora de bajar sus preciados archivos de la red, ha decidido construir HDownloader, su propio gestor de descargas(*) empleando el paradigma funcional en alguno de sus módulos. El sistema gestiona descargas de conjuntos de archivos, que pueden pueden provenir de diversos servidores (como por ejemplo, grupos de la facultad o youtube), las cuales están priorizadas por el usuario en una escala de 1 a 5, y tienen un nombre para identificarlas. Se las representa con 4-tuplas de las forma: (Nombre, [Archivo], Servidor, Prioridad).

Ejemplo:
descarga1 = (“Sistemas Operativos - Silberschatz”, [ silberschatzParte1, silberschatzParte2 ], megaupload, 5)
descarga2 = (“Parcial de funcional Dentista”, [parcialDentista], pdep, 2)

Los archivos representan un recurso que puede ser descargado, de los que se conoce su URL, su tamaño en MBytes, y su tasa de compresión (si no está comprimido es 0). Se los representa como ternas (URL, Tamaño, Compresión).

Ejemplo:
silberschatzParte1 = (“www.megaupload.com/?d=CRK5NQB0 ”, 10, 0)

Por último, de los servidores se conoce su dominio (un String), y su política de asignación de ancho de banda, la cual nos permite saber la velocidad (en KBytes/s) a la que se puede descargar un archivo, dado el ancho de banda del que dispone HDownloader y el archivo en cuestión. Se lo
representa como un par (Dominio, PoliticaAsignacionAnchoBanda).

## Carpetas y archivos

```
├── HDownloader/
│   ├── Archivo.hs
│   ├── Descarga.hs
│   └── Servidor.hs
├── .gitignore
├── HDownloader.hs
├── LICENSE
└── README.md
```

## Iniciamos Haskell

```bash
$ ghci
```

## Cargar modulo

```bash
GHCi, version 8.6.5: http://www.haskell.org/ghc/  :? for help
Prelude> :cd /path/to/Hdownloader/
Prelude> :l HDownloader.hs 
[1 of 4] Compiling HDownloader.Archivo ( HDownloader/Archivo.hs, interpreted )
[2 of 4] Compiling HDownloader.Servidor ( HDownloader/Servidor.hs, interpreted )
[3 of 4] Compiling HDownloader.Descarga ( HDownloader/Descarga.hs, interpreted )
[4 of 4] Compiling HDownloader      ( HDownloader.hs, interpreted )
Ok, four modules loaded.
*HDownloader> 
```

## Carga inicial

```haskell
-- Servidores
let megaupload = ("www.mega.nz", 500, 0, [("www.mega.nz/?d=AJD5PMB1", 0.2), ("www.mega.nz/?d=GAA0ACC9", 0.1)])
let mediafire = ("www.mediafire.com", 240, 2, [])
let youtube = ("www.youtube.com", 1000, 0, [])
let miserver = ("www.miserver.com.ar", 800, 16, [("www.miserver.com/haskell", 0.5)])

-- Archivos
let silberschatzParte1 = ("www.mega.nz/?d=CRK5NQB0", 502, 0)
let silberschatzParte2 = ("www.mega.nz/?d=CRK5NX34", 8, 2)
let archivoMF = ("www.mediafire.com", 200, 0)
let archivoLNmega = ("www.mega.nz/?d=AJD5PMB1", 1024, 0)
let videoParte1 = ("https://www.youtube.com/watch?v=A9XaRk0eOHM", 1260, 1)
let videoParte2 = ("https://www.youtube.com/watch?v=XavOuG02msI", 81, 1)
let videoParte3 = ("https://www.youtube.com/watch?v=XavOuG02msI", 810, 1)
let archivoCorrupto = ("www.miserver.com.ar/2020/archivo.exe", 100, -1)

-- Descargas
let descarga1 = ("Sistemas Operativos - Silberschatz", [silberschatzParte1, silberschatzParte2], megaupload, 5)
let descarga2 = ("Sistemas Operativos - Silberschatz", [silberschatzParte1, silberschatzParte2, archivoMF], megaupload, 5)
let nuevaDescarga = ("Video presentacion Haskell", [videoParte1, videoParte2], youtube, 2)
let nuevaDescarga2 = ("Video presentacion Haskell 2", [videoParte1, videoParte3], youtube, 1)
let descargaMiServer = ("Descarga archivo.exe", [archivoCorrupto], miserver, 1)
```

## Desarrollo

- 1 Desarrollar y usar las funciones urlArchivo/1, prioridadDescarga/1, compresionArchivo/1, etc, que permitan acceder a los componentes de los archivos y descargas.

```haskell
-- Funciones para archivos
*HDownloader> Archivo.urlArchivo silberschatzParte1
"www.mega.mz/?d=CRK5NQB0"
*HDownloader> Archivo.tamArchivo silberschatzParte1
10
*HDownloader> Archivo.compresionArchivo silberschatzParte1
0

-- Funciones para descargas
*HDownloader> Descarga.nombreDescarga descarga1 
"Sistemas Operativos - Silberschatz"
*HDownloader> Descarga.archivosDescarga descarga1 
[("www.mega.mz/?d=CRK5NQB0",10,0),("www.mega.mz/?d=CRK5NX34",8,2)]
*HDownloader> Descarga.servidorDescarga descarga1 
("www.mega.nz",500.0,0,[("www.mega.nz/?d=AJD5PMB1",0.2),("www.mega.nz/?d=GAA0ACC9",0.1)])
*HDownloader> Descarga.prioridadDescarga descarga1 
5

-- Funciones para servidores
*HDownloader> Servidor.nombreServidor megaupload
"www.mega.nz"
*HDownloader> Servidor.politicaAsignacionAnchoBandaServidor megaupload
500.0
*HDownloader> Servidor.descargasRecientesServidor megaupload
0
*HDownloader> Servidor.listaNegraServidor megaupload
[("www.mega.nz/?d=AJD5PMB1",0.2),("www.mega.nz/?d=GAA0ACC9",0.1)]


*HDownloader> head (Servidor.listaNegraServidor megaupload)
("www.mega.nz/?d=AJD5PMB1",0.2)
*HDownloader> Servidor.urlElementoListaNegra (head (Servidor.listaNegraServidor megaupload))
"www.mega.nz/?d=AJD5PMB1"
*HDownloader> Servidor.coeficienteElementoListaNegra (head (Servidor.listaNegraServidor megaupload))
0.2
```

- 2 Saber el espacio en disco que necesitará una descarga. Este es la sumatoria de los tamaños en disco de los archivos que la componen, calculada como: tamaño * (1+ tasa de compresión)

```haskell
*HDownloader> Descarga.espacioNecesarioDescarga descarga1 
34
```

- 3 Desarrollar y utilizar una función contiene/2 que permita saber si una lista está contenida dentro de otra. Se puede utilizar recursividad.

```haskell
*HDownloader> contiene "hola mundo" "hola"
True
*HDownloader> contiene [1, 2, 3, 4] [1]
True
*HDownloader> contiene [1, 2, 3, 4] [5, 6]
False
```

- 4 Dado el dominio de un servidor, saber si un archivo está alojado en servidor, lo cual ocurre cuando la url del archivo contiene el dominio del servidor.

```haskell
*HDownloader> alojadoEnServidor silberschatzParte1 (Servidor.nombreServidor megaupload)
True
*HDownloader> alojadoEnServidor silberschatzParte1 (Servidor.nombreServidor mediafire)
False
```

- 5 Conocer la velocidad de descarga de un servidor, dado el servidor, el archivo y el ancho de banda disponible. Mostrar consultas para los cuatro servidores de ejemplo, e implementar cada uno de ellos.
    Algunas política de otorgamiento de ancho de banda son (**):

    > Descargar empleando todo el ancho de banda disponible. Por ejemplo, si HDownloader dispone de 50KB/s, descargará a 50KB/s.
    ```haskell
   *HDownloader> velDescCompleta megaupload silberschatzParte2 800
    800.0
    ```

    > Descargar empleando como mucho a una velocidad límite fijada por el servidor. Por ejemplo, si el gestor dispone de 50KB/s y el servidor fija un límite de 20KB/s, descargará a 20KB/s.
    ```haskell
   *HDownloader> velDescServidor megaupload silberschatzParte2 800
    500.0
    ```

    > Descargar con todo el ancho de banda disponible, dividido por 1 + la cantidad de descargas recientes que se han hecho contra el mismo. Por ejemplo, si un servidor registra 2 descargas recientes, y el ancho de banda disponible es de 100KB/s, entonces descargará a 33,33KB/s.
    ```haskell
    *HDownloader> velDescConRecientes megaupload silberschatzParte2 800
    800.0
    *HDownloader> velDescConRecientes mediafire archivoMF 800
    266.6666666666667
    ```

    > Descargar multiplicando el ancho de banda disponible por un coeficiente entre 0 y 1, si el archivo se encuentra en una lista negra del servidor, de la forma [(URL, Coeficiente)]. En caso contrario, descargar con todo el ancho de banda disponible.
    ```haskell
    *HDownloader> velDescCoeficiente megaupload silberschatzParte1 600
    600.0
    *HDownloader> velDescCoeficiente megaupload archivoLNmega 600
    120.0
    ```

    > Descargar aplicando sucesivamente un conjunto de políticas: algunos servidores implementan políticas de otorgamiento de ancho de banda que combinan algunas de las anteriores, partiendo del ancho de banda disponible para el gestor y pasando el resultado a la siguiente política. Por ejemplo, si se dispone de 50KB/s, y se tiene un servidor con una política de límite de ancho de banda a 10KB/s, y otra política de cantidad descargas y registró 2, la velocidad de descarga será 3,33KB/s.
    ```haskell
    *HDownloader> velDescCombinadas' megaupload silberschatzParte1 600
    500.0
    *HDownloader> velDescCombinadas' mediafire archivoMF 600
    240.0
    ```
- 6 Saber si un archivo está disponible en un servidor, es decir, si está alojado en el mismo, y la velocidad de descarga es mayor a 0.

```haskell
*HDownloader> disponibleEnServidor megaupload silberschatzParte2
True
*HDownloader> disponibleEnServidor youtube silberschatzParte2
False
```

- 7 Saber si una descarga está disponible: lo está cuando todos sus archivos lo están.

```haskell
*HDownloader> disponibleEnServidor megaupload silberschatzParte1
True
*HDownloader> disponibleEnServidor megaupload silberschatzParte2
True
*HDownloader> disponibilidadDescarga descarga1
True

*HDownloader> disponibilidadDescarga descarga2
False
```

- 8 Dado el ancho de banda de la conexión y una lista de descargas, obtener el tiempo total en minutos que tomará descargar los archivos disponibles. Asumiendo que los archivos se descargan de a uno por vez, el tiempo de descarga de un archivo es (1024 * tamaño del archivo ) / (60 * velocidad de descarga del servidor desde donde se lo descarga).

```haskell
*HDownloader> tiempoDescarga 500 [descarga1]
0.6144

*HDownloader> tiempoDescarga 500 [descarga1, nuevaDescarga]
7.68
```

- 9 Dado una lista de descargas a realizar, desarrollar una función que encuentre el nombre y la cantidad de archivos grandes (de más de 500MBytes) de la descarga por la que el gestor debería comenzar, según un criterio.
    Dar ejemplos de las siguientes consultas:
    > a. Por prioridad: Se deberá empezar por la de mayor prioridad
    ```haskell
    *HDownloader> descargaPorPrioridad [descarga1, descarga2, nuevaDescarga2]
    ("Video presentacion Haskell 2",2)
    ```

    > b. Por espacio en disco: se deberá comenzar por la descarga que menos espacio.
    ```haskell
    *HDownloader> descargaPorMenorEspacio [descarga1, descarga2, nuevaDescarga2]
    ("Sistemas Operativos - Silberschatz",1)
    ```

- Problema 1: saber una descarga tiene archivos corruptos (se considera que un archivo está corrupto cuando su tamaño o su tasa de compresión es menor a cero).
    ```haskell
    *HDownloader> tieneArchivosCorruptos descargaMiServer 
    True
    ```

- Problema 2: filtrar los servidores que no estén congestionados (se considera que un servidor está congestionado si su velocidad de descarga es menor a 100KB/s o si tiene más de 10 descargas recientes).
    ```haskell
    *HDownloader> filtrarServidoresCongestionados [megaupload, youtube, miserver]
    [("www.mega.nz",500.0,0,[("www.mega.nz/?d=AJD5PMB1",0.2),("www.mega.nz/?d=GAA0ACC9",0.1)]),("www.youtube.com",1000.0,0,[])]
    ```

- Problema 3: dada una lista de servidores, ordernarlos de mayor a menor de acuerdo a su politica de asignacion de ancho de banda).
    ```haskell
    *HDownloader> ordenarServidores [miserver, youtube, mediafire]
    [("www.youtube.com",1000.0,0,[]),("www.miserver.com.ar",800.0,16,[("www.miserver.com/haskell",0.5)]),("www.mediafire.com",240.0,2,[])]
    ```
