# API de WhatsApp

Esta documentación detalla cómo consumir la API interactiva para el envío de mensajes de WhatsApp a través del servicio de Delivery de Yupio.

---

### Detalles de Acceso
- **Swagger Interactivo:** [https://template-delivery-service.yupio.com.mx/docs](https://template-delivery-service.yupio.com.mx/docs)
- **App Name (`UserName`):** `CentroLibanesTest`
- **Authentication Token:** `0ad25924-8f6d-4c25-bd4f-f2615bffa589`

---

### Endpoint de Envío
- **URL:** `https://template-delivery-service.yupio.com.mx/api/v1/whatsapp/send`
- **Método:** `POST`

### Headers Requeridos
| Header | Valor |
| :--- | :--- |
| `accept` | `application/json` |
| `UserName` | `CentroLibanesTest` |
| `AuthenticationToken` | `0ad25924-8f6d-4c25-bd4f-f2615bffa589` |
| `Content-Type` | `application/json; charset=utf-8` |

---

### Ejemplo de Consumo (CURL)
```bash
curl --location 'https://template-delivery-service.yupio.com.mx/api/v1/whatsapp/send' \
--header 'accept: application/json' \
--header 'UserName: CentroLibanesTest' \
--header 'AuthenticationToken: 0ad25924-8f6d-4c25-bd4f-f2615bffa589' \
--header 'Content-Type: application/json; charset=utf-8' \
--data '{
    "destinations": [
        {
            "destination": "5219212575914"
        }
    ],
    "message": {
        "template": {
            "namespace": "15603036_2827_4f78_b442_896b07ba6069",
            "elementName": "msg_test_v1",
            "languagePolicy": "DETERMINISTIC",
            "languageCode": "es_MX",
            "bodyParameters": ["Luis", "8:00", "Centro Libanés"]
        }
    }
}'
```

---

### Estructura del Payload
El servicio utiliza templates predefinidos de WhatsApp:

- **destinations**: Arreglo de destinatarios. Cada objeto debe contener un `destination` (número con código de país, ej: `521...`).
- **message.template**: 
    - `namespace`: ID del namespace del template en Meta/WhatsApp.
    - `elementName`: Nombre técnico del template (ej: `msg_test_v1`).
    - `languageCode`: Idioma configurado para el template (ej: `es_MX`).
    - `bodyParameters`: Lista de strings que reemplazarán las variables `{{1}}`, `{{2}}`, etc., en el template.

---
*Última actualización: Marzo 2026*
