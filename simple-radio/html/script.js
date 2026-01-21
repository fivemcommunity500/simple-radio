// Estado de la radio
let radioState = {
    isOpen: false,
    isPowered: false,
    currentFrequency: 0.0,
    volume: 50,
    favorites: [],
    isTransmitting: false,
    frequencyInput: ''
};

// Elementos del DOM
const radioContainer = document.getElementById('radio-container');
const lcdFrequency = document.getElementById('lcd-frequency');
const powerLed = document.getElementById('power-led');
const powerButton = document.getElementById('power-button');
const transmissionIndicator = document.getElementById('transmission-indicator');
const pttButton = document.getElementById('ptt-button');
const freqInputPanel = document.getElementById('freq-input-panel');
const panelDisplay = document.getElementById('panel-display');
const statusLocked = document.getElementById('status-locked');
const statusSignal = document.getElementById('status-signal');
const powerOffIndicator = document.getElementById('power-off-indicator');

// Perillas
const knobLeft = document.getElementById('knob-left');
const knobRight = document.getElementById('knob-right');

// Variables para rotación de perillas
let knobLeftRotation = 0;
let knobRightRotation = 0;

// Función auxiliar para obtener el nombre del recurso
function GetParentResourceName() {
    let resourceName = 'simple-radio';
    if (window.location.href.includes('://nui_')) {
        try {
            resourceName = window.location.hostname.split('.')[0].replace('nui_', '');
        } catch (e) {
            console.log('Using default resource name');
        }
    }
    return resourceName;
}

// Función para enviar datos a FiveM
function sendNUIMessage(action, data = {}) {
    fetch(`https://${GetParentResourceName()}/${action}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    }).catch(err => {
        console.error(`Error sending ${action}:`, err);
    });
}

// Función para actualizar frecuencia en pantalla
function updateFrequency(frequency) {
    frequency = parseFloat(frequency).toFixed(1);
    radioState.currentFrequency = parseFloat(frequency);
    lcdFrequency.textContent = frequency;
    
    // Actualizar indicador de señal
    if (frequency > 0 && radioState.isPowered) {
        statusSignal.classList.add('active');
    } else {
        statusSignal.classList.remove('active');
    }
    
    // Notificar al cliente de FiveM
    sendNUIMessage('setFrequency', { frequency: parseFloat(frequency) });
}

// Función para actualizar volumen
function updateVolume(volume) {
    volume = Math.max(0, Math.min(100, volume));
    radioState.volume = volume;
    console.log('Volumen actualizado a:', volume);
    
    // Notificar al cliente de FiveM
    sendNUIMessage('setVolume', { volume: parseInt(volume) });
}

// Función para encender/apagar radio
function togglePower() {
    radioState.isPowered = !radioState.isPowered;
    
    console.log('Toggle power:', radioState.isPowered);
    
    if (radioState.isPowered) {
        powerLed.classList.add('active');
        if (radioState.currentFrequency > 0) {
            statusSignal.classList.add('active');
        }
        // Ocultar indicador de apagada
        powerOffIndicator.classList.add('hidden');
    } else {
        powerLed.classList.remove('active');
        statusSignal.classList.remove('active');
        // Mostrar indicador de apagada
        powerOffIndicator.classList.remove('hidden');
    }
    
    // Notificar al cliente de FiveM
    sendNUIMessage('togglePower', { powered: radioState.isPowered });
}

// Event Listener - Botón de encendido central
powerButton.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();
    console.log('Power button clicked');
    togglePower();
});

// Perilla IZQUIERDA: Subir volumen
knobLeft.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();
    
    knobLeftRotation += 30;
    knobLeft.style.transform = `rotate(${knobLeftRotation}deg)`;
    
    // Aumentar volumen
    let newVolume = Math.min(100, radioState.volume + 10);
    console.log('Knob left clicked, new volume:', newVolume);
    updateVolume(newVolume);
});

// Perilla DERECHA: Encender/Apagar
knobRight.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();
    
    knobRightRotation += 30;
    knobRight.style.transform = `rotate(${knobRightRotation}deg)`;
    
    console.log('Knob right clicked, toggling power');
    togglePower();
});

// Event Listeners - Botones de función
document.getElementById('btn-menu').addEventListener('click', () => {
    // Permitir cambiar frecuencia aunque esté apagada (como radios reales)
    freqInputPanel.classList.toggle('active');
    radioState.frequencyInput = '';
    panelDisplay.textContent = '___._';
});

document.getElementById('btn-scan').addEventListener('click', () => {
    console.log('Scan function');
});

document.getElementById('btn-fav').addEventListener('click', () => {
    try {
        if (!radioState.favorites || radioState.favorites.length === 0) {
            console.log('No hay favoritos guardados');
            // En lugar de alert que puede bugear, mostrar en consola
            // O implementar un sistema de favoritos visual
        } else {
            console.log('Favoritos:', radioState.favorites);
            // Mostrar favoritos en consola en lugar de alert
            radioState.favorites.forEach((fav, index) => {
                console.log(`${index + 1}. ${fav.name || 'Favorito'}: ${fav.frequency || fav} MHz`);
            });
        }
    } catch (error) {
        console.error('Error en botón FAV:', error);
    }
});

document.getElementById('btn-vol').addEventListener('click', () => {
    // Toggle mute
    if (radioState.volume > 0) {
        radioState.lastVolume = radioState.volume;
        updateVolume(0);
    } else {
        updateVolume(radioState.lastVolume || 50);
    }
});

// Event Listeners - Teclado numérico
document.querySelectorAll('.key-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
        e.preventDefault();
        const key = btn.dataset.key;
        
        console.log('Key pressed:', key, 'Current input:', radioState.frequencyInput);
        
        if (key === '*') {
            // Borrar último dígito
            radioState.frequencyInput = radioState.frequencyInput.slice(0, -1);
        } else if (key === '#') {
            // Enter/Confirmar
            submitFrequency();
            return;
        } else {
            // Agregar dígito
            if (radioState.frequencyInput.length < 5) {
                radioState.frequencyInput += key;
            }
        }
        
        updatePanelDisplay();
    });
});

// Función para actualizar display del panel
function updatePanelDisplay() {
    let display = radioState.frequencyInput;
    
    console.log('Updating panel display:', display);
    
    // Formatear como XXX.X
    if (display.length === 0) {
        panelDisplay.textContent = '___._';
    } else if (display.length === 1) {
        panelDisplay.textContent = display + '__._';
    } else if (display.length === 2) {
        panelDisplay.textContent = display + '_._';
    } else if (display.length === 3) {
        panelDisplay.textContent = display + '._';
    } else if (display.length === 4) {
        panelDisplay.textContent = display.slice(0, 3) + '.' + display.slice(3);
    } else if (display.length === 5) {
        panelDisplay.textContent = display.slice(0, 3) + '.' + display.slice(3, 5);
    }
}

// Función para enviar frecuencia
function submitFrequency() {
    console.log('Submit frequency called, input:', radioState.frequencyInput);
    
    if (radioState.frequencyInput.length === 0) {
        alert('Ingresa una frecuencia');
        return;
    }
    
    let freq = radioState.frequencyInput;
    let formattedFreq = '';
    
    // Formatear como XXX.X
    if (freq.length === 1) {
        formattedFreq = freq + '.0';
    } else if (freq.length === 2) {
        formattedFreq = freq + '.0';
    } else if (freq.length === 3) {
        formattedFreq = freq + '.0';
    } else if (freq.length === 4) {
        formattedFreq = freq.slice(0, 3) + '.' + freq.slice(3);
    } else if (freq.length === 5) {
        formattedFreq = freq.slice(0, 3) + '.' + freq.slice(3, 5);
    }
    
    const frequency = parseFloat(formattedFreq);
    
    console.log('Formatted frequency:', formattedFreq, 'Parsed:', frequency);
    
    if (isNaN(frequency)) {
        alert('Frecuencia inválida');
        return;
    }
    
    if (frequency < 1.0 || frequency > 999.9) {
        alert('Frecuencia debe estar entre 1.0 y 999.9 MHz');
        return;
    }
    
    // Actualizar frecuencia
    updateFrequency(frequency);
    
    // Cerrar panel
    freqInputPanel.classList.remove('active');
    radioState.frequencyInput = '';
    panelDisplay.textContent = '___._';
    
    console.log('Frequency set to:', frequency);
}

// Event Listeners - Panel
document.getElementById('panel-close').addEventListener('click', () => {
    freqInputPanel.classList.remove('active');
    radioState.frequencyInput = '';
    panelDisplay.textContent = '___._';
});

document.getElementById('panel-clear').addEventListener('click', () => {
    radioState.frequencyInput = '';
    updatePanelDisplay();
});

document.getElementById('panel-enter').addEventListener('click', () => {
    submitFrequency();
});

// Event Listener - Botón PTT (visual)
pttButton.addEventListener('mousedown', () => {
    pttButton.classList.add('transmitting');
});

pttButton.addEventListener('mouseup', () => {
    pttButton.classList.remove('transmitting');
});

pttButton.addEventListener('mouseleave', () => {
    pttButton.classList.remove('transmitting');
});

// Comunicación con FiveM
window.addEventListener('message', (event) => {
    const data = event.data;
    
    console.log('Received message:', data);
    
    switch (data.action) {
        case 'open':
            radioContainer.classList.remove('hidden');
            radioState.isOpen = true;
            
            if (data.frequency !== undefined) {
                radioState.currentFrequency = parseFloat(data.frequency);
                lcdFrequency.textContent = parseFloat(data.frequency).toFixed(1);
            }
            
            if (data.volume !== undefined) {
                radioState.volume = data.volume;
            }
            
            if (data.powered !== undefined) {
                radioState.isPowered = data.powered;
                if (radioState.isPowered) {
                    powerLed.classList.add('active');
                    if (radioState.currentFrequency > 0) {
                        statusSignal.classList.add('active');
                    }
                    powerOffIndicator.classList.add('hidden');
                } else {
                    powerLed.classList.remove('active');
                    statusSignal.classList.remove('active');
                    powerOffIndicator.classList.remove('hidden');
                }
            }
            
            if (data.favorites) {
                radioState.favorites = data.favorites;
            }
            break;
            
        case 'close':
            radioContainer.classList.add('hidden');
            radioState.isOpen = false;
            freqInputPanel.classList.remove('active');
            break;
            
        case 'setTransmitting':
            radioState.isTransmitting = data.transmitting;
            if (data.transmitting) {
                transmissionIndicator.classList.add('active');
                pttButton.classList.add('transmitting');
            } else {
                transmissionIndicator.classList.remove('active');
                pttButton.classList.remove('transmitting');
            }
            break;
            
        case 'updateFrequency':
            radioState.currentFrequency = parseFloat(data.frequency);
            lcdFrequency.textContent = parseFloat(data.frequency).toFixed(1);
            if (data.frequency > 0 && radioState.isPowered) {
                statusSignal.classList.add('active');
            }
            break;
            
        case 'updateVolume':
            radioState.volume = data.volume;
            break;
            
        case 'channelRestricted':
            // Mostrar indicador de canal bloqueado
            statusLocked.classList.add('active');
            setTimeout(() => {
                statusLocked.classList.remove('active');
            }, 2000);
            break;
    }
});

// Cerrar con ESC
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && radioState.isOpen) {
        sendNUIMessage('close', {});
    }
});

// Log inicial
console.log('Simple Radio UI loaded');
