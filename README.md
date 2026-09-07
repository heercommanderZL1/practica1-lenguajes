# Práctica I: From Pixels to Integral / Cálculo de Suma de Riemann sobre Imágenes PBM (P4)
**Asignatura:** Lenguajes de Programación (ST0244)  
**Universidad:** Universidad EAFIT  
**Profesor:** Alexander Narváez Berrío  

## Integrantes
* Miguel Ángel Córdoba Garrido
* Samuel David Gomez Ramirez

## Entorno de Desarrollo
* **Haskell:** GHC v9.x
* **Prolog:** SWI-Prolog v9.x
* **Sistema Operativo:** Windows / Linux

---

## Descripción del Proyecto
Este repositorio contiene la solución para la **Práctica I** del curso **Lenguajes de Programación**. El objetivo principal es calcular la Suma de Riemann (área bajo la curva en píxeles cuadrados) a partir del análisis binario de una imagen en formato PBM (`curva_binaria_P4.pbm`), implementando dos paradigmas de programación diferentes: **Funcional (Haskell)** y **Lógico (Prolog)**.

---

## Estructura del Repositorio

```text
.
├── curva_binaria_P4.pbm   # Archivo de imagen binario P4 (567x319)
├── Haskell/
│   └── Main.hs            # Solución funcional en Haskell
├── Prolog/
│   └── Main.pl            # Solución lógica en Prolog
└── README.md              # Documentación de la práctica

------------------------------------------------------------------

## Ejecutable desde PowerShell

cd Haskell
runhaskell Main.hs

cd Prolog
swipl -g "calcular_area, halt." Main.pl

¡POR SI NO TIENE EL PATH GLOBAL!

& "C:\Program Files\swipl\bin\swipl.exe" -g "calcular_area, halt." Main.pl
