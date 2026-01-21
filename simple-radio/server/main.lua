ESX = exports['es_extended']:getSharedObject()

-- Tabla para almacenar favoritos de jugadores
local playerFavorites = {}

-- Función para verificar si el jugador tiene radio
function HasRadioItem(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    
    local item = xPlayer.getInventoryItem(Config.ItemName)
    return item and item.count > 0
end

-- Event para verificar si el jugador tiene radio
RegisterNetEvent('simple-radio:checkRadio')
AddEventHandler('simple-radio:checkRadio', function()
    local source = source
    
    if HasRadioItem(source) then
        TriggerClientEvent('simple-radio:receiveRadio', source)
        
        -- Cargar favoritos guardados
        local identifier = GetPlayerIdentifier(source, 0)
        if playerFavorites[identifier] then
            TriggerClientEvent('simple-radio:loadFavorites', source, playerFavorites[identifier])
        end
    end
end)

-- Event para guardar favoritos
RegisterNetEvent('simple-radio:saveFavorites')
AddEventHandler('simple-radio:saveFavorites', function(favorites)
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)
    
    if identifier then
        playerFavorites[identifier] = favorites
    end
end)

-- Callback para cuando el jugador usa la radio desde el inventario
ESX.RegisterUsableItem(Config.ItemName, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        TriggerClientEvent('simple-radio:receiveRadio', source)
        
        -- Cargar favoritos guardados
        local identifier = GetPlayerIdentifier(source, 0)
        if playerFavorites[identifier] then
            TriggerClientEvent('simple-radio:loadFavorites', source, playerFavorites[identifier])
        end
        
        -- Abrir la radio
        Citizen.Wait(100)
        TriggerClientEvent('simple-radio:openRadio', source)
    end
end)

-- Event cuando el jugador se conecta
AddEventHandler('playerConnecting', function()
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)
    
    -- Aquí podrías cargar los favoritos desde una base de datos
    -- Por ahora se mantienen en memoria durante la sesión del servidor
end)

-- Event cuando el jugador se desconecta
AddEventHandler('playerDropped', function()
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)
    
    -- Los favoritos se mantienen en memoria
    -- Si quieres persistencia permanente, guárdalos en base de datos aquí
end)

-- Comando admin para dar radio (opcional)
ESX.RegisterCommand('giveradio', 'admin', function(xPlayer, args, showError)
    local targetPlayer = tonumber(args.playerId)
    
    if targetPlayer then
        local xTarget = ESX.GetPlayerFromId(targetPlayer)
        
        if xTarget then
            xTarget.addInventoryItem(Config.ItemName, 1)
            xPlayer.showNotification('Has dado una radio al jugador ' .. targetPlayer)
            xTarget.showNotification('Has recibido una radio')
        else
            showError('Jugador no encontrado')
        end
    else
        showError('ID de jugador inválido')
    end
end, false, {help = 'Dar radio a un jugador', validate = true, arguments = {
    {name = 'playerId', help = 'ID del jugador', type = 'number'}
}})

-- Exportar funciones
exports('HasRadioItem', HasRadioItem)

-- Log de inicio
print('^2[Simple Radio]^7 Recurso iniciado correctamente')
print('^2[Simple Radio]^7 Item de radio: ^3' .. Config.ItemName .. '^7')
print('^2[Simple Radio]^7 Tecla para hablar: ^3' .. Config.RadioKey .. '^7')
