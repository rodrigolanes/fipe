# 🚗 FIPE - Consulte o Preço Médio dos Veículos

Aplicação Android desenvolvida em Flutter para consulta de preços médios de veículos com base na Tabela FIPE, integrada ao Supabase e monetizada com AdMob.

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Tecnologias](#tecnologias)
- [Arquitetura](#arquitetura)
- [Marcos e Tarefas](#marcos-e-tarefas)
- [Features Planejadas](#features-planejadas)
- [Configuração do Ambiente](#configuração-do-ambiente)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Database Schema](#database-schema)
- [CI/CD](#cicd)
- [Contribuindo](#contribuindo)

---

## 🎯 Sobre o Projeto

Aplicação mobile que permite aos usuários consultar rapidamente o preço médio de veículos (carros, motos e caminhões) utilizando os dados da Tabela FIPE armazenados no Supabase.

### Objetivo

Facilitar a consulta de preços de veículos de forma rápida, intuitiva e offline-first.

### Público-Alvo

- Compradores de veículos usados
- Vendedores autônomos
- Concessionárias
- Curiosos sobre o mercado automotivo

---

## 🛠️ Tecnologias

### Frontend

- **Flutter 3.35.6** - Framework multiplataforma
- **Dart** - Linguagem de programação
- **flutter_bloc** - Gerenciamento de estado
- **get_it** - Injeção de dependências

### Backend & Database

- **Supabase** - Backend as a Service
- **PostgreSQL** - Banco de dados relacional
- **Row Level Security (RLS)** - Segurança de dados

### Integrações

- **Google AdMob** - Monetização
- **GitHub Actions** - CI/CD automatizado
- **Google Play Store** - Distribuição

### Padrões e Princípios

- ✅ Clean Architecture
- ✅ SOLID Principles
- ✅ Repository Pattern
- ✅ Dependency Injection
- ✅ BLoC Pattern

---

## 🏗️ Arquitetura

```
lib/
├── core/                      # Núcleo da aplicação
│   ├── error/                 # Tratamento de erros
│   ├── network/               # Configuração de rede
│   ├── usecases/              # Casos de uso abstratos
│   └── utils/                 # Utilitários gerais
├── features/                  # Features modulares
│   └── consulta_fipe/
│       ├── data/              # Camada de dados
│       │   ├── datasources/   # Fontes de dados (API, Local)
│       │   ├── models/        # Models de dados
│       │   └── repositories/  # Implementação de repositórios
│       ├── domain/            # Camada de domínio
│       │   ├── entities/      # Entidades de negócio
│       │   ├── repositories/  # Contratos de repositórios
│       │   └── usecases/      # Casos de uso
│       └── presentation/      # Camada de apresentação
│           ├── bloc/          # Gerenciamento de estado
│           ├── pages/         # Telas
│           └── widgets/       # Componentes reutilizáveis
├── config/                    # Configurações
│   ├── supabase_config.dart   # Credenciais Supabase
│   └── admob_config.dart      # IDs AdMob
└── main.dart                  # Entry point
```

---

## 📊 Marcos e Tarefas

### 🏁 Marco 1: Configuração Inicial do Projeto (Semana 1)

#### Status: � Concluído

#### Tarefas:

- [x] **1.1** Inicializar projeto Flutter

  - [x] Executar `flutter create --org br.com.rodrigolanes fipe`
  - [x] Configurar package name `br.com.rodrigolanes.fipe`
  - [x] Validar estrutura inicial

- [x] **1.2** Configurar Android

  - [x] Adicionar permissão de internet no `AndroidManifest.xml`
  - [x] Configurar `build.gradle` (minSdk 21, targetSdk 34)
  - [x] Definir versionCode inicial: 1
  - [x] Definir versionName: 1.0.0

- [x] **1.3** Criar estrutura de pastas

  - [x] `lib/core/`
  - [x] `lib/features/`
  - [x] `lib/config/`
  - [x] `lib/shared/`

- [x] **1.4** Configurar Git
  - [x] Atualizar `.gitignore` para Flutter
  - [x] Criar branch: `main`
  - [x] Configurar `.copilot-instructions.md`

---

### 📦 Marco 2: Dependências e Configurações Base (Semana 1-2)

#### Status: � Concluído

#### Tarefas:

- [x] **2.1** Configurar `pubspec.yaml`

  - [x] Adicionar `supabase_flutter: ^2.9.1`
  - [x] Adicionar `flutter_bloc: ^8.1.6`
  - [x] Adicionar `get_it: ^8.0.3`
  - [x] Adicionar `equatable: ^2.0.7`
  - [x] Adicionar `google_mobile_ads: ^5.3.0`
  - [x] Adicionar `intl: ^0.20.1`
  - [x] Adicionar `cached_network_image: ^3.4.1`
  - [x] Adicionar `shimmer: ^3.0.0`
  - [x] Adicionar `dartz: ^0.10.1` (Either para tratamento de erros)
  - [x] Adicionar dev dependencies: `mockito`, `build_runner`, `bloc_test`

- [x] **2.2** Criar arquivos de configuração

  - [x] `lib/config/supabase_config.dart`
  - [x] `lib/config/admob_config.dart`
  - [x] `lib/core/constants/app_constants.dart`

- [x] **2.3** Configurar injeção de dependências

  - [x] Criar `lib/injection_container.dart`
  - [x] Configurar GetIt
  - [x] Registrar dependências singleton e factory

- [x] **2.4** Configurar temas e estilos
  - [x] Criar `lib/core/theme/app_theme.dart`
  - [x] Definir cores primárias e secundárias
  - [x] Configurar tipografia
  - [x] Criar tema dark (estrutura básica)

---

### 💾 Marco 3: Camada de Dados (Data Layer) (Semana 2-3)

#### Status: � Concluído

#### Tarefas:

- [x] **3.1** Criar Models de Dados

  - [x] `marca_model.dart` (extends MarcaEntity)
  - [x] `modelo_model.dart` (extends ModeloEntity)
  - [x] `ano_combustivel_model.dart`
  - [x] `valor_fipe_model.dart`
  - [x] Implementar `fromJson()` e `toJson()` para cada model
  - [x] Anotações Hive com TypeAdapter

- [x] **3.2** Criar DataSources

  - [x] `fipe_remote_data_source.dart` (interface abstrata)
  - [x] `fipe_remote_data_source_impl.dart` (implementação Supabase)
  - [x] `fipe_local_data_source.dart` (interface abstrata)
  - [x] `fipe_local_data_source_impl.dart` (implementação Hive)
  - [x] Métodos: `getMarcasByTipo()`, `getModelosByMarca()`, etc.
  - [x] Tratamento de erros e exceptions

- [x] **3.3** Implementar Repositories

  - [x] `fipe_repository.dart` (interface no domain)
  - [x] `fipe_repository_impl.dart` (implementação no data)
  - [x] Converter Models em Entities
  - [x] Implementar cache local com Hive

- [x] **3.4** Criar sistema de Cache Local

  - [x] Adicionar dependência `hive: ^2.2.3` e `hive_flutter: ^1.1.0`
  - [x] `fipe_local_data_source.dart` e implementação
  - [x] Estratégia de invalidação de cache (1 hora)
  - [x] Cache de marcas, modelos e valores FIPE
  - [x] Gerar arquivos TypeAdapter com build_runner

- [x] **3.5** Criar Failures e Exceptions
  - [x] `lib/core/error/failures.dart`
  - [x] `lib/core/error/exceptions.dart`
  - [x] ServerFailure, CacheFailure, NetworkFailure
  - [x] UseCase abstrato

---

### 🎯 Marco 4: Camada de Domínio (Domain Layer) (Semana 3-4)

#### Status: � Concluído

#### Tarefas:

- [x] **4.1** Criar Entities

  - [x] `marca_entity.dart`
  - [x] `modelo_entity.dart`
  - [x] `ano_combustivel_entity.dart`
  - [x] `valor_fipe_entity.dart`
  - [x] Implementar Equatable para comparação

- [x] **4.2** Definir Repository Abstracts

  - [x] `fipe_repository.dart` (contratos)
  - [x] Retornar `Either<Failure, Success>` (dartz ou similar)

- [x] **4.3** Criar Use Cases

  - [x] `get_marcas_por_tipo_usecase.dart`
  - [x] `get_modelos_por_marca_usecase.dart`
  - [x] `get_anos_combustiveis_por_modelo_usecase.dart`
  - [x] `get_valor_fipe_usecase.dart`
  - [x] Cada UseCase com single responsibility
  - [x] Params classes com equality operators

- [x] **4.4** Criar Failures e Exceptions

  - [x] `lib/core/error/failures.dart`
  - [x] `ServerFailure`, `CacheFailure`, `NetworkFailure`
  - [x] `lib/core/error/exceptions.dart`

- [x] **4.5** Atualizar Injection Container
  - [x] Registrar todos os UseCases
  - [x] Registrar Repository e DataSources
  - [x] Configurar Hive adapters

---

### 🎨 Marco 5: Camada de Apresentação (Presentation Layer) (Semana 4-6)

#### Status: � Concluído

#### Tarefas:

- [x] **5.1** Criar BLoCs/Cubits

  - [x] `marca_bloc.dart` (eventos e estados)
  - [x] `modelo_bloc.dart`
  - [x] `ano_combustivel_bloc.dart`
  - [x] `valor_fipe_bloc.dart`
  - [x] Sistema de busca integrado aos BLoCs
  - [x] Tratamento de erros e estados de loading

- [x] **5.2** Desenvolver Telas Principais

  - [x] `splash_screen.dart` (com animação)
  - [x] `home_page.dart` (seleção de tipo de veículo)
  - [x] `marca_list_page.dart` (lista com busca)
  - [x] `modelo_list_page.dart` (lista com busca)
  - [x] `ano_combustivel_page.dart` (grid)
  - [x] `valor_detalhes_page.dart` (detalhes do valor FIPE)

- [x] **5.3** Criar Widgets Reutilizáveis

  - [x] `veiculo_type_card.dart` (card de tipo de veículo)
  - [x] `marca_item_widget.dart`
  - [x] `modelo_item_widget.dart`
  - [x] `ano_combustivel_chip.dart`
  - [x] `valor_card_widget.dart`
  - [x] `loading_widget.dart` (com shimmer)
  - [x] `error_widget.dart`
  - [x] `search_bar_widget.dart`

- [x] **5.4** Implementar Navegação

  - [x] Configurar Navigator com rotas nomeadas
  - [x] AppRoutes com geração de rotas
  - [x] Passagem de argumentos entre telas
  - [x] Tratamento de rotas não encontradas

- [x] **5.5** Integrar AdMob

  - [x] AdManager para gerenciar anúncios
  - [x] AdBannerWidget widget reutilizável
  - [x] Inicialização do SDK no main
  - [x] Tratamento de erros de ads

- [x] **5.6** Atualizar Dependências
  - [x] Registrar todos os BLoCs no injection_container
  - [x] Atualizar main.dart com configurações completas
  - [x] Configurar orientação de tela
  - [x] Temas light e dark

---

### 🔍 Marco 6: Features Avançadas (Semana 6-7)

#### Status: � Em Desenvolvimento

#### Tarefas:

- [ ] **6.1** Sistema de Busca Inteligente

  - [ ] Busca por marca (com autocomplete)
  - [ ] Busca por modelo (com sugestões)
  - [ ] Histórico de buscas recentes
  - [ ] Favoritos (marca/modelo salvos localmente)

- [ ] **6.2** Gráfico de Histórico de Preços

  - [ ] Adicionar `fl_chart` ao pubspec
  - [ ] Implementar `UseCase` de histórico
  - [ ] Criar `HistoricoPrecosChart` widget
  - [ ] Exibir evolução de preços por mês

- [ ] **6.3** Comparador de Veículos

  - [ ] Selecionar múltiplos veículos
  - [ ] Comparar preços lado a lado
  - [ ] Comparar especificações
  - [ ] Exportar comparação (PDF ou imagem)

- [x] **6.4** Compartilhamento

  - [x] Compartilhar valor via WhatsApp, Telegram, etc.
  - [x] Usar `share_plus` package
  - [x] Integrar botão de compartilhar na tela de detalhes

---

### 🧪 Marco 7: Testes (Semana 7-8)

#### Status: 🔴 Não Iniciado

#### Tarefas:

- [ ] **7.1** Testes Unitários

  - [ ] Testar todos os UseCases
  - [ ] Testar Repositories
  - [ ] Testar Models (fromJson/toJson)
  - [ ] Testar BLoCs/Cubits
  - [ ] Cobertura mínima: 80%

- [ ] **7.2** Testes de Widget

  - [ ] Testar widgets customizados
  - [ ] Testar interações de UI
  - [ ] Golden tests (snapshot visual)

- [ ] **7.3** Testes de Integração

  - [ ] Fluxo completo: tipo → marca → modelo → ano → valor
  - [ ] Testar busca e filtros
  - [ ] Testar cache e offline

- [ ] **7.4** Configurar Coverage Report
  - [ ] Integrar com GitHub Actions
  - [ ] Gerar relatórios HTML
  - [ ] Badge de cobertura no README

---

### 📱 Marco 8: Preparação para Produção (Semana 8-9)

#### Status: 🔴 Não Iniciado

#### Tarefas:

- [ ] **8.1** Otimização de Performance

  - [ ] Lazy loading de listas
  - [ ] Paginação de resultados
  - [ ] Image caching
  - [ ] Debounce em buscas
  - [ ] Analisar com DevTools

- [ ] **8.2** Acessibilidade

  - [ ] Adicionar Semantic labels
  - [ ] Suporte a TalkBack/VoiceOver
  - [ ] Contraste de cores adequado
  - [ ] Tamanhos de fonte ajustáveis

- [ ] **8.3** Internacionalização (i18n)

  - [ ] Configurar `flutter_localizations`
  - [ ] Criar arquivos de tradução pt-BR
  - [ ] Suporte a en-US (opcional)
  - [ ] Formatação de moeda por locale

- [ ] **8.4** Ícone e Splash Screen

  - [ ] Criar ícone do app (1024x1024)
  - [ ] Usar `flutter_launcher_icons`
  - [ ] Criar splash screen animado
  - [ ] Adaptive icons para Android

- [ ] **8.5** Política de Privacidade e Termos
  - [ ] Criar documento de privacidade
  - [ ] Adicionar tela de "Sobre"
  - [ ] Link para política no app
  - [ ] Conformidade com LGPD

---

### 🚀 Marco 9: CI/CD e Deploy (Semana 9-10)

#### Status: 🔴 Não Iniciado

#### Tarefas:

- [ ] **9.1** Configurar Keystore

  - [ ] Gerar keystore de produção
  - [ ] Converter para base64
  - [ ] Adicionar secrets no GitHub

- [ ] **9.2** Atualizar GitHub Actions

  - [ ] Validar workflow existente
  - [ ] Adicionar step de testes
  - [ ] Configurar variáveis de ambiente
  - [ ] Testar build de release

- [ ] **9.3** Google Play Console

  - [ ] Criar conta de desenvolvedor (se necessário)
  - [ ] Configurar página da loja
  - [ ] Screenshots e descrições
  - [ ] Classificação de conteúdo

- [ ] **9.4** Primeiro Deploy

  - [ ] Deploy para Internal Testing
  - [ ] Deploy para Closed Beta
  - [ ] Coletar feedback
  - [ ] Deploy para produção

- [ ] **9.5** Monitoramento

  - [ ] Integrar Firebase Crashlytics
  - [ ] Configurar Analytics
  - [ ] Alertas de erro
  - [ ] Dashboard de métricas

- [ ] **9.6** Criar Site da Aplicação (GitHub Pages)
  - [ ] Criar estrutura de pasta `docs/`
  - [ ] Desenvolver landing page responsiva (HTML/CSS/JS)
  - [ ] Adicionar seções: recursos, screenshots, download
  - [ ] Configurar GitHub Pages no repositório
  - [ ] Criar CNAME para domínio customizado (opcional)
  - [ ] Adicionar SEO meta tags
  - [ ] Integrar Google Analytics no site

---

### 📊 Marco 10: Database Migrations & Docs (Contínuo)

#### Status: 🔴 Não Iniciado

#### Tarefas:

- [ ] **10.1** Sistema de Migrations

  - [ ] Criar `database/migrations/001_initial_schema.sql`
  - [ ] Template de migration
  - [ ] Script de versionamento
  - [ ] Documentar processo de rollback

- [ ] **10.2** Atualizar Documentação

  - [ ] Manter `database_schema.md` atualizado
  - [ ] Documentar cada alteração de banco
  - [ ] Registrar motivos de mudanças
  - [ ] Changelog de versões

- [ ] **10.3** Criar Migration Script
  - [ ] Script bash/powershell para aplicar migrations
  - [ ] Validação de ordem de execução
  - [ ] Log de migrations aplicadas
  - [ ] Integração com Supabase CLI

---

## 🌟 Features Planejadas

### 🎯 MVP (Versão 1.0)

- ✅ Consulta de preços FIPE por tipo, marca, modelo e ano
- ✅ Interface intuitiva e responsiva
- ✅ Integração com Supabase
- ✅ Banners AdMob
- ✅ Cache local para melhor UX

### 🚀 Versão 1.1

- 📊 **Gráfico de Histórico de Preços** - Visualizar variação de preço ao longo dos meses
- 🔍 **Busca Inteligente** - Autocomplete e sugestões de marcas/modelos
- ⭐ **Favoritos** - Salvar veículos favoritos para consulta rápida
- 📤 **Compartilhamento** - Compartilhar preços em redes sociais

### 🎨 Versão 1.2

- 🆚 **Comparador de Veículos** - Comparar até 3 veículos lado a lado
- 📈 **Insights de Mercado** - Maior/menor depreciação, melhores negócios
- 🎨 **Tema Dark Mode** - Alternância entre tema claro e escuro

### 🌐 Versão 2.0

- 🌍 **Modo Offline Avançado** - Cache completo de dados consultados
- 🤖 **Chat com IA** - Assistente virtual para dúvidas sobre veículos
- 📝 **Avaliações de Usuários** - Reviews e comentários sobre modelos
- 💰 **Calculadora de Financiamento** - Simular parcelas e taxas
- 📊 **Dashboard Personalizado** - Veículos seguidos e estatísticas

### 🎁 Features Premium (Opcional)

- 🚫 **Remover Anúncios** - Assinatura mensal/anual
- 📥 **Exportação de Dados** - PDF/Excel de comparações
- 📊 **Relatórios Detalhados** - Análise completa de mercado
- 🔔 **Notificações Ilimitadas** - Seguir múltiplos veículos

---

## ⚙️ Configuração do Ambiente

### Pré-requisitos

```bash
# Flutter 3.35.6 ou superior
flutter --version

# Android Studio com SDK
# Java JDK 17

# Git
git --version
```

### Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/fipe.git
cd fipe

# Instale as dependências
flutter pub get

# Configure as variáveis de ambiente
# Crie lib/config/supabase_config.dart com suas credenciais

# Execute o app
flutter run
```

### Variáveis de Ambiente

```dart
// lib/config/supabase_config.dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://frnfahrjfmnggeaccyty.supabase.co';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';
}
```

---

## 📁 Estrutura do Projeto

```
fipe/
├── .github/
│   └── workflows/
│       └── deploy-playstore.yml
├── android/                    # Configuração Android
├── database/
│   ├── docs/
│   │   └── database_schema.md
│   └── migrations/             # Scripts SQL versionados
│       ├── 001_initial_schema.sql
│       └── 002_add_favorites_table.sql
├── docs/                       # GitHub Pages - Site da aplicação
│   ├── index.html              # Landing page
│   ├── css/
│   │   └── style.css
│   ├── js/
│   │   └── main.js
│   ├── images/                 # Screenshots e assets
│   └── CNAME                   # Domínio customizado (opcional)
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── error/
│   │   ├── network/
│   │   ├── theme/
│   │   ├── usecases/
│   │   └── utils/
│   ├── features/
│   │   └── consulta_fipe/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   ├── config/
│   │   ├── supabase_config.dart
│   │   └── admob_config.dart
│   ├── injection_container.dart
│   └── main.dart
├── test/                       # Testes unitários
├── test_driver/                # Testes de integração
├── .copilot-instructions.md    # Diretrizes SOLID
├── pubspec.yaml
└── README.md
```

---

## 🗄️ Database Schema

Consulte [database/docs/database_schema.md](database/docs/database_schema.md) para informações detalhadas sobre:

- Tabelas: `marcas`, `modelos`, `anos_combustivel`, `modelos_anos`, `valores_fipe`, `tabelas_referencia`
- Relacionamentos e índices
- Row Level Security (RLS)
- Estimativas de tamanho

---

## 🔄 CI/CD

### GitHub Actions

O projeto utiliza GitHub Actions para deploy automatizado na Google Play Store.

**Trigger:**

- Push de tags `v*.*.*` (ex: `v1.0.0`)
- Execução manual

**Pipeline:**

1. Setup Flutter 3.35.6
2. Configuração do Supabase
3. Build do App Bundle (.aab)
4. Assinatura com keystore
5. Upload para Google Play Store (package: `br.com.rodrigolanes.fipe`)

**Secrets Necessários:**

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `KEYSTORE_BASE64`
- `KEYSTORE_PASSWORD`
- `KEY_PASSWORD`
- `KEY_ALIAS`
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

---

## 🤝 Contribuindo

### Fluxo de Trabalho

1. Crie uma branch a partir de `develop`: `git checkout -b feature/nova-feature`
2. Faça commit das alterações: `git commit -m 'feat: adiciona nova feature'`
3. Push para o repositório: `git push origin feature/nova-feature`
4. Abra um Pull Request para `develop`

### Commits Semânticos

```
feat: nova funcionalidade
fix: correção de bug
docs: documentação
style: formatação
refactor: refatoração de código
test: adição de testes
chore: tarefas gerais
```

### Checklist de PR

- [ ] Código segue princípios SOLID
- [ ] Testes unitários adicionados/atualizados
- [ ] Documentação atualizada
- [ ] Migration criada (se alterou banco)
- [ ] Build passa sem erros
- [ ] Lint verificado

---

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👥 Autores

- **Equipe de Desenvolvimento** - Desenvolvimento inicial

---

## 📞 Suporte

Para dúvidas ou sugestões:

- Abra uma [Issue](https://github.com/seu-usuario/fipe/issues)
- Entre em contato: contato@exemplo.com

---

## 📊 Status do Projeto

```
🔴 Em Planejamento    🟡 Em Desenvolvimento    🟢 Concluído
```

| Marco                     | Status | Progresso |
| ------------------------- | ------ | --------- |
| 1. Configuração Inicial   | �      | 100%      |
| 2. Dependências           | 🟢     | 100%      |
| 3. Camada de Dados        | 🟢     | 100%      |
| 4. Camada de Domínio      | 🟢     | 100%      |
| 5. Camada de Apresentação | 🟢     | 100%      |
| 6. Features Avançadas     | �     | 25%       |
| 7. Testes                 | 🔴     | 0%        |
| 8. Preparação Produção    | 🔴     | 0%        |
| 9. CI/CD e Deploy         | 🔴     | 0%        |
| 10. Migrations & Docs     | 🔴     | 0%        |
| 11. Site GitHub Pages     | 🔴     | 0%        |

---

**Última atualização:** 16 de dezembro de 2025
# Teste
