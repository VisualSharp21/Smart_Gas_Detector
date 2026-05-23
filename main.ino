#include <WiFi.h>
#include <HTTPClient.h>

// Configurações da Rede Wi-Fi
const char* ssid = "NOME_DA_SUA_REDE";
const char* password = "SENHA_DA_REDE";

// Configurações do Sensor MQ-5
const int mq5Pin = 34; // Pino analógico do ESP32
int limiteGas = 2000;  // Valor de calibração para disparo do alerta (ajuste conforme necessário)

// URL do seu Backend (Flask) ou Endpoint do Firebase
const String serverName = "http://SEU_IP_OU_DOMINIO/alerta";

void setup() {
  Serial.begin(115200);
  pinMode(mq5Pin, INPUT);

  // Conectando ao Wi-Fi
  WiFi.begin(ssid, password);
  Serial.print("Conectando ao Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println(" Conectado!");
}

void loop() {
  int valorGas = analogRead(mq5Pin);
  Serial.print("Nível de Gás detectado: ");
  Serial.println(valorGas);

  // Lógica de Alerta
  if (valorGas > limiteGas) {
    Serial.println("ALERTA: Vazamento de gás detectado!");
    enviarAlerta(valorGas);
    delay(10000); // Aguarda 10 segundos antes de enviar novo alerta (evita spam no Telegram)
  }

  delay(2000); // Intervalo de leitura
}

void enviarAlerta(int nivelGas) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(serverName);
    http.addHeader("Content-Type", "application/json");

    // Monta o payload JSON com os dados do sensor
    String payload = "{\"nivel_gas\":" + String(nivelGas) + ", \"status\":\"perigo\"}";
    
    int httpResponseCode = http.POST(payload);
    
    if (httpResponseCode > 0) {
      Serial.print("Alerta enviado com sucesso. Código HTTP: ");
      Serial.println(httpResponseCode);
    } else {
      Serial.print("Erro ao enviar alerta. Código: ");
      Serial.println(httpResponseCode);
    }
    http.end();
  } else {
    Serial.println("Erro na conexão Wi-Fi");
  }
}