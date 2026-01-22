# 📻 Simple Radio | Realistic Handheld Interface

![GitHub License](https://img.shields.io/badge/license-Personal_Use-blueviolet)
![Platform](https://img.shields.io/badge/framework-ESX_Legacy-blue)
![Dependencies](https://img.shields.io/badge/dependencies-ox__inventory%20%7C%20pma--voice-orange)

Una interfaz de radio portátil realista, inmersiva y totalmente integrada con el inventario. Diseñada para **ESX Legacy**, ofrece controles tácticos, restricciones por trabajo y animaciones visuales.

<p align="center">
  <img src="https://github.com/user-attachments/assets/5b34233c-0106-43a9-a73e-1c081ab4cf4d" alt="Radio UI" width="45%">
  <img src="https://github.com/user-attachments/assets/de538bdc-2ae3-4d95-8fa0-f30f1e723b01" alt="Radio In-Game" width="45%">
</p>

---

## ✨ Features | Características

* ✅ **Realistic UI:** Interfaz de radio portátil con diseño realista (Handheld).
* ✅ **Inventory Integration:** Integración total con `ox_inventory` (arrastrar y usar).
* ✅ **Frequencies:** Rango extendido de frecuencias desde **1.0 MHz** hasta **999.9 MHz**.
* ✅ **Restricted Channels:** Canales bloqueados para trabajos específicos (Policía, EMS, Mecánicos).
* ✅ **Interactive Controls:** Perillas interactivas para volumen/encendido y teclado numérico funcional.
* ✅ **Visuals:** Animación de mano al hombro e indicador LED de estado.

---

## 🕹️ Usage | Modo de Uso

| Action / Acción | Method / Método |
| :--- | :--- |
| **Open / Abrir** | Comando `/radio` o usar el ítem desde el inventario. |
| **Power / Encender** | Click en la perilla derecha o en el botón LED. |
| **Volume / Volumen** | Click en la perilla izquierda para ajustar niveles. |
| **Frequency / Frecuencia** | Botón **MENU** → Ingresar dígitos → Presionar **#**. |
| **Transmit / Transmitir** | Mantener presionado **CAPS LOCK** (Configurable). |

---

## 🛠️ Installation | Instalación

1. **Download:** Descarga y extrae la carpeta en `resources/[esx]/simple-radio/`.
2. **Ox Inventory:** Añade el siguiente bloque en `ox_inventory/data/items.lua`:

```lua
['radio'] = {
    label = 'Radio',
    weight = 220,
    stack = false,
    close = true,
    description = 'Communication Radio / Radio de comunicación',
    client = {
        image = 'radio.png',
        export = 'simple-radio.useRadio'
    }
},

---

## ⚙️ Configuration | Configuración

Puedes ajustar las teclas y canales restringidos en el archivo config.lua:

Lua
Config.RadioKey = 137  -- Tecla PTT (137 = CAPS LOCK, 20 = Z)

Config.RestrictedChannels = {
    [1.0] = {'police', 'sheriff'},
    [2.0] = {'ambulance', 'ems'},
    [3.0] = {'mechanic'},
}

---

📦 Dependencies | Dependencias

## 📦 Dependencies | Dependencias

| Resource | Description | Descripción |
| :--- | :--- | :--- |
| **ESX Legacy** | Framework core. | Base del servidor. |
| **ox_inventory** | Item logic & usage. | Lógica de ítems y uso. |
| **pma-voice** | Voice system (or compatible). | Sistema de voz (o compatible). |


## 📜 License & Terms | Licencia y Términos

| Condition | English | Español |
| :--- | :--- | :--- |
| 🚫 **Re-upload** | Do not re-upload: Licensed & registered. | No resubir: Script bajo licencia y registrado. |
| 🔐 **Personal Use** | Free to use and edit for your server. | Libre de usar y editar para tu servidor. |
| ⚙️ **Optimized** | High performance & clean code. | Alto rendimiento y código limpio. |

---

## 📢 Support | Soporte

¿Buscas actualizaciones o nuevos scripts? ¡Únete a nuestra comunidad!

[![Discord Shield](https://img.shields.io/badge/Discord-Join%20Us-7289da?style=for-the-badge&logo=discord)](https://discord.gg/2W9PMsYWTZ)
