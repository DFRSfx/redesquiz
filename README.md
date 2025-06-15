
# Quiz de Redes IPv4 🚀  

<div align="center">  
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">  
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">  
  <img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite">  
</div>  

<br>  

Uma aplicação educacional desenvolvida em Flutter para aprender conceitos de endereçamento IPv4 através de quizzes interativos. No âmbito da Unidade Curricular de Programação de Dispositivos Móveis, Isla GAIA.

![Previsualização](https://media.discordapp.net/attachments/1383076662618488972/1383927279104819281/image.png?ex=68509237&is=684f40b7&hm=0c6330ee001e4df2f2f84fe394dc2b22177622e5210e1af065a0d5f8068353be&=&format=webp&quality=lossless&width=651&height=1421) 

## ✨ Funcionalidades  

- **3 Níveis de Dificuldade**  
  🟢 Básico (máscaras /8, /16, /24)  
  🟡 Intermédio (sub-redes com máscaras decimais)  
  🔴 Avançado (super-redes)  

- **Sistema de Pontuação**  
  📊 Pontos ajustados por nível (+10/-5, +20/-10, +30/-15)  
  🏆 Top 5 jogadores (armazenamento local com SQLite)  
  👤 Perfil individual  

- **Ferramentas Úteis**  
  🔄 Conversor IP ↔ prefixo  
  🔍 Verificador de rede  

- **Interface Moderna**  
  🎨 Tema escuro com gradientes  
  ✨ Animações fluidas  
  📱 Design responsivo  

## 🛠️ Tecnologias  

| Componente       | Tecnologias Utilizadas |  
|------------------|------------------------|  
| **Frontend**     | Flutter 3.0+, Dart 2.17+|  
| **Base de Dados**| SQFlite (SQLite)       |  
| **Animations**   | Flutter Animation API  |  

## 📦 Estrutura do Projeto  

```bash  
lib/  
├── database_helper.dart    # Operações com a base de dados  
├── network_quiz.dart       # Lógica de redes e geração de perguntas  
├── score_manager.dart      # Gestão de utilizadores e pontuações  
└── main.dart               # Interface principal e navegação  
```  

## 🚀 Como Executar  

1. **Pré-requisitos**:  
   - Flutter 3.0+ instalado  
   - Dispositivo Android/iOS ou emulador configurado  

2. **Instalação**:  
   ```bash  
   git clone https://github.com/DFRSfx/redesquiz.git  
   cd redesquiz  
   flutter pub get  
   ```  

3. **Execução**:  
   ```bash  
   flutter run  
   ```  

## 📸 Capturas de Ecrã  

| Ecrã Inicial | Quiz | Ferramentas |  
|--------------|------|-------------|  
| ![Ecrã Inicial](https://media.discordapp.net/attachments/1383076662618488972/1383927279104819281/image.png?ex=68509237&is=684f40b7&hm=0c6330ee001e4df2f2f84fe394dc2b22177622e5210e1af065a0d5f8068353be&=&format=webp&quality=lossless&width=651&height=1421) | ![Quiz](https://media.discordapp.net/attachments/1383076662618488972/1383929268354154496/image.png?ex=68509411&is=684f4291&hm=e0aaed725c0c966d8a215b5a7ae3c040fd9bf72ac6f15db8aae78fa943c37274&=&format=webp&quality=lossless&width=663&height=1421) | ![Ferramentas](https://media.discordapp.net/attachments/1383076662618488972/1383929809390014725/image.png?ex=68509492&is=684f4312&hm=6bd29988bb33540464605fa4bf192c4897000a2f84eb102bb0d35fca17374768&=&format=webp&quality=lossless&width=654&height=1421) |  



## 📄 Licença  

Distribuído sob a licença MIT. Consulte o ficheiro `LICENSE` para mais informações.  


