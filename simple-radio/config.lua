Config = {}

-- Configuración general
Config.ItemName = 'radio' -- Nombre del item en ox_inventory
Config.MaxFrequency = 999.9 -- Frecuencia máxima
Config.MinFrequency = 1.0 -- Frecuencia mínima

-- Tecla para hablar por radio (CAPS LOCK por defecto)
-- Puedes cambiarla a: 'Z' = 20, 'X' = 73, 'CAPS' = 137
Config.RadioKey = 137 -- CAPS LOCK (cerca del ojo pero no ALT)

-- Animación al hablar
Config.Animation = {
    dict = 'random@arrests',
    anim = 'generic_radio_chatter',
    flag = 49
}

-- Volumen por defecto
Config.DefaultVolume = 50

-- Canales favoritos predefinidos
Config.FavoriteChannels = {
    {name = 'Policía', frequency = 1.0},
    {name = 'EMS', frequency = 2.0},
    {name = 'Mecánicos', frequency = 3.0},
}

-- Restricciones de canales (ACTIVADO)
Config.RestrictedChannels = {
    [1.0] = {'police', 'sheriff', 'lspd', 'bcso'}, -- Solo policía
    [2.0] = {'ambulance', 'ems', 'doctor'}, -- Solo EMS
    [3.0] = {'mechanic', 'mecano'}, -- Solo mecánicos
}

-- Configuración de UI
Config.UIPosition = {
    x = 50, -- Posición X en porcentaje
    y = 50  -- Posición Y en porcentaje
}

-- Mensajes
Config.Locale = {
    ['radio_on'] = 'Radio encendida',
    ['radio_off'] = 'Radio apagada',
    ['frequency_changed'] = 'Frecuencia cambiada a: %s MHz',
    ['no_radio'] = 'No tienes una radio',
    ['invalid_frequency'] = 'Frecuencia inválida',
    ['restricted_channel'] = 'No tienes acceso a este canal'
}
