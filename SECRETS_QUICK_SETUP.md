# 🔑 Secrets do GitHub - Valores para Configurar

## Configuração Rápida

Acesse: **Seu Repositório > Settings > Secrets and variables > Actions > New repository secret**

---

### ✅ Secrets que Você JÁ TEM (cole estes valores):

**1. KEYSTORE_BASE64**
```
✅ JÁ ESTÁ NA SUA ÁREA DE TRANSFERÊNCIA!
Cole o valor (Ctrl+V) no GitHub
```

**2. KEY_ALIAS**
```
upload
```

---

### 📝 Secrets que Você PRECISA PREENCHER:

**3. KEYSTORE_PASSWORD**
```
[A senha que você digitou ao criar o keystore]
```

**4. KEY_PASSWORD**
```
[A mesma senha acima, se você pressionou ENTER]
```

**5. SUPABASE_URL**
```
[Obtenha em: https://supabase.com/dashboard > Seu Projeto > Settings > API > Project URL]
Exemplo: https://xxxxxxxxxxx.supabase.co
```

**6. SUPABASE_ANON_KEY**
```
[Obtenha em: https://supabase.com/dashboard > Seu Projeto > Settings > API > anon/public key]
Exemplo: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**7. GOOGLE_PLAY_SERVICE_ACCOUNT_JSON**
```
[Obtenha em: https://play.google.com/console > Setup > API access > Create/Download Service Account JSON]
Cole TODO o conteúdo do arquivo JSON, incluindo { }
```

---

## 🚀 Após Configurar Todos os Secrets

Execute o deploy:
```bash
git tag v1.0.0
git push origin v1.0.0
```

Ou vá em **Actions** e execute manualmente o workflow.

---

## ⚠️ IMPORTANTE

- Guarde suas senhas em local seguro (gerenciador de senhas)
- Faça backup do arquivo `android/app/upload-keystore.jks`
- NÃO versione o keystore nem o key.properties
