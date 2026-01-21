🚀 Features | Características
- ✅ Interface: Realistic handheld radio UI / Interfaz realista de radio portátil.
- ✅ Inventory: ox_inventory integration (drag & use) / Integración total (arrastrar y usar).
- ✅ Access: /radio command support / Soporte de comando /radio.
- ✅ PTT Key: Customizable (Default: CAPS LOCK) / Tecla PTT configurable.
- ✅ Range: 1.0 - 999.9 MHz frequency range / Rango de frecuencias extendido.
- ✅ Jobs: Restricted channels (Police, EMS, Mechanic) / Canales restringidos por trabajo.
- ✅ Controls: Interactive knobs & numeric keypad / Perillas interactivas y teclado numérico.
- ✅ Visuals: Shoulder animation & power indicator / Animación de hombro e indicador de encendido.

🛠️ Installation | Instalación
Download / Descargar: Extract to / Extraer en resources/[esx]/simple-radio/
Config: Add to / Agregar al server.cfg:
ensure simple-radio

Ox Inventory Setup: Add this to / Agregar esto a ox_inventory/data/items.lua:
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

🕹️ Usage | Modo de Uso
- Open / Abrir: /radio or use from inventory / o usar desde inventario.
- Power / Encender: Click right knob or LED / Click en perilla derecha o botón LED.
- Volume / Volumen: Click left knob / Click en perilla izquierda.
- Frequency / Frecuencia: MENU → Enter digits / Ingresar dígitos → Press / Presionar #.
- Transmit / Transmitir: Hold / Mantener CAPS LOCK.

⚙️ Configuration | Configuración (config.lua)
Config.RadioKey = 137  -- PTT key (137=CAPS, 20=Z, 73=X)

Config.RestrictedChannels = {
    [1.0] = {'police', 'sheriff'},
    [2.0] = {'ambulance', 'ems'},
    [3.0] = {'mechanic'},
}

📦 Dependencies | Dependencias
- ESX-Legacy
- ox_inventory
- pma-voice (or compatible)
<p align="center">
  <img src="https://github.com/user-attachments/assets/5b34233c-0106-43a9-a73e-1c081ab4cf4d" alt="SIMPLEHUD" width="1000">
  <img src="https://github.com/user-attachments/assets/de538bdc-2ae3-4d95-8fa0-f30f1e723b01" alt="SIMPLEHUD" width="1000">
</p>
