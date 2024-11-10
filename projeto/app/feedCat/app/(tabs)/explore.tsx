import Ionicons from '@expo/vector-icons/Ionicons';
import { StyleSheet } from 'react-native';
import { Collapsible } from '@/components/Collapsible';
import ParallaxScrollView from '@/components/ParallaxScrollView';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';

export default function TabTwoScreen() {
  return (
    <ParallaxScrollView
      headerBackgroundColor={{ light: '#D0D0D0', dark: '#353636' }}
      headerImage={<Ionicons size={310} name="help-circle-outline" style={styles.headerImage} />}>
      <ThemedView style={styles.titleContainer}>
        <ThemedText type="title">Informações</ThemedText>
      </ThemedView>
      <ThemedText>Aqui você encontra todas as informações de uso do aplicativo Feed Cat.</ThemedText>
      <Collapsible title="Configuração da Wifi">
        <ThemedText>
          Ao conectar o dispositivo na tomada, uma rede wifi chamada Feed Cat aparecera na lista de Wi-Fis do 
          seu dispositivo, cuja senha é 12345678.{"\n\n"}
          
          Basta conectar a essa rede e usar os campos de envio de nome da Wi-Fi e a sua senha e
          clicar no botão de enviar dados do Wi-Fi. Isso deverá ser feito toda vez que você desconectar
          o dispositivo da tomada.
        </ThemedText>
      </Collapsible>
      <Collapsible title="Configurando a balança">
        <ThemedText>
          Para configurar a balança, basta usar os campos de envio de peso minimo e peso maximo e
          clicar no botão de enviar dados do peso. Os pesos mínimos e máximos padrão são 1 Kg para o peso
          mínimo e 2 Kg para o peso máximo. {"\n\n"}
          
          A balança aceita valores entre 0,5 Kg e 9,9 Kg. A precisão é de 0,1 Kg, ou seja para um valor de 4,47 Kg,
          o que será enviado a balança será o valor 4,4 Kg.
        </ThemedText>
      </Collapsible>
      <Collapsible title="Abertura e fechamento da balança">
        <ThemedText>
          Para abastecer o compartimento de comida, você pode abrir ou fechar o compartimento através
          do botão correspondente no menu principal. Só não esqueça de fechar a porta após de terminar 
          o abastecimento.
        </ThemedText>
      </Collapsible>
      <Collapsible title="Funcionamento do dispositivo">
        <ThemedText>
          O dispositivo Feed Cat funciona através de uma balança e um pequeno motor elétrico. A balança pode
          ser configurada com valores de peso mínimo e máximo. Pra exemplificarmos, vamos supor que você configurou
          a balança para o peso mínimo de 1,5 Kg e 3,0 Kg. {"\n\n"} 
          
          Com a balança configurada, o dispositivo então é capaz de detectar qual dos seus pets está em cima da balança.
          Se o pet que estiver em cima da balança pesar entre 1,5 Kg e 3,0 Kg, o dispositivo vai abrir a porta da balança, 
          caso contrário, ele vai manter a porta fechada.

          A abertura da pora pode levar até 2 segundos, isso é para garantirmos que o pet certo está em cima da balança.
        </ThemedText>
      </Collapsible>
    </ParallaxScrollView>
  );
}

const styles = StyleSheet.create({
  headerImage: {
    color: '#808080',
    bottom: -90,
    left: -35,
    position: 'absolute',
  },
  titleContainer: {
    flexDirection: 'row',
    gap: 8,
  },
});
