# Define o intervalo de tempo para verificar a rede (em segundos)
$IntervaloVerificacao = 60

# Função para verificar a conectividade de um dispositivo e registrar em um log
function VerificarConectividade {
    param(
        [string]$Dispositivo
    )
    $Ping = Test-Connection -ComputerName $Dispositivo -Count 1 -Quiet
    $Status = if ($Ping) { "ONLINE" } else { "OFFLINE" }
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$TimeStamp - $Dispositivo está $Status."

    # Adiciona a entrada ao arquivo de log
    Add-Content -Path "log_momentaneo.txt" -Value $LogEntry

    # Exibe o status na tela
    Write-Host $LogEntry
}

# Loop para verificar a conectividade dos dispositivos a cada intervalo
while ($true) {
    Clear-Host
    Write-Host "Verificando conectividade dos dispositivos..."
    VerificarConectividade -Dispositivo "192.168.1.1"  # Exemplo: Endereço IP do roteador
    VerificarConectividade -Dispositivo "192.168.1.100"  # Exemplo: Endereço IP de um computador na rede
    # Adicione mais dispositivos conforme necessário

    # Aguarda o intervalo de tempo antes de verificar novamente
    Start-Sleep -Seconds $IntervaloVerificacao
}
