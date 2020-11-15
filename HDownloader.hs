module HDownloader (
    Archivo.urlArchivo,
    Archivo.tamArchivo,
    Archivo.compresionArchivo,
    Servidor.nombreServidor,
    Servidor.politicaAsignacionAnchoBandaServidor,
    Servidor.descargasRecientesServidor,
    Descarga.nombreDescarga,
    Descarga.archivosDescarga,
    Descarga.servidorDescarga,
    Descarga.prioridadDescarga,
    Descarga.espacioNecesarioDescarga
) where

import qualified HDownloader.Archivo as Archivo
import qualified HDownloader.Servidor as Servidor
import qualified HDownloader.Descarga as Descarga

-- 3) Función que permite saber si una lista está contenida dentro de otra. Utiliza recursividad.
contiene :: Eq a => [a] -> [a] -> Bool
contiene [] [] = True
contiene _ [] = True
contiene [] _ = False
contiene (x:xs) (y:ys) = if x == y then contiene xs ys else contiene xs (y:ys)


-- 4) Dado el dominio de un servidor, permite saber si un archivo está alojado en el mismo.
alojadoEnServidor :: Archivo.ArchivoType -> [Char] -> Bool
alojadoEnServidor a d = contiene (Archivo.urlArchivo a) d


-- 5) Devuelve la velocidad de descarga de un servidor.
velDescCompleta :: Servidor.ServidorType -> Archivo.ArchivoType -> Float -> Float
velDescCompleta s a ab = if alojadoEnServidor a (Servidor.nombreServidor s)
                         then ab
                         else error "El archivo no está alojado en el servidor"

velDescServidor :: Servidor.ServidorType -> Archivo.ArchivoType -> Float -> Float
velDescServidor s a ab = if alojadoEnServidor a (Servidor.nombreServidor s)
                         then (
                            if ab < Servidor.politicaAsignacionAnchoBandaServidor s then ab else Servidor.politicaAsignacionAnchoBandaServidor s
                         )
                         else error "El archivo no está alojado en el servidor"

velDescConRecientes :: Fractional p => Servidor.ServidorType -> Archivo.ArchivoType -> p -> p
velDescConRecientes s a ab = if alojadoEnServidor a (Servidor.nombreServidor s)
                             then ab / (1 + fromIntegral (Servidor.descargasRecientesServidor s))
                             else error "El archivo no está alojado en el servidor"

-- Verifica si una URL se encuentra en la lista negra del servidor
urlEnListaNegra :: [Servidor.ElementoListaNegraType] -> String -> Bool
urlEnListaNegra [] _ = False
urlEnListaNegra (x:xs) url = (Servidor.urlElementoListaNegra x) == url || urlEnListaNegra xs url

coeficienteDeListaNegra :: [Servidor.ElementoListaNegraType] -> String -> Float
coeficienteDeListaNegra (x:xs) url = if Servidor.urlElementoListaNegra x == url
                                     then Servidor.coeficienteElementoListaNegra x
                                     else coeficienteDeListaNegra xs url 

velDescCoeficiente :: Servidor.ServidorType -> Archivo.ArchivoType -> Float -> Float
velDescCoeficiente s a ab = if urlEnListaNegra (Servidor.listaNegraServidor s) (Archivo.urlArchivo a)
                            then ab * coeficienteDeListaNegra (Servidor.listaNegraServidor s) (Archivo.urlArchivo a)
                            else ab

velDescCombinadas :: Servidor.ServidorType -> Archivo.ArchivoType -> Float -> Float
velDescCombinadas s a ab = velDescServidor s a (velDescCompleta s a ab)

velDescCombinadas' :: Servidor.ServidorType -> Archivo.ArchivoType -> Float -> Float
velDescCombinadas' s a ab = velDescCoeficiente s a (velDescServidor s a ab)


-- 6) Controla la disponibilidad de un archivo en un servidor (alojado y velocidad de descarga > 0).
disponibleEnServidor :: Servidor.ServidorType -> Archivo.ArchivoType -> Bool
disponibleEnServidor s a = alojadoEnServidor a (Servidor.nombreServidor s) && velDescServidor s a 500 > 0


-- 7) Disponibilidad de la descarga (todos sus archivos disponibles)
controlDeDisponibilidad :: Servidor.ServidorType -> [Archivo.ArchivoType] -> Bool
controlDeDisponibilidad s [] = True 
controlDeDisponibilidad s (x:xs) = disponibleEnServidor s x && controlDeDisponibilidad s xs

disponibilidadDescarga :: Descarga.DescargaType -> Bool
disponibilidadDescarga d = controlDeDisponibilidad (Descarga.servidorDescarga d) (Descarga.archivosDescarga d)

-- 8) Tiempo total en minutos que tomará descargar los archivos disponibles
tiempoDescargaArchivo :: Archivo.ArchivoType -> Float -> Float
tiempoDescargaArchivo a v = (1024 * fromIntegral (Archivo.tamArchivo a)) / (60 * v)

tiempoDescargaDescarga :: Float -> Descarga.DescargaType -> Float
tiempoDescargaDescarga v d = sum [tiempoDescargaArchivo ds v | ds <- Descarga.archivosDescarga d, disponibilidadDescarga d]

tiempoDescarga :: Float -> [Descarga.DescargaType] -> Float
tiempoDescarga v ld = sum [tiempoDescargaDescarga v d | d <- ld]

-- 9) Descarga con prioridades

contarArchivosGrandes :: Num p => [Archivo.ArchivoType] -> p
contarArchivosGrandes [] = 0
contarArchivosGrandes (x:xs) | (Archivo.tamArchivo x) >= 500 = 1 + contarArchivosGrandes xs
                             | otherwise = contarArchivosGrandes xs

tieneArchivosGrandes :: Descarga.DescargaType -> Bool
tieneArchivosGrandes d = contarArchivosGrandes (Descarga.archivosDescarga d) > 0

archivosGrandesDescarga :: Num b => Descarga.DescargaType -> (String, b)
archivosGrandesDescarga d = ((Descarga.nombreDescarga d), (contarArchivosGrandes (Descarga.archivosDescarga d)))

minimo::[Int]->Int
minimo [] = 0
minimo [x] = x
minimo (x:y:xs) 
 |x > y = minimo (y:xs)
 |x < y = minimo (x:xs)
 |x == y = minimo (x:xs)

mayorPrioridad :: [Descarga.DescargaType] -> Int
mayorPrioridad [] = 1
mayorPrioridad xs = minimo[Descarga.prioridadDescarga x | x <- xs]

descargaPorPrioridad :: [Descarga.DescargaType] -> (String, Int)
descargaPorPrioridad (x:[]) = if tieneArchivosGrandes x then (Descarga.nombreDescarga x, contarArchivosGrandes (Descarga.archivosDescarga x))
                                                       else ("", 0)
descargaPorPrioridad (x:xs) = if tieneArchivosGrandes x && Descarga.prioridadDescarga x == mayorPrioridad (x:xs) then (Descarga.nombreDescarga x, contarArchivosGrandes (Descarga.archivosDescarga x))
                                                                                                                else descargaPorPrioridad xs

menorEspacio :: [Descarga.DescargaType] -> Int
menorEspacio [] = 1
menorEspacio xs = minimo[Descarga.espacioNecesarioDescarga x | x <- xs]

descargaPorMenorEspacio :: [Descarga.DescargaType] -> (String, Int)
descargaPorMenorEspacio (x:[]) = if tieneArchivosGrandes x then (Descarga.nombreDescarga x, contarArchivosGrandes (Descarga.archivosDescarga x))
                                                       else ("", 0)
descargaPorMenorEspacio (x:xs) = if tieneArchivosGrandes x && Descarga.espacioNecesarioDescarga x == menorEspacio (x:xs) then (Descarga.nombreDescarga x, contarArchivosGrandes (Descarga.archivosDescarga x))
                                                                                                                        else descargaPorMenorEspacio xs

-- Problemas

contarArchivosCorruptos :: Num p => [Archivo.ArchivoType] -> p
contarArchivosCorruptos [] = 0
contarArchivosCorruptos (x:xs) | (Archivo.tamArchivo x) < 0 || (Archivo.compresionArchivo x) < 0 = 1 + contarArchivosCorruptos xs
                               | otherwise = contarArchivosCorruptos xs

tieneArchivosCorruptos :: Descarga.DescargaType -> Bool
tieneArchivosCorruptos d = contarArchivosCorruptos (Descarga.archivosDescarga d) > 0


estaCongestionado :: Servidor.ServidorType -> Bool
estaCongestionado s = Servidor.politicaAsignacionAnchoBandaServidor s < 100 || Servidor.descargasRecientesServidor s > 10

filtrarServidoresCongestionados :: [Servidor.ServidorType] -> [Servidor.ServidorType]
filtrarServidoresCongestionados xs = [x | x <- xs, not (estaCongestionado x)]

ordenarServidores :: [Servidor.ServidorType] -> [Servidor.ServidorType]
ordenarServidores [] = []
ordenarServidores (x:xs) =
    let min = ordenarServidores [a | a <- xs, Servidor.politicaAsignacionAnchoBandaServidor a <= Servidor.politicaAsignacionAnchoBandaServidor x]
        max = ordenarServidores [a | a <- xs, Servidor.politicaAsignacionAnchoBandaServidor a > Servidor.politicaAsignacionAnchoBandaServidor x]
    in  max ++ [x] ++ min
