# Configuración WiFi con WiFiManager

## 📚 Instalación de la Librería

### Opción 1: Arduino IDE (Recomendado)
1. Abre el Arduino IDE
2. Ve a **Sketch → Include Library → Manage Libraries**
3. Busca `WiFiManager` por **tzapu**
4. Instala la última versión (asegúrate de que sea compatible con ESP8266)

### Opción 2: GitHub
```
https://github.com/tzapu/WiFiManager
```
Descarga el ZIP y agrega la librería en: **Sketch → Include Library → Add .ZIP Library**

---

## 🚀 Cómo Funciona

### Primera Vez / Cuando NO hay credenciales guardadas:

1. **Sube el código** a tu Wemos D1 Mini Pro
2. El ESP8266 creará un **punto de acceso WiFi** llamado: `SiloBolsa-Config`
3. Desde tu teléfono o computadora:
   - Conéctate a la red WiFi `SiloBolsa-Config`
   - Se abrirá automáticamente un portal web
   - Si no se abre, ve manualmente a: `http://192.168.4.1`
4. En el portal:
   - Haz clic en **"Configure WiFi"**
   - Selecciona tu red WiFi de la lista
   - Ingresa la contraseña
   - Presiona **"Save"**
5. El dispositivo se reiniciará y se conectará automáticamente

### Próximos Reinicios:
El dispositivo se conectará automáticamente usando las credenciales guardadas. ✅

---

## 🔄 Reconfigurar WiFi (Cambiar Red)

Tienes **3 opciones** para reconfigurar:

### Opción 1: Botón de Reset (Recomendado)
1. Conecta un **botón pulsador** entre el pin `D3` y `GND`
2. **Mantén presionado el botón** mientras reinicias el dispositivo (o mientras está iniciando)
3. Esto borrará las credenciales WiFi guardadas
4. El dispositivo creará nuevamente el punto de acceso `SiloBolsa-Config`
5. Repite el proceso de configuración

### Opción 2: Desde el código (Para testing)
En la función `setup()`, descomenta temporalmente esta línea:
```cpp
wifiManager.resetSettings();
```
Sube el código, espera a que borre las credenciales, y luego comenta la línea nuevamente.

### Opción 3: Borrar la Flash
Usa la herramienta de Arduino IDE:
- **Tools → Erase Flash → All Flash Contents**
- Luego vuelve a subir el código

---

## 🔧 Personalización

### Cambiar el nombre del punto de acceso:
```cpp
wifiManager.autoConnect("MiNombrePersonalizado");
```

### Agregar contraseña al punto de acceso:
```cpp
wifiManager.autoConnect("SiloBolsa-Config", "miPassword123");
```

### Cambiar timeout (tiempo de espera):
```cpp
wifiManager.setConfigPortalTimeout(180); // 180 segundos = 3 minutos
```

### Cambiar el pin del botón de reset:
```cpp
#define RESET_WIFI_PIN D5  // Cambia a cualquier pin digital
```

---

## 🎯 Ventajas

✅ **No más modificar código** para cada exposición  
✅ **Configuración fácil** desde cualquier dispositivo  
✅ **Credenciales persistentes** (se mantienen después de apagar)  
✅ **Portal cautivo automático** (se abre solo al conectarse)  
✅ **Detecta redes disponibles** (lista automática de WiFi cercanos)  
✅ **Compatible con ESP8266 y ESP32**  

---

## 🐛 Solución de Problemas

### El portal no se abre automáticamente:
- Ve manualmente a: `http://192.168.4.1`
- Asegúrate de estar conectado a la red `SiloBolsa-Config`

### No encuentra redes WiFi:
- Verifica que el WiFi esté a 2.4GHz (el ESP8266 no soporta 5GHz)

### No se conecta después de guardar:
- Verifica que la contraseña sea correcta
- Reinicia el dispositivo
- Usa el botón de reset para reconfigurar

### El dispositivo se reinicia constantemente:
- Verifica la alimentación (debe ser estable, 5V)
- Verifica las conexiones de los sensores

---

## 📝 Notas Adicionales

- Las credenciales se guardan en la **memoria flash EEPROM** del ESP8266
- El portal cautivo se cierra automáticamente después de conectarse exitosamente
- Puedes usar el monitor serial para ver el estado de la conexión
- El timeout por defecto del portal es de 3 minutos (si no se configura, se reinicia)

---

## 🔗 Recursos

- **Documentación oficial**: https://github.com/tzapu/WiFiManager
- **Ejemplos**: En Arduino IDE → File → Examples → WiFiManager
- **Comunidad**: https://github.com/tzapu/WiFiManager/issues

---

## 🎥 Flujo de Configuración

```
┌─────────────────────────────────────────────────┐
│  1. Encender dispositivo sin credenciales       │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│  2. Crear AP "SiloBolsa-Config"                 │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│  3. Conectarse desde teléfono/PC                │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│  4. Portal web se abre automáticamente          │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│  5. Seleccionar red y guardar contraseña        │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│  6. Dispositivo se conecta y guarda config      │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│  7. Próximos reinicios: conexión automática ✅  │
└─────────────────────────────────────────────────┘
```

---

¡Listo para usar en cualquier exposición! 🎉
