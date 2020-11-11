module HDownloader.Servidor
( ServidorType,
  servidorNombre,
  servidorPoliticaAsignacionAnchoBanda
) where

-- ServidorType = (Dominio, PoliticaAsignacionAnchoBanda)
type ServidorType = (String, Int)

servidorNombre :: ServidorType -> String
servidorNombre (n, _) = n

servidorPoliticaAsignacionAnchoBanda :: ServidorType -> Int
servidorPoliticaAsignacionAnchoBanda (_, p) = p
