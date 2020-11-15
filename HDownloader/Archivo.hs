module HDownloader.Archivo
( ArchivoType, 
  urlArchivo,
  tamArchivo,
  compresionArchivo
) where

-- ArchivoType = (URL, Tamaño, Compresión) sinonimo/alias
type ArchivoType = (String, Int, Int)

urlArchivo :: ArchivoType -> String
urlArchivo (u, _, _) = u

tamArchivo :: ArchivoType -> Int
tamArchivo (_, t, _) = t

compresionArchivo :: ArchivoType -> Int
compresionArchivo (_, _, c) = c
