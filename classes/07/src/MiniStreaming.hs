module MiniStreaming where

-- Novo tipo Movie composto por uma tupla: (título, gênero, avaliação)
type Movie = (String, String, Int)


movies :: [Movie]
movies =
  [ ("The Lambda Knight", "action", 8)
  , ("Pure Love", "romance", 6)
  , ("Recursive Nights", "sci-fi", 9)
  , ("List Wars", "action", 5)
  , ("Monads of Mystery", "drama", 7)
  , ("Higher Order Hearts", "romance", 8)
  ]

-- Obtenha somente os filmes com avaliação >= 7
goodMovies :: [Movie] -> [Movie]
goodMovies = undefined

-- Obtenha somente os filmes do gênero especificado
moviesByGenre :: String -> [Movie] -> [Movie]
moviesByGenre = undefined

-- Extraia apenas os nomes dos filmes
onlyNames :: [Movie] -> [String]
onlyNames = undefined

-- Combine as funções anteriores para recomendar filmes de um gênero específico com boa avaliação
recommend :: String -> [Movie] -> [String]
recommend genre ts = undefined

-- Exemplos:
-- recommend "action" movies
-- ["The Lambda Knight"]
--
-- recommend "romance" movies
-- ["Higher Order Hearts"]
--
-- recommend "sci-fi" movies
-- ["Recursive Nights"]
--
-- recommend "drama" movies
-- ["Monads of Mystery"]