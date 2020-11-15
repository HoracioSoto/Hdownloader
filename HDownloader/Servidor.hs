module HDownloader.Servidor
( ServidorType,
  ElementoListaNegraType,
  nombreServidor,
  politicaAsignacionAnchoBandaServidor,
  descargasRecientesServidor,
  listaNegraServidor
) where

-- ServidorType = (Dominio, PoliticaAsignacionAnchoBanda, DescargasRecientes, [ListaNegraArchivo])
type ServidorType = (String, Int, Int, [ElementoListaNegraType])

-- ElementoListaNegraType = (URL, Coeficiente)
type ElementoListaNegraType = (String, Float)

nombreServidor :: ServidorType -> String
nombreServidor (n, _, _, _) = n

politicaAsignacionAnchoBandaServidor :: ServidorType -> Int
politicaAsignacionAnchoBandaServidor (_, p, _, _) = p

descargasRecientesServidor :: ServidorType -> Int
descargasRecientesServidor (_, _, d, _) = d

listaNegraServidor :: ServidorType -> [ElementoListaNegraType]
listaNegraServidor (_, _, _, l) = l
