from flask import Flask, request, jsonify
import requests

app = Flask(__name__)


TELEGRAM_BOT_TOKEN = 'SEU_TOKEN_AQUI'
TELEGRAM_CHAT_ID = 'SEU_CHAT_ID_AQUI'

def enviar_alerta_telegram(nivel_gas):
    mensagem = f" ALERTA DE PERIGO \nPossível vazamento de gás detectado!\nNível do Sensor: {nivel_gas}"
    url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
    payload = {
        'chat_id': TELEGRAM_CHAT_ID, 
        'text': mensagem
    }
    try:
        requests.post(url, data=payload)
    except Exception as e:
        print(f"Erro ao enviar mensagem para o Telegram: {e}")

@app.route('/alerta', methods=['POST'])
def receber_alerta():
    dados = request.get_json()
    
    if not dados or 'nivel_gas' not in dados:
        return jsonify({'erro': 'Payload inválido. Envie nivel_gas.'}), 400
    
    nivel_gas = dados['nivel_gas']
    status = dados.get('status', 'normal')
    
    if status == 'perigo':
        enviar_alerta_telegram(nivel_gas)
        print(f"ALERTA ACIONADO! Nível de gás reportado: {nivel_gas}")
        return jsonify({'mensagem': 'Alerta processado e enviado ao Telegram.'}), 200
        
    return jsonify({'mensagem': 'Nível normal, sem alertas.'}), 200

if __name__ == '__main__':
    
    app.run(host='0.0.0.0', port=5000, debug=True)