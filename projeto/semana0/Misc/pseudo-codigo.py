# Variáveis de configuração
peso_minimo = 3.0
peso_maximo = 5.0  

# Função que verifica o peso na balança e abre ou fecha o compartimento de comida
def main():
    while True:
        peso_atual = lerPesoDaBalanca()
        
        if peso_atual == 0:
            fecharCompartimento() # Não há nada na balança
        elif peso_atual >= peso_minimo and peso_atual <= peso_maximo:
            abrirCompartimento() # Gato magro está na balança
        else:
            fecharCompartimento() # Gato acima do peso está na balança

def fecharCompartimento():
    return

def abrirCompartimento():
    return

def lerPesoDaBalanca():
    return