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
  - [x] Criar branches: `main`, `develop`
  - [x] Configurar `.copilot-instructions.md`

---

### 📦 Marco 2: Dependências e Configurações Base (Semana 1-2)

#### Status: 🔴 Não Iniciado

#### Tarefas:

- [ ] **2.1** Configurar `pubspec.yaml`

  - [ ] Adicionar `supabase_flutter: ^2.0.0`
  - [ ] Adicionar `flutter_bloc: ^8.1.3`
  - [ ] Adicionar `get_it: ^7.6.4`
  - [ ] Adicionar `equatable: ^2.0.5`
  - [ ] Adicionar `google_mobile_ads: ^4.0.0`
  - [ ] Adicionar `intl: ^0.18.1`
  - [ ] Adicionar `cached_network_image: ^3.3.0`
  - [ ] Adicionar `shimmer: ^3.0.0`

- [ ] **2.2** Criar arquivos de configuração

  - [ ] `lib/config/supabase_config.dart`
  - [ ] `lib/config/admob_config.dart`
  - [ ] `lib/core/constants/app_constants.dart`

- [ ] **2.3** Configurar injeção de dependências

  - [ ] Criar `lib/injection_container.dart`
  - [ ] Configurar GetIt
  - [ ] Registrar dependências singleton e factory

- [ ] **2.4** Configurar temas e estilos
  - [ ] Criar `lib/core/theme/app_theme.dart`
  - [ ] Definir cores primárias e secundárias
  - [ ] Configurar tipografia
  - [ ] Criar tema dark (opcional)

---

### 💾 Marco 3: Camada de Dados (Data Layer) (Semana 2-3)

#### Status: 🔴 Não Iniciado

#### Tarefas:

- [ ] **3.1** Criar Models de Dados

  - [ ] `marca_model.dart` (extends MarcaEntity)
  - [ ] `modelo_model.dart` (extends ModeloEntity)
  - [ ] `ano_combustivel_model.dart`
  - [ ] `modelo_ano_model.dart`
  - [ ] `valor_fipe_model.dart`
  - [ ] Implementar `fromJson()` e `toJson()` para cada model

- [ ] **3.2** Criar DataSources

  - [ ] `supabase_data_source.dart` (interface abstrata)
  - [ ] `supabase_data_source_impl.dart` (implementação)
  - [ ] Métodos: `getMarcasByTipo()`, `getModelosByMarca()`, etc.
  - [ ] Tratamento de erros e exceptions

- [ ] **3.3** Implementar Repositories

  - [ ] `fipe_repository.dart` (interface no domain)
  - [ ] `fipe_repository_impl.dart` (implementação no data)
  - [ ] Converter Models em Entities
  - [ ] Implementar cache local (opcional)

- [ ] **3.4** Criar sistema de Cache Local
  - [ ] Adicionar dependência `hive` ou `shared_preferences`
  - [ ] `local_data_source.dart`
  - [ ] Estratégia de invalidação de cache
  - [ ] Cache de marcas, modelos e últimas consultas

---

### 🎯 Marco 4: Camada de Domínio (Domain Layer) (Semana 3-4)

#### Status: 🔴 Não Iniciado

#### Tarefas:

- [ ] **4.1** Criar Entities

  - [ ] `marca_entity.dart`
  - [ ] `modelo_entity.dart`
  - [ ] `ano_combustivel_entity.dart`
  - [ ] `valor_fipe_entity.dart`
  - [ ] Implementar Equatable para comparação

- [ ] **4.2** Definir Repository Abstracts

  - [ ] `fipe_repository.dart` (contratos)
  - [ ] Retornar `Either<Failure, Success>` (dartz ou similar)

- [ ] **4.3** Criar Use Cases

  - [ ] `get_tipos_veiculo_usecase.dart`
  - [ ] `get_marcas_por_tipo_usecase.dart`
  - [ ] `get_modelos_por_marca_usecase.dart`
  - [ ] `get_anos_por_modelo_usecase.dart`
  - [ ] `get_valor_fipe_usecase.dart`
  - [ ] `get_historico_precos_usecase.dart`
  - [ ] Cada UseCase com single responsibility

- [ ] **4.4** Criar Failures e Exceptions
  - [ ] `lib/core/error/failures.dart`
  - [ ] `ServerFailure`, `CacheFailure`, `NetworkFailure`
  - [ ] `lib/core/error/exceptions.dart`

---

### 🎨 Marco 5: Camada de Apresentação (Presentation Layer) (Semana 4-6)

#### Status: 🔴 Não Iniciado

#### Tarefas:

- [ ] **5.1** Criar BLoCs/Cubits

  - [ ] `tipo_veiculo_cubit.dart`
  - [ ] `marca_bloc.dart` (eventos e estados)
  - [ ] `modelo_bloc.dart`
  - [ ] `ano_combustivel_bloc.dart`
  - [ ] `valor_fipe_bloc.dart`
  - [ ] `historico_bloc.dart`

- [ ] **5.2** Desenvolver Telas Principais

  - [ ] `splash_screen.dart` (com animação)
  - [ ] `home_page.dart` (seleção de tipo de veículo)
  - [ ] `marca_list_page.dart` (lista com busca)
  - [ ] `modelo_list_page.dart` (lista com busca)
  - [ ] `ano_combustivel_page.dart` (grid ou lista)
  - [ ] `valor_detalhes_page.dart` (detalhes do valor FIPE)

- [ ] **5.3** Criar Widgets Reutilizáveis

  - [ ] `veiculo_type_card.dart` (card de tipo de veículo)
  - [ ] `marca_item_widget.dart`
  - [ ] `modelo_item_widget.dart`
  - [ ] `ano_combustivel_chip.dart`
  - [ ] `valor_card_widget.dart`
  - [ ] `loading_widget.dart` (com shimmer)
  - [ ] `error_widget.dart`
  - [ ] `empty_state_widget.dart`
  - [ ] `search_bar_widget.dart`

- [ ] **5.4** Implementar Navegação

  - [ ] Configurar `GoRouter` ou Navigator 2.0
  - [ ] Rotas nomeadas
  - [ ] Animações de transição
  - [ ] Deep linking (opcional)

- [ ] **5.5** Integrar AdMob
  - [ ] Banner inferior em todas as telas (exceto splash)
  - [ ] Anúncio intersticial (opcional, após X consultas)
  - [ ] Testar com Test Ads IDs
  - [ ] Implementar tratamento de erros de ads

---

### 🔍 Marco 6: Features Avançadas (Semana 6-7)

#### Status: 🔴 Não Iniciado

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

- [ ] **6.4** Compartilhamento

  - [ ] Compartilhar valor via WhatsApp, Telegram, etc.
  - [ ] Gerar card de imagem com informações
  - [ ] Usar `share_plus` package

- [ ] **6.5** Notificações de Variação de Preço
  - [ ] Adicionar `firebase_messaging`
  - [ ] Permitir usuário "seguir" um veículo
  - [ ] Notificar quando preço mudar > 5%
  - [ ] Backend: Cloud Functions no Supabase

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
- 🔔 **Notificações** - Alertas de variação de preço

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
| 2. Dependências           | 🔴     | 0%        |
| 3. Camada de Dados        | 🔴     | 0%        |
| 4. Camada de Domínio      | 🔴     | 0%        |
| 5. Camada de Apresentação | 🔴     | 0%        |
| 6. Features Avançadas     | 🔴     | 0%        |
| 7. Testes                 | 🔴     | 0%        |
| 8. Preparação Produção    | 🔴     | 0%        |
| 9. CI/CD e Deploy         | 🔴     | 0%        |
| 10. Migrations & Docs     | 🔴     | 0%        |
| 11. Site GitHub Pages     | 🔴     | 0%        |

---

**Última atualização:** 16 de dezembro de 2025
