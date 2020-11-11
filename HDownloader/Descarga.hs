module HDownloader.Descarga where

import qualified HDownloader.Archivo as Archivo
import qualified HDownloader.Servidor as Servidor

-- Descarga = (Nombre, [Archivo], Servidor, Prioridad)
type DescargaType = (String, [Archivo.ArchivoType], Servidor.ServidorType, Int)

descargaNombre :: DescargaType -> String
descargaNombre (n, _, _, _) = n

descargaArchivos :: DescargaType -> [Archivo.ArchivoType]
descargaArchivos (_, as, _, _) = as

descargaServidor :: DescargaType -> Servidor.ServidorType
descargaServidor (_, _, s, _) = s

descargaPrioridad :: DescargaType -> Int
descargaPrioridad (_, _, _, p) = p

{-
    El espacio en disco que necesitará una descarga es la sumatoria de los
    tamaños en disco de los archivos que la componen, calculada como: tamaño * (1 + tasa de compresión)
-}
descargaEspacioNecesario :: DescargaType -> Int
descargaEspacioNecesario d = sum [Archivo.archivoTamanio arc * (1 + Archivo.archivoCompresion arc) | arc <- descargaArchivos d]
