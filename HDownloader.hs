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
alojadoEnServidor archivo dominio = contiene (Archivo.urlArchivo archivo) dominio


-- 5) Devuelve la velocidad de descarga de un servidor.
velocidadDescargaCompleta :: Servidor.ServidorType -> Archivo.ArchivoType -> Int -> Int
velocidadDescargaCompleta serv arch ancho = if alojadoEnServidor arch (Servidor.nombreServidor serv)
                                            then ancho
                                            else error "El archivo no está alojado en el servidor"

velocidadDescargaServidor :: Servidor.ServidorType -> Archivo.ArchivoType -> Int -> Int
velocidadDescargaServidor serv arch ancho = if alojadoEnServidor arch (Servidor.nombreServidor serv)
                                            then Servidor.politicaAsignacionAnchoBandaServidor serv
                                            else error "El archivo no está alojado en el servidor"

velocidadDescargaConRecientes :: Fractional p => Servidor.ServidorType -> Archivo.ArchivoType -> p -> p
velocidadDescargaConRecientes serv arch ancho = if alojadoEnServidor arch (Servidor.nombreServidor serv)
                                            then ancho / (1 + fromIntegral (Servidor.descargasRecientesServidor serv))
                                            else error "El archivo no está alojado en el servidor"

