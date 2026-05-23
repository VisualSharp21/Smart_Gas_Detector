# Smart_Gas_Detector
Sistema inteligente de monitoramento e detecção de vazamento de gás com ESP32, Firebase e alertas no Telegram.

disciplina de projetos de engenharia I feito pela equipe vigilante do fogão com objetivo de garantir segurança preventiva contra acidentes domésticos, permitindo o monitoramento em tempo real dos níveis de gás inflamável no ambiente e enviando notificações críticas diretamente para o smartphone do usuário.

O sistema foi desenvolvido utilizando uma arquitetura que integra hardware, backend e banco de dados em tempo real:
Microcontrolador:ESP32 programado em C/C++
Sensor: Módulo MQ-5 (Sensível a Gás Natural e GLP)
Backend: Servidor Python (Flask) para gestão de eventos
Integrações:
  Firebase: Armazenamento dos dados de leitura do sensor em tempo real.
  Telegram Bot API: Disparo automático de mensagens de alerta em caso de risco.
Mobile (Frontend): Aplicativo construído em Flutter (Dart) para visualização dos níveis do sensor.

1. O sensor MQ-5 realiza leituras constantes do ambiente físico via ESP32.
2. Os dados analógicos são convertidos e enviados ao Firebase via Wi-Fi.
3. Caso o nível de gás ultrapasse o limite de segurança configurado, um evento de emergência é acionado no backend.
4. O usuário recebe imediatamente uma notificação de perigo no Telegram através do Bot integrado.

