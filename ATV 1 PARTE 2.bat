# Define o intervalo de tempo para verificar a rede (em segundos)
$IntervaloVerificacao = 60

# Função para verificar a conectividade de um dispositivo e registrar em um log
function VerificarConectividade {
    param(
        [string]$Dispositivo,
        [int[]]$Portas
    )

    foreach ($Porta in $Portas) {
        $EndPoint = "$Dispositivo:$Porta"
        $TCPClient = New-Object System.Net.Sockets.TcpClient
        $Connection = $TCPClient.BeginConnect($Dispositivo, $Porta, $null, $null)
        $Connection.AsyncWaitHandle.WaitOne(1000, $false)

        if ($TCPClient.Connected) {
            $Status = "ABERTA"
        } else {
            $Status = "FECHADA"
        }

        $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $LogEntry = "$TimeStamp - Porta $Porta no dispositivo $Dispositivo está $Status."

        # Adiciona a entrada ao arquivo de log
        Add-Content -Path "log_momentaneo.txt" -Value $LogEntry

        # Exibe o status na tela
        Write-Host $LogEntry

        $TCPClient.Close()
    }
}

# Loop para verificar a conectividade dos dispositivos e portas a cada intervalo
while ($true) {
    Clear-Host
    Write-Host "Verificando conectividade das portas nos dispositivos..."
    VerificarConectividade -Dispositivo "192.168.1.1" -Portas @(80, 443)  # Exemplo: Endereço IP do roteador
    VerificarConectividade -Dispositivo "192.168.1.100" -Portas @(3389)   # Exemplo: Endereço IP de um computador na rede
    # Adicione mais dispositivos e portas conforme necessário

    # Aguarda o intervalo de tempo antes de verificar novamente
    Start-Sleep -Seconds $IntervaloVerificacao
}
