import qualified Data.ByteString as BS
import Data.Bits (testBit)
import Data.Word (Word8)
import Data.List (transpose)

-- 1. Estructura para almacenar la imagen PBM P4
data PBMImage = PBMImage { width :: Int, height :: Int, pixelMatrix :: [[Bool]] }

-- 2. Convertir un byte en 8 bits (True = Negro / 1, False = Blanco / 0)
byteToBits :: Word8 -> [Bool]
byteToBits b = [testBit b (7 - i) | i <- [0..7]]

-- 3. Parseo del archivo binario PBM P4
parsePBM :: BS.ByteString -> PBMImage
parsePBM bs = 
  let bytes = BS.unpack bs
      -- Dimensiones fijas asignadas según la imagen de la práctica
      w = 567
      h = 319
      bytesPerRow = (w + 7) `div` 8
      
      -- Tomar los últimos (h * bytesPerRow) bytes correspondientes al mapa de bits
      imageBytes = drop (length bytes - (h * bytesPerRow)) bytes
      
      -- Convertir bytes a bits
      allBits = concatMap byteToBits imageBytes
      
      -- Reconstruir la matriz de filas
      rows = [take w (drop (i * bytesPerRow * 8) allBits) | i <- [0..h-1]]
  in PBMImage w h rows

-- 4. Función f(x): Contar píxeles negros consecutivos desde el fondo (abajo hacia arriba)
countBlackFromBottom :: [Bool] -> Int
countBlackFromBottom col = length $ takeWhile id (reverse col)

main :: IO ()
main = do
  -- Lectura del archivo binario proporcionado
  contents <- BS.readFile "../curva_binaria_P4.pbm"
  let img = parsePBM contents
      grid = pixelMatrix img
      
      -- Traspuesta para obtener las columnas como listas directamente
      columns = transpose grid
      
      -- M = [f(0), f(1), ..., f(n-1)] aplicando map sobre las columnas
      mHeights = map countBlackFromBottom columns
      
      -- Suma de Riemann para el cálculo del Área (Delta_x = 1)
      area = sum mHeights

  putStrLn $ "Imagen cargada: " ++ show (width img) ++ " x " ++ show (height img) ++ " pixeles"
  putStrLn $ "Area total calculada: " ++ show area ++ " pixeles cuadrados"
  
  -- Muestreo de 10 posiciones x_i -> f(x_i)
  putStrLn "\nALGUNOS VALORES x_i -> f(x_i):"
  let step = width img `div` 10
  mapM_ (\i -> let x = i * step 
               in putStrLn $ "x_" ++ show i ++ " = " ++ show x ++ " -> f(x) = " ++ show (mHeights !! x) ++ " pixeles") [0..9]