import qualified Data.ByteString as BS
import Data.Bits (testBit)
import Data.List (transpose)

-- 1. Estructura para almacenar la imagen PBM P4
data PBMImage = PBMImage { width :: Int, height :: Int, pixelMatrix :: [[Bool]] }

-- 2. Lectura del encabezado y parseo del archivo binario P4
parsePBM :: BS.ByteString -> PBMImage
parsePBM bs = 
  let content = drop 3 (BS.unpack bs) -- Salta encabezado "P4\n" basico
      w = 567 -- Reemplazar con las dimensiones del encabezado si aplica
      h = 319
      bytesPerRow = (w + 7) `div` 8
      
      -- Convertir un byte en 8 valores booleanos (True = Negro, False = Blanco)
      byteToBits b = [testBit b (7 - i) | i <- [0..7]]
      
      -- Procesar cada fila
      allBits = concatMap byteToBits content
      rows = take h [take w (drop (i * bytesPerRow * 8) allBits) | i <- [0..h-1]]
  in PBMImage w h rows

-- 3. Funcion f(x): Contar pixeles negros consecutivos desde abajo
fx :: [[Bool]] -> Int -> Int
fx grid colIdx = 
  let column = map (!! colIdx) grid
      fromBottom = reverse column
  in length $ takeWhile id fromBottom

-- 4. Matriz/Vector M de alturas y Calculo del Area (Suma de Riemann)
main :: IO ()
main = do
  contents <- BS.readFile "../curva_binaria_P4.pbm"
  let img = parsePBM contents
      grid = pixelMatrix img
      
      -- M = [f(0), f(1), ..., f(n-1)] usando MAP
      mHeights = map (fx grid) [0 .. width img - 1]
      
      -- Area = Suma de Riemann con Delta_x = 1
      area = sum mHeights

  putStrLn $ "Imagen: " ++ show (width img) ++ " x " ++ show (height img) ++ " pixeles"
  putStrLn $ "Area: " ++ show area ++ " pixeles cuadrados"
  
  -- Muestra de 10 valores
  putStrLn "\nALGUNOS VALORES x_i -> f(x_i):"
  let step = width img `div` 10
  mapM_ (\i -> putStrLn $ "x_" ++ show i ++ " = " ++ show (i * step) ++ " -> f(x) = " ++ show (mHeights !! (i * step)) ++ " pixeles") [0..9]