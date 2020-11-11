module HDownloader (
    Archivo.archivoUrl,
    Archivo.archivoTamanio,
    Archivo.archivoCompresion,
    Servidor.servidorNombre,
    Servidor.servidorPoliticaAsignacionAnchoBanda,
    Descarga.descargaNombre,
    Descarga.descargaArchivos,
    Descarga.descargaServidor,
    Descarga.descargaPrioridad,
    Descarga.descargaEspacioNecesario
) where

import qualified HDownloader.Archivo as Archivo
import qualified HDownloader.Servidor as Servidor
import qualified HDownloader.Descarga as Descarga
