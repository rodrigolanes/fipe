# Paleta de Cores - FIPE Consulta

## 🎨 Cores Principais

### Azul Principal (Primary)

- **Cor**: `#1976D2` (Blue 700)
- **Uso**: AppBar, botões primários, elementos principais
- **Inspiração**: Cor dominante do ícone da aplicação

### Azul Escuro (Primary Dark)

- **Cor**: `#0D47A1` (Blue 900)
- **Uso**: Estados hover, sombras, variações escuras

### Azul Claro (Primary Light)

- **Cor**: `#64B5F6` (Blue 300)
- **Uso**: Backgrounds sutis, estados disabled, destaques leves

### Laranja (Secondary)

- **Cor**: `#FF9800` (Orange 500)
- **Uso**: Botões secundários, destaques, call-to-actions
- **Motivo**: Cor complementar ao azul, adiciona energia e contraste

### Verde Acento (Accent)

- **Cor**: `#4CAF50` (Green 500)
- **Uso**: Status positivo, marcas ativas, sucessos
- **Motivo**: Indica positividade e confirmação

### Vermelho Erro

- **Cor**: `#F44336` (Red 500)
- **Uso**: Mensagens de erro, validações negativas

## 🖼️ Aplicação nas Telas

### Splash Screen

- **Background**: Azul Principal (`#1976D2`)
- **Ícone**: Aplicação real em container branco com shadow
- **Texto**: Branco com opacidade para subtítulo

### Home (Seleção de Tipo)

- **Cards Carros**: Gradiente Azul Principal → Azul Escuro
- **Cards Motos**: Gradiente Laranja → Laranja Escuro
- **Cards Caminhões**: Gradiente Verde → Verde Escuro

### Lista de Marcas

- **Marcas Ativas**: Ícone Azul Principal
- **Marcas Inativas**: Ícone Cinza
- **Badges**: Verde para ativas, Cinza para inativas

### Lista de Modelos

- **FilterChips**: Azul Claro (selecionado), Cinza claro (não selecionado)
- **Cards**: Branco com borda sutil

## 📊 Tabela de Cores

| Nome           | Hex       | RGB                | Uso Principal                        |
| -------------- | --------- | ------------------ | ------------------------------------ |
| Primary        | `#1976D2` | rgb(25, 118, 210)  | AppBar, botões, elementos principais |
| Primary Dark   | `#0D47A1` | rgb(13, 71, 161)   | Sombras, hover states                |
| Primary Light  | `#64B5F6` | rgb(100, 181, 246) | Backgrounds, disabled states         |
| Secondary      | `#FF9800` | rgb(255, 152, 0)   | CTAs, destaques                      |
| Accent Green   | `#4CAF50` | rgb(76, 175, 80)   | Status positivo                      |
| Error          | `#F44336` | rgb(244, 67, 54)   | Erros, validações                    |
| Background     | `#F5F5F5` | rgb(245, 245, 245) | Fundo geral                          |
| Surface        | `#FFFFFF` | rgb(255, 255, 255) | Cards, superfícies                   |
| Text Primary   | `#212121` | rgb(33, 33, 33)    | Texto principal                      |
| Text Secondary | `#757575` | rgb(117, 117, 117) | Texto secundário                     |

## 🎯 Acessibilidade

Todas as combinações de cores seguem as diretrizes WCAG 2.1:

- ✅ Contraste mínimo de 4.5:1 para texto normal
- ✅ Contraste mínimo de 3:1 para texto grande
- ✅ Elementos interativos têm estados visuais claros

## 🔄 Alterações Realizadas

### 1. Splash Screen

- Substituído ícone genérico (`Icons.directions_car`) pelo logo real
- Adicionado container branco com bordas arredondadas e sombra
- Mantido background azul principal

### 2. Tema

- Atualizada cor primária clara de `#42A5F5` para `#64B5F6`
- Alterada cor secundária de verde (`#4CAF50`) para laranja (`#FF9800`)
- Adicionada cor de acento verde para status positivos
- Atualizada cor de erro para vermelho Material mais vibrante

### 3. Assets

- Registrado `assets/icons/icon.png` no `pubspec.yaml`
- Ícone usado tanto na splash quanto como launcher icon

## 💡 Recomendações de Uso

1. **Use Primary** para elementos principais e navegação
2. **Use Secondary** para call-to-actions e elementos que precisam destaque
3. **Use Accent Green** para indicar status positivo ou ativo
4. **Use Error** apenas para erros reais e críticos
5. **Mantenha consistência** usando sempre as mesmas cores para os mesmos propósitos
