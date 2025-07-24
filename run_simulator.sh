#!/bin/bash

# Script para compilar y ejecutar CBREdgeDash en el simulador Connect IQ

echo "🔨 Compilando CBREdgeDash..."
monkeyc -f monkey.jungle -d edge1040 -o bin/CBREdgeDash.prg -y ./developer_key.der

if [ $? -eq 0 ]; then
    echo "✅ Compilación exitosa"
    echo "🚀 Iniciando simulador..."
    
    # Verificar si el simulador ya está ejecutándose
    if pgrep -f "simulator" > /dev/null; then
        echo "📱 Simulador detectado ejecutándose. Reiniciando..."
        # Terminar el proceso del simulador
        pkill -f "simulator"
        echo "⏳ Esperando a que el simulador se cierre..."
        sleep 3
    fi
    
    echo "📱 Iniciando Connect IQ Simulator..."
    # Intentar abrir el simulador (puede variar según la instalación)
    if command -v connectiq &> /dev/null; then
        connectiq &
    elif [ -d "/Applications/Connect IQ Simulator.app" ]; then
        open "/Applications/Connect IQ Simulator.app" &
    else
        echo "⚠️  Simulador no encontrado automáticamente. Ábrelo manualmente."
    fi
    
    echo "⏳ Esperando a que el simulador se inicie..."
    sleep 5
    
    echo "🎮 Ejecutando aplicación en Edge 1040"
    monkeydo bin/CBREdgeDash.prg edge1040
    
else
    echo "❌ Error en la compilación"
    exit 1
fi
