ESX = exports['es_extended']:getSharedObject()

-- Variables locales
local radioOpen = false
local radioPowered = false
local currentFrequency = 0.0
local currentVolume = Config.DefaultVolume
local hasRadio = false
local isTransmitting = false
local radioChannel = 0
local favoriteChannels = {}

-- Animación
local radioAnimation = {
    dict = Config.Animation.dict,
    anim = Config.Animation.anim,
    flag = Config.Animation.flag
}

-- Función para verificar si el jugador tiene radio
function HasRadio()
    return hasRadio
end

-- Función para abrir/cerrar la radio
function ToggleRadio()
    if not HasRadio() then
        ESX.ShowNotification(Config.Locale['no_radio'])
        return
    end
    
    radioOpen = not radioOpen
    
    if radioOpen then
        OpenRadio()
    else
        CloseRadio()
    end
end

-- Función para abrir la radio
function OpenRadio()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        frequency = currentFrequency,
        volume = currentVolume,
        powered = radioPowered,
        favorites = favoriteChannels
    })
    radioOpen = true
end

-- Función para cerrar la radio
function CloseRadio()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'close'
    })
    radioOpen = false
end

-- Función para conectar a un canal de radio
function ConnectToRadio(frequency)
    if frequency > 0 then
        -- Integración con pma-voice
        exports['pma-voice']:setRadioChannel(frequency)
        radioChannel = frequency
        currentFrequency = frequency
        radioPowered = true
        ESX.ShowNotification(string.format(Config.Locale['frequency_changed'], frequency))
    else
        -- Desconectar de la radio
        exports['pma-voice']:setRadioChannel(0)
        radioChannel = 0
        currentFrequency = 0
        radioPowered = false
        ESX.ShowNotification(Config.Locale['radio_off'])
    end
end

-- Función para verificar restricciones de canal
function CanAccessChannel(frequency)
    if not Config.RestrictedChannels[frequency] then
        return true
    end
    
    local playerData = ESX.GetPlayerData()
    local playerJob = playerData.job.name
    
    for _, allowedJob in ipairs(Config.RestrictedChannels[frequency]) do
        if playerJob == allowedJob then
            return true
        end
    end
    
    return false
end

-- Función para establecer volumen
function SetRadioVolume(volume)
    currentVolume = volume
    exports['pma-voice']:setRadioVolume(volume)
end

-- Callbacks NUI
RegisterNUICallback('close', function(data, cb)
    CloseRadio()
    cb({status = 'ok'})
end)

RegisterNUICallback('setFrequency', function(data, cb)
    local frequency = tonumber(data.frequency)
    
    if frequency then
        if frequency < Config.MinFrequency or frequency > Config.MaxFrequency then
            ESX.ShowNotification(Config.Locale['invalid_frequency'])
            cb({status = 'error', message = 'invalid_frequency'})
            return
        end
        
        if not CanAccessChannel(frequency) then
            ESX.ShowNotification(Config.Locale['restricted_channel'])
            -- Notificar a la UI que el canal está bloqueado
            SendNUIMessage({
                action = 'channelRestricted'
            })
            cb({status = 'error', message = 'restricted'})
            return
        end
        
        ConnectToRadio(frequency)
    end
    
    cb({status = 'ok'})
end)

RegisterNUICallback('setVolume', function(data, cb)
    local volume = tonumber(data.volume)
    
    if volume then
        SetRadioVolume(volume)
    end
    
    cb({status = 'ok'})
end)

RegisterNUICallback('togglePower', function(data, cb)
    radioPowered = data.powered
    
    if radioPowered then
        if currentFrequency > 0 then
            ConnectToRadio(currentFrequency)
        end
        ESX.ShowNotification(Config.Locale['radio_on'])
    else
        ConnectToRadio(0)
        ESX.ShowNotification(Config.Locale['radio_off'])
    end
    
    cb({status = 'ok'})
end)

RegisterNUICallback('saveFavorites', function(data, cb)
    favoriteChannels = data.favorites
    TriggerServerEvent('simple-radio:saveFavorites', favoriteChannels)
    cb({status = 'ok'})
end)

-- Comando /radio
RegisterCommand('radio', function()
    ToggleRadio()
end, false)

-- Tecla para hablar (CAPS LOCK por defecto)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if HasRadio() and radioPowered and currentFrequency > 0 then
            -- Detectar cuando se presiona la tecla
            if IsControlPressed(0, Config.RadioKey) then
                if not isTransmitting then
                    isTransmitting = true
                    
                    -- Iniciar animación
                    RequestAnimDict(radioAnimation.dict)
                    while not HasAnimDictLoaded(radioAnimation.dict) do
                        Citizen.Wait(100)
                    end
                    
                    TaskPlayAnim(PlayerPedId(), radioAnimation.dict, radioAnimation.anim, 8.0, -8.0, -1, radioAnimation.flag, 0, false, false, false)
                    
                    -- Notificar a la UI
                    SendNUIMessage({
                        action = 'setTransmitting',
                        transmitting = true
                    })
                end
            else
                if isTransmitting then
                    isTransmitting = false
                    
                    -- Detener animación
                    StopAnimTask(PlayerPedId(), radioAnimation.dict, radioAnimation.anim, 1.0)
                    
                    -- Notificar a la UI
                    SendNUIMessage({
                        action = 'setTransmitting',
                        transmitting = false
                    })
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- Event para cuando el jugador recibe la radio
RegisterNetEvent('simple-radio:receiveRadio')
AddEventHandler('simple-radio:receiveRadio', function()
    hasRadio = true
end)

-- Event para abrir la radio (cuando se usa desde inventario)
RegisterNetEvent('simple-radio:openRadio')
AddEventHandler('simple-radio:openRadio', function()
    if not radioOpen then
        OpenRadio()
    else
        CloseRadio()
    end
end)

-- Event para cuando el jugador pierde la radio
RegisterNetEvent('simple-radio:removeRadio')
AddEventHandler('simple-radio:removeRadio', function()
    hasRadio = false
    radioPowered = false
    ConnectToRadio(0)
    
    if radioOpen then
        CloseRadio()
    end
end)

-- Event para cargar favoritos
RegisterNetEvent('simple-radio:loadFavorites')
AddEventHandler('simple-radio:loadFavorites', function(favorites)
    favoriteChannels = favorites or {}
end)

-- Verificar si el jugador tiene radio al iniciar
Citizen.CreateThread(function()
    Citizen.Wait(2000)
    TriggerServerEvent('simple-radio:checkRadio')
end)

-- Cargar canales favoritos predefinidos
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    
    if #favoriteChannels == 0 then
        for _, channel in ipairs(Config.FavoriteChannels) do
            table.insert(favoriteChannels, {
                name = channel.name,
                frequency = tostring(channel.frequency)
            })
        end
    end
end)

-- Limpiar al desconectar
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if radioPowered then
            ConnectToRadio(0)
        end
        
        if radioOpen then
            CloseRadio()
        end
        
        if isTransmitting then
            StopAnimTask(PlayerPedId(), radioAnimation.dict, radioAnimation.anim, 1.0)
        end
    end
end)

-- Exportar funciones
exports('HasRadio', HasRadio)
exports('ToggleRadio', ToggleRadio)
exports('ConnectToRadio', ConnectToRadio)
exports('SetRadioVolume', SetRadioVolume)

-- Export para ox_inventory
exports('useRadio', function(data, slot)
    ToggleRadio()
end)
