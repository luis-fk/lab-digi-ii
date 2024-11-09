import React, { useState } from 'react';
import { View, Alert, Text, TextInput, Button, TouchableOpacity, ScrollView, 
         StyleSheet, KeyboardAvoidingView, Platform, TouchableWithoutFeedback, Keyboard } from 'react-native';

const App = () => {
  const [wifiSsid, setWifiSsid] = useState('');
  const [wifiPassword, setWifiPassword] = useState('');
  const [minimumWeight, setMinimumWeight] = useState('');
  const [maximumWeight, setMaximumWeight] = useState('');
  const [esp32Ip, setEsp32Ip] = useState('192.168.4.1');
  const [doorStatus, setDoorStatus] = useState(0);

  const handleSubmitWiFi = async () => {
    try {
      const response = await fetch(`http://${esp32Ip}/receive-wifi`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          wifiSsid,
          wifiPassword,
        }),
      });

      const result = await response.json();

      if (response.ok && result.status === 'connected') {
        setWifiSsid('');
        setWifiPassword('');
        setEsp32Ip(result.ip); 
        Alert.alert('Sucesso', 'Credenciais da Wi-Fi enviadas com sucesso!');
      } else {
        Alert.alert('Erro', 'Falha ao enviar credenciais da Wi-Fi.');
      }
    } catch (error) {
      return;
    }
  };


  const handleSubmitScaleData = async () => {
    if(minimumWeight === '' || maximumWeight === '') {
      Alert.alert('Erro', 'Ambos os campos são obrigatórios.');
      return;
    }

    const sanitizedMinWeight = parseFloat(minimumWeight.replace(/[,]/g, '.')) * 1000;
    const sanitizedMaxWeight = parseFloat(maximumWeight.replace(/[,]/g, '.')) * 1000;

    if(sanitizedMaxWeight < sanitizedMinWeight) {
      Alert.alert('Erro', 'O peso mínimo deve ser menor que o peso máximo.');
      return;
    }

    if(sanitizedMaxWeight >= 10000 || sanitizedMinWeight < 500) {
      Alert.alert('Erro', 'O peso máximo e mínimo permitidos são de 10 Kg e 0.5 Kg.');
      return;
    }

    try {
      const response = await fetch(`http://${esp32Ip}/send-scale-data`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          minimumWeight: sanitizedMinWeight.toString(),
          maximumWeight: sanitizedMaxWeight.toString(),
        }),
      });

      if (response.ok) {
        setMinimumWeight('');
        setMaximumWeight('');
        Alert.alert('Sucesso', 'Dados da balança enviados com sucesso!');
      } else {
        Alert.alert('Erro', 'Falha ao enviar dados da balança.');
      }
    } catch (error) {
      Alert.alert('Erro', 'Falha ao enviar dados da balança.');
    }
  };

  const handleOpenDoor = async () => {
    // setEsp32Ip('192.168.43.56');
    // console.log(esp32Ip);
    // return;

    try {
      const response = await fetch(`http://${esp32Ip}/open-door`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          doorStatus,
        }),
      });

      if (response.ok) {
        doorStatus ? setDoorStatus(0) : setDoorStatus(1);
      } else {
        Alert.alert('Erro', 'Falha ao abrir a porta.');
      }
    } catch (error) {
      Alert.alert('Erro', 'Falha ao abrir a porta.');
    }
  };

  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <TouchableWithoutFeedback onPress={Keyboard.dismiss}>
        <ScrollView contentContainerStyle={styles.scrollContainer}>
          <View style={styles.section}>
            <Text style={styles.title}>Informações da balança:</Text>

            <TextInput
              style={styles.input}
              placeholder="Peso mínimo (Kg)"
              placeholderTextColor="#ccc"
              value={minimumWeight}
              onChangeText={setMinimumWeight}
              keyboardType="numeric"
            />

            <TextInput
              style={styles.input}
              placeholder="Peso máximo (Kg)"
              placeholderTextColor="#ccc"
              value={maximumWeight}
              onChangeText={setMaximumWeight}
              keyboardType="numeric"
            />

            <Button title="Enviar dados da balança" onPress={handleSubmitScaleData} />
          </View>

          <View style={styles.section}>
            <Text style={styles.title}>Informações da wifi:</Text>

            <TextInput
              style={styles.input}
              placeholder="Nome da Wi-Fi"
              placeholderTextColor="#ccc"
              value={wifiSsid}
              onChangeText={setWifiSsid}
            />

            <TextInput
              style={styles.input}
              placeholder="Senha do Wi-Fi"
              placeholderTextColor="#ccc"
              secureTextEntry={true}
              value={wifiPassword}
              onChangeText={setWifiPassword}
            />
            <Button title="Enviar dados do Wi-Fi" onPress={handleSubmitWiFi} />
          </View>

          <View style={{ padding: 20 }}>
            <TouchableOpacity
              style={[styles.button, doorStatus ? styles.opened : styles.closed]}
              onPress={handleOpenDoor}
            >
              <Text style={styles.buttonText}>{doorStatus ? 'Fechar Porta' : 'Abrir Porta'}</Text>
            </TouchableOpacity>
          </View>
        </ScrollView>
      </TouchableWithoutFeedback>
    </KeyboardAvoidingView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  scrollContainer: {
    flexGrow: 1,
    justifyContent: 'center',
    padding: 20,
    gap: 20,
  },
  section: {
    marginBottom: 20,
    marginTop: 30,
  },
  button: {
    paddingVertical: 12,
    paddingHorizontal: 20,
    borderRadius: 8,
    alignItems: 'center',
  },
  opened: {
    backgroundColor: '#FF3B30',
  },
  closed: {
    backgroundColor: '#4CD964',
  },
  buttonText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: 'bold',
  },
  label: {
    fontSize: 16,
    color: 'white',
    marginBottom: 5,
  },
  input: {
    height: 50,
    borderColor: '#ccc',
    color: 'white',
    borderWidth: 1,
    marginBottom: 15,
    paddingHorizontal: 10,
    borderRadius: 5,
    backgroundColor: '#333',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 20,
    color: 'white',
  },
});

export default App;
