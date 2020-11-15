module HDownloader.Servidor
( ServidorType,
  ElementoListaNegraType,
  nombreServidor,
  politicaAsignacionAnchoBandaServidor,
  descargasRecientesServidor,
  listaNegraServidor,
  urlElementoListaNegra,
  coeficienteElementoListaNegra
) where

-- ServidorType = (Dominio, PoliticaAsignacionAnchoBanda, DescargasRecientes, [ListaNegraArchivo])
type ServidorType = (String, Float, Int, [ElementoListaNegraType])

-- ElementoListaNegraType = (URL, Coeficiente)
type ElementoListaNegraType = (String, Float)

nombreServidor :: ServidorType -> String
nombreServidor (n, _, _, _) = n

politicaAsignacionAnchoBandaServidor :: ServidorType -> Float
politicaAsignacionAnchoBandaServidor (_, p, _, _) = p

descargasRecientesServidor :: ServidorType -> Int
descargasRecientesServidor (_, _, d, _) = d

listaNegraServidor :: ServidorType -> [ElementoListaNegraType]
listaNegraServidor (_, _, _, l) = l

urlElementoListaNegra :: ElementoListaNegraType -> String
urlElementoListaNegra (u, _) = u

coeficienteElementoListaNegra :: ElementoListaNegraType -> Float
coeficienteElementoListaNegra (_, c) = c
