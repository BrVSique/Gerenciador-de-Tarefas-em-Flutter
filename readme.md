# ⚡ NeonFlow Tasks

Um aplicativo de gerenciamento de tarefas diárias desenvolvido em **Flutter**, projetado com uma identidade visual **Cyber-Vibrant** e construído 100% com widgets nativos do framework — sem dependência de bibliotecas externas ou serviços de backend como o Firebase.

## 📋 Sobre o Projeto

O **NeonFlow Tasks** permite organizar a rotina diária por meio de um calendário interativo integrado a listas de tarefas específicas para cada data. O foco do desenvolvimento combina código modular, estruturas de dados eficientes em Dart e uma interface moderna de alto contraste, fugindo dos layouts tradicionais.

## ✨ Funcionalidades

- **Tela de Login e Cadastro unificada:**
  - Alternância animada entre os modos de _Login_ e _Cadastro_.

  - Validação básica de campos obrigatórios diretamente no formulário.

  - Transição suave (_fade_) para a tela principal com saudação personalizada.

- **Calendário Interativo Nativo:**
  - Navegação fluida entre meses e anos.

  - Destaque visual para o dia atual e para a data selecionada.

  - Indicadores coloridos diretamente nos dias que possuem tarefas:
    - 🟡 **Amarelo Elétrico:** existem tarefas pendentes no dia.

    - 🔵 **Ciano Neon:** todas as tarefas do dia foram concluídas.

  - Cartão de resumo rápido na parte inferior exibindo o total de tarefas pendentes e concluídas da data selecionada.

- **Lista de Tarefas Diárias:**
  - Adição de novas tarefas através de um modal (`showDialog`) estilizado.

  - Tarefas criadas sempre iniciam como **não concluídas** (`isCompleted = false`).

  - Marcação/desmarcação de tarefas como concluídas com feedback visual imediato.

  - Remoção de tarefas com um toque.

  - Painel superior com contadores em tempo real de tarefas pendentes e concluídas.

- **Ordenação Automática Inteligente:**
  - A lista é reorganizada automaticamente a cada adição, remoção ou alteração de status.

  - **Regra de ordenação:** tarefas **pendentes** aparecem sempre no topo, seguidas pelas **concluídas**, e ambos os grupos são ordenados em **ordem alfabética (A–Z)** (ignorando diferenças entre maiúsculas e minúsculas).

## 🎨 Identidade Visual (Cyber-Vibrant)

A paleta de cores foi centralizada em `lib/theme/app_theme.dart` utilizando **Material 3** em modo escuro:

| Elemento                              | Cor              | Código Hex |
| ------------------------------------- | ---------------- | ---------- |
| Fundo Principal (`bgDark`)            | Roxo Profundo    | `#0F0C20`  |
| Superfície / Cartões (`cardDark`)     | Índigo Escuro    | `#1E193B`  |
| Destaque Primário (`neonPink`)        | Rosa Neon        | `#FF2A85`  |
| Destaque Secundário (`neonCyan`)      | Ciano Neon       | `#00F0FF`  |
| Gradiente / Apoio (`neonPurple`)      | Roxo Vibrante    | `#7B2CBF`  |
| Alerta / Pendentes (`electricYellow`) | Amarelo Elétrico | `#FFBE0B`  |

## 📁 Arquitetura de Pastas

O projeto segue uma estrutura modular dentro do diretório `lib/`, separando responsabilidades entre tema, modelos, telas e componentes reutilizáveis:

```
lib/
├── main.dart                     # Ponto de entrada e configuração do MaterialApp
├── theme/
│   └── app_theme.dart            # Paleta de cores, gradientes e ThemeData global
├── models/
│   └── task_model.dart           # Modelo de dados da entidade Task
├── screens/
│   ├── auth_screen.dart          # Tela de Login e Cadastro com validação
│   ├── calendar_screen.dart      # Calendário mensal e gerenciamento por data
│   └── task_list_screen.dart     # Lista de tarefas, ordenação e contadores
└── widgets/
    └── add_task_dialog.dart      # Dialog customizado para inserção de tarefas



```

## 🛠️ Tecnologias e Estruturas Utilizadas

- **Flutter & Dart** (SDK padrão, zero pacotes de terceiros no `pubspec.yaml`).

- **Armazenamento em Memória:** `Map<String, List<Task>>` indexado por data no formato `YYYY-MM-DD`.

- **Gerenciamento de Estado:** `StatefulWidget` e `setState()`.

- **Construção de UI:** `GridView.builder` (calendário), `ListView.builder` (lista de tarefas), `Stack`, `AnimatedContainer`, `PageRouteBuilder` e `showDialog`.

- **Utilitários de Data:** `DateUtils.getDaysInMonth` e `DateUtils.isSameDay`.

## 🚀 Como Executar o Projeto

### Pré-requisitos

Certifique-se de ter o ambiente Flutter configurado em sua máquina:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão 3.0 ou superior recomendada)

- Emulador Android/iOS, dispositivo físico conectado ou navegador web (Chrome/Edge)

Para verificar se tudo está pronto, execute:

```
flutter doctor



```

### Passo a passo

1. **Crie um novo projeto Flutter** (caso ainda não tenha o repositório clonado):

   ```
   flutter create neonflow_tasks
   cd neonflow_tasks



   ```

2. **Adicione os arquivos do projeto:**
   Substitua o conteúdo da pasta `lib/` pelos arquivos listados na seção [Arquitetura de Pastas](#-arquitetura-de-pastas).

3. **Baixe as dependências padrão do projeto:**

   ```
   flutter pub get



   ```

4. **Execute o aplicativo:**

   ```
   flutter run



   ```

   > **Dica:** Para testar rapidamente no navegador, você também pode usar `flutter run -d chrome`.
