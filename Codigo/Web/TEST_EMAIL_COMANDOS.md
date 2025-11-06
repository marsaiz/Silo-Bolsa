# 📧 Comandos para Probar Envío de Emails de Alertas

## 🎯 Cómo Funciona

El sistema envía un email automáticamente cuando detecta **condiciones extremas** en las lecturas:
- **Temperatura** fuera del rango del grano
- **Humedad** fuera del rango del grano
- **CO2** fuera del rango (no se evalúa actualmente en el código)

**Email destino:** `marcelosaizestudio@gmail.com` (configurado en `LecturaServicio.cs`)

---

## 🚀 Opción 1: Script Completo de Prueba

```bash
cd /home/marcelo-aberlardo-saiz/Proyectos/Silo-Bolsa/Codigo/Web
./test_email_alert.sh
```

Este script ejecuta 5 tests:
1. ✅ Lectura normal (no alerta)
2. 🚨 Temperatura alta (alerta)
3. 🚨 Humedad alta (alerta)
4. 🚨 Temperatura baja (alerta)
5. 🚨 Múltiples condiciones extremas (alerta)

---

## ⚡ Opción 2: Comandos Individuales

### Límites del Trigo (idGrano: 1)
- **Temperatura:** 5°C a 50°C
- **Humedad:** 5% a 50%
- **CO2:** 400 ppm a 800 ppm

### 🚨 Test: Temperatura ALTA (envía email)

```bash
curl -X POST https://remarkable-healing-production.up.railway.app/api/lecturas \
  -H "Content-Type: application/json" \
  -d '{
    "fechaHoraLectura": "2025-11-06T18:30:00Z",
    "temp": 55,
    "humedad": 30,
    "dioxidoDeCarbono": 600,
    "idCaja": "066cd7cc-0cc7-4800-af0b-290a86639117"
  }'
```

**Resultado esperado:** 
- Respuesta: `"Lectura agregada correctamente"`
- Email enviado a `marcelosaizestudio@gmail.com` con asunto: `"Alerta en Silo trigo 2025"`

---

### 🚨 Test: Humedad ALTA (envía email)

```bash
curl -X POST https://remarkable-healing-production.up.railway.app/api/lecturas \
  -H "Content-Type: application/json" \
  -d '{
    "fechaHoraLectura": "2025-11-06T18:35:00Z",
    "temp": 25,
    "humedad": 65,
    "dioxidoDeCarbono": 600,
    "idCaja": "066cd7cc-0cc7-4800-af0b-290a86639117"
  }'
```

---

### 🚨 Test: Temperatura BAJA (envía email)

```bash
curl -X POST https://remarkable-healing-production.up.railway.app/api/lecturas \
  -H "Content-Type: application/json" \
  -d '{
    "fechaHoraLectura": "2025-11-06T18:40:00Z",
    "temp": 2,
    "humedad": 30,
    "dioxidoDeCarbono": 600,
    "idCaja": "066cd7cc-0cc7-4800-af0b-290a86639117"
  }'
```

---

### ✅ Test: Lectura NORMAL (NO envía email)

```bash
curl -X POST https://remarkable-healing-production.up.railway.app/api/lecturas \
  -H "Content-Type: application/json" \
  -d '{
    "fechaHoraLectura": "2025-11-06T18:45:00Z",
    "temp": 25,
    "humedad": 30,
    "dioxidoDeCarbono": 600,
    "idCaja": "066cd7cc-0cc7-4800-af0b-290a86639117"
  }'
```

---

## 🔍 Verificar Resultados

### 1. Ver alertas creadas:
```bash
curl https://remarkable-healing-production.up.railway.app/api/alertas | jq
```

### 2. Ver alertas del silo de trigo:
```bash
curl https://remarkable-healing-production.up.railway.app/api/alertas | \
  jq '.["$values"][] | select(.idSilo == "066cd7cc-0cc7-4800-af0b-290a86639116")'
```

### 3. Ver solo alertas con correo enviado:
```bash
curl https://remarkable-healing-production.up.railway.app/api/alertas | \
  jq '.["$values"][] | select(.correoEnviado == true)'
```

### 4. Ver última alerta:
```bash
curl https://remarkable-healing-production.up.railway.app/api/alertas | \
  jq '.["$values"][-1]'
```

---

## 📧 Formato del Email

**Asunto:** `Alerta en Silo trigo 2025`

**Cuerpo:**
```
Se ha detectado una condición extrema en el silo trigo 2025:
Temperatura: 55ºC
Humedad: 30%
CO2: 600
Fecha y Hora: 2025-11-06 18:30:00

Por favor, tome las medidas necesarias.
```

---

## 💡 Notas Importantes

1. **Una alerta por silo:** El sistema solo envía 1 email por silo mientras las condiciones sean extremas. No enviará otro hasta que las condiciones vuelvan a la normalidad.

2. **Campo `correoEnviado`:** 
   - `true` = Email enviado correctamente
   - `false` = Email no enviado (error o condiciones normalizadas)

3. **Logs en Railway:** Puedes ver los logs del envío de email en el dashboard de Railway:
   ```
   Alerta creada para el silo trigo 2025 : Condiciones extremas...
   Correo de alerta enviado a marcelosaizestudio@gmail.com
   ```

4. **Configuración SMTP:** Verifica que las variables de entorno estén configuradas en Railway:
   - `EmailSettings__SmtpServer`
   - `EmailSettings__SmtpPort`
   - `EmailSettings__SmtpUser`
   - `EmailSettings__SmtpPassword`

---

## 🐛 Troubleshooting

### No llega el email:
1. Verifica logs en Railway
2. Revisa carpeta de SPAM
3. Confirma que `EmailSettings` están configurados
4. Verifica que la API responde `200 OK`

### Ver logs en Railway:
```bash
# O desde el dashboard de Railway → View Logs
```

### Email llegó pero `correoEnviado: false`:
- Significa que hubo un error al enviar (revisa logs)
- O que las condiciones volvieron a la normalidad

---

## 🧪 Ejemplo Completo de Test

```bash
# 1. Enviar lectura con temperatura alta
echo "🚨 Enviando lectura con temperatura extrema..."
curl -X POST https://remarkable-healing-production.up.railway.app/api/lecturas \
  -H "Content-Type: application/json" \
  -d '{"fechaHoraLectura":"2025-11-06T18:30:00Z","temp":55,"humedad":30,"dioxidoDeCarbono":600,"idCaja":"066cd7cc-0cc7-4800-af0b-290a86639117"}'

# 2. Esperar 2 segundos
sleep 2

# 3. Verificar que se creó la alerta
echo -e "\n📋 Verificando alerta creada..."
curl -s https://remarkable-healing-production.up.railway.app/api/alertas | \
  jq '.["$values"][-1] | {mensaje, correoEnviado, fechaHoraAlerta}'

# 4. Revisar email en marcelosaizestudio@gmail.com
echo -e "\n📧 Revisa tu email en marcelosaizestudio@gmail.com"
```

---

**¿Quieres cambiar el email destino?**  
Edita `SiloBolsa.Servicios/Negocio/LecturaServicio.cs` línea 130 y cambia `marcelosaizestudio@gmail.com` por el email deseado.
