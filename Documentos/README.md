# Documentos
Link a Diagrama de Clases: https://drive.google.com/file/d/1a9vmQh__FBJ5-PTvD-qOFHAVKnLkaJI0/view?usp=drive_link
Link a Diagrama de Secuencia: https://drive.google.com/file/d/1lsHf9s3LwijJaHEWzZiDmixqbku1UzVV/view?usp=drive_link
Link a Diagrama de Arquitectura: https://drive.google.com/file/d/16yL3q94PbQy9YFrRg6I2cXuj5pHNpfHn/view?usp=drive_link
Link a Diagrama Componentes principales: https://drive.google.com/file/d/14H8ioJU9myDLcBBRoOL_QKX1qfOagHPq/view?usp=drive_link

# Calibración sensor MQ135 

Calibración paso a paso

    Instalación en aire limpio:
        Coloca el sensor en un ambiente conocido como aire limpio (normalmente al aire libre en un área libre de contaminantes o gases concentrados). El aire limpio tiene aproximadamente 400 ppm de CO₂.

    Lectura de R0:
        Con el sensor en aire limpio, calcula el valor de R0.
        Usa la función getRZero() o getCorrectedRZero() si tienes mediciones de temperatura y humedad.

        Guardar el valor de R0:

    Una vez que obtengas el valor de R0 en aire limpio, guárdalo en tu código para futuras lecturas. Este valor no debería cambiar a menos que cambien las condiciones ambientales.
    Agrega una variable como:

    # Link placa Wemis D1 Mini V3.0: https://uelectronics.com/producto/wemos-d1-mini-v3-0-modulo-wifi-esp8266ex/?srsltid=AfmBOopbCbupWz1ujJ1MvqN6_TdiQEBOt-sU-R10cR0o33ZOr2kTLhTZ
