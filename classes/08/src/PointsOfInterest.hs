module PointsOfInterest where

import Text.Printf

-- Latitude e longitude de alguns Pontos de Interesse na UFSM
poiList :: [(String, Double, Double)]
poiList = [("Centro de Tecnologia", -29.713318, -53.71663),
           ("Biblioteca Central", -29.71566, -53.71523),
           ("Centro de Convenções", -29.72237, -53.71718),
           ("Planetário", -29.72027, -53.71726),
           ("Reitoria da UFSM", -29.72083, -53.71479),
           ("Restaurante Universitário 2", -29.71400, -53.71937),
           ("HUSM", -29.71368, -53.71536),
           ("Pulsar Incubadora Tecnológica - Prédio 2", -29.71101, -53.71634),
           ("Pulsar Incubadora Tecnológica - Prédio 61H", -29.72468, -53.71335),
           ("Casa do Estudante Universitário - CEU II", -29.71801, -53.71465)]


      
-- Função para calcular a distância entre 2 pontos sobre uma esfera, usando a fórmula de Haversine 
-- com latitudes e longitudes, conforme: https://pt.wikipedia.org/wiki/F%C3%B3rmula_de_haversine
-- Questão 1: REESCREVA este código usando where
calcDistance :: Double -> Double -> Double -> Double -> Double
calcDistance lat1 lon1 lat2 lon2 = 
    let r = 6371.0 -- Earth's radius in km
        dLat = (lat2 - lat1) * pi / 180.0
        dLon = (lon2 - lon1) * pi / 180.0
        a = sin (dLat / 2.0) * sin (dLat / 2.0) +
            cos (lat1 * pi / 180.0) * cos (lat2 * pi / 180.0) *
            sin (dLon / 2.0) * sin (dLon / 2.0)
        c = 2.0 * atan2 (sqrt a) (sqrt (1.0 - a))
    in r * c



main :: IO ()
main = do

  -- Um ponto de referência no Jardim Botânico
  let givenLat = -29.71689::Float
      givenLon = -53.72968::Float

  -- Distância máxima para filtragem (em km)
  let maxDistance = 1.5

  -- Obtém e mostra apenas as latitudes
  let latitudes = map (\(n,lat,lon) -> lat) poiList
  putStrLn "\n==> Latitudes:"
  mapM_ print latitudes

  -- Questão 2. Complete a linha abaixo para definir 'distances' como uma nova lista construída a partir de poiList.
  -- A nova lista será uma lista de tuplas contendo, para cada POI, seu nome e sua distância até o ponto de referência, 
  -- dado por givenLat e givenLon
  
  let distances = COMPLETE
  putStrLn "\n==> Distância de cada ponto até o ponto de referência:"
  mapM_ (\(n, d) -> printf "%s: %f\n" n d) distances

  -- Questão 3. Complete a linha abaixo para definir 'selectedPOIs' como uma nova lista construída a partir de poiList.
  -- A nova lista deverá conter apenas os pontos de interesse cuja distância do ponto de referência seja >= maxDistance

  let selectedPOIs = COMPLETE 
  printf "\n==> Pontos distantes do ponto de referência (%.6f, %.6f):\n" givenLat givenLon
  mapM_ print selectedPOIs
  