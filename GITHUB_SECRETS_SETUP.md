# Configuração dos Secrets do GitHub

Este documento explica como configurar os secrets necessários para o deploy automático na Google Play Store.

## 📋 Secrets Necessários

Você precisa configurar **6 secrets** no repositório GitHub:

### 1. **SUPABASE_URL**
- **Descrição**: URL do seu projeto Supabase
- **Formato**: `https://xxxxxxxxxxx.supabase.co`
- **Como obter**:
  1. Acesse https://supabase.com/dashboard
  2. Selecione seu projeto
  3. Vá em Settings > API
  4. Copie o valor de "Project URL"

### 2. **SUPABASE_ANON_KEY**
- **Descrição**: Chave anônima pública do Supabase
- **Formato**: String longa começando com `eyJ...`
- **Como obter**:
  1. No mesmo local (Settings > API)
  2. Copie o valor de "anon/public" key

### 3. **KEYSTORE_BASE64**
- **Descrição**: Arquivo keystore codificado em base64
- **Como gerar**:
  
  **No PowerShell (Windows):**
  ```powershell
  $fileContent = [System.IO.File]::ReadAllBytes("C:\Users\rodrigo\projetos\fipe\android\app\upload-keystore.jks")
  $base64String = [System.Convert]::ToBase64String($fileContent)
  $base64String | Set-Clipboard
  Write-Host "Base64 copiado para área de transferência!"
  ```
  
  **No Linux/Mac:**
  ```bash
  base64 android/app/upload-keystore.jks | tr -d '\n' | pbcopy  # Mac
  base64 android/app/upload-keystore.jks | tr -d '\n' | xclip   # Linux
  ```

### 4. **KEYSTORE_PASSWORD**
- **Descrição**: Senha do keystore
- **Valor**: A senha que você definiu ao criar o keystore
- **⚠️ Importante**: Esta é a "senha da área de armazenamento de chaves" que você digitou

### 5. **KEY_PASSWORD**
- **Descrição**: Senha da chave de assinatura
- **Valor**: Se você pressionou ENTER quando perguntado, é a mesma senha do keystore
- **⚠️ Importante**: Caso contrário, use a senha específica da chave

### 6. **KEY_ALIAS**
- **Descrição**: Alias da chave de assinatura
- **Valor**: `upload`
- **ℹ️ Info**: Este é o alias que usamos ao criar o keystore

### 7. **GOOGLE_PLAY_SERVICE_ACCOUNT_JSON**
- **Descrição**: Credenciais da conta de serviço do Google Play
- **Como obter**:
  
  1. Acesse https://play.google.com/console
  2. Selecione seu app
  3. Vá em "Setup" > "API access"
  4. Crie uma conta de serviço ou use uma existente
  5. Baixe o arquivo JSON
  6. Copie TODO o conteúdo do arquivo JSON (incluindo as chaves `{}`)

## 🔧 Como Adicionar os Secrets no GitHub

1. Vá para o repositório no GitHub
2. Clique em **Settings**
3. No menu lateral, clique em **Secrets and variables** > **Actions**
4. Clique em **New repository secret**
5. Para cada secret:
   - Digite o **Nome** (exatamente como listado acima)
   - Cole o **Valor** correspondente
   - Clique em **Add secret**

## ✅ Checklist de Configuração

- [ ] SUPABASE_URL configurada
- [ ] SUPABASE_ANON_KEY configurada
- [ ] KEYSTORE_BASE64 configurada
- [ ] KEYSTORE_PASSWORD configurada
- [ ] KEY_PASSWORD configurada
- [ ] KEY_ALIAS configurada (valor: `upload`)
- [ ] GOOGLE_PLAY_SERVICE_ACCOUNT_JSON configurada

## 🚀 Como Fazer um Deploy

### Opção 1: Criar uma Tag (Recomendado)
```bash
git tag v1.0.0
git push origin v1.0.0
```

### Opção 2: Executar Manualmente
1. Vá em **Actions** no repositório
2. Selecione o workflow "Deploy to Google Play Store"
3. Clique em **Run workflow**
4. Selecione a branch
5. Clique em **Run workflow**

## 📝 Notas Importantes

- **NÃO** versione o arquivo `android/key.properties` (já está no .gitignore)
- **NÃO** versione o arquivo `upload-keystore.jks` (já está no .gitignore)
- **Faça backup** do keystore em local seguro
- **Guarde as senhas** em local seguro (gerenciador de senhas)
- O workflow cria automaticamente o `supabase_config.dart` usando os secrets

## 🔒 Segurança

- Todos os secrets são criptografados pelo GitHub
- Nunca são expostos nos logs
- Apenas o repositório tem acesso
- Podem ser atualizados a qualquer momento em Settings > Secrets

## 🆘 Troubleshooting

### Erro "SUPABASE_URL está vazia"
- Verifique se o secret foi configurado corretamente no GitHub
- Certifique-se de usar o nome exato: `SUPABASE_URL`

### Erro "Failed to decode keystore"
- O KEYSTORE_BASE64 pode estar corrompido
- Tente gerar novamente o base64 do arquivo .jks
- Certifique-se de não ter espaços ou quebras de linha

### Erro "Incorrect keystore password"
- Verifique se KEYSTORE_PASSWORD está correto
- Verifique se KEY_PASSWORD está correto
- São as senhas que você digitou ao criar o keystore

## 📚 Referências

- [Google Play Deploy Action](https://github.com/r0adkll/upload-google-play)
- [Signing Android Apps](https://developer.android.com/studio/publish/app-signing)
- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
