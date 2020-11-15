module HDownloader.Descarga
( DescargaType, 
  nombreDescarga,
  archivosDescarga,
  servidorDescarga,
  prioridadDescarga,
  espacioNecesarioDescarga
) where

import qualified HDownloader.Archivo as Archivo
import qualified HDownloader.Servidor as Servidor

-- Descarga = (Nombre, [Archivo], Servidor, Prioridad)
type DescargaType = (String, [Archivo.ArchivoType], Servidor.ServidorType, Int)

nombreDescarga :: DescargaType -> String
nombreDescarga (n, _, _, _) = n

archivosDescarga :: DescargaType -> [Archivo.ArchivoType]
archivosDescarga (_, as, _, _) = as

servidorDescarga :: DescargaType -> Servidor.ServidorType
servidorDescarga (_, _, s, _) = s

prioridadDescarga :: DescargaType -> Int
prioridadDescarga (_, _, _, p) = p

{-
    2) El espacio en disco que necesitará una descarga es la sumatoria de los tamaños en disco de los
       archivos que la componen, calculada como: tamaño * (1 + tasa de compresión).
-}
espacioNecesarioDescarga :: DescargaType -> Int
espacioNecesarioDescarga d = sum [Archivo.tamArchivo arc * (1 + Archivo.compresionArchivo arc) | arc <- archivosDescarga d]
