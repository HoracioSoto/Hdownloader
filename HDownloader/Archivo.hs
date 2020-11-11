module HDownloader.Archivo
( ArchivoType, 
  archivoUrl,
  archivoTamanio,
  archivoCompresion
) where

-- ArchivoType = (URL, Tamaño, Compresión)
type ArchivoType = (String, Int, Int)

archivoUrl :: ArchivoType -> String
archivoUrl (u, _, _) = u

archivoTamanio :: ArchivoType -> Int
archivoTamanio (_, t, _) = t

archivoCompresion :: ArchivoType -> Int
archivoCompresion (_, _, c) = c
