# Railway Deployment Guide for Sentry Observability

Este guia mostra como fazer deploy deste projeto Sentry no Railway.

## 🚂 Pré-requisitos para Railway

1. Conta no [Railway](https://railway.app)
2. Projeto no GitHub conectado ao Railway
3. PostgreSQL e Redis como serviços no Railway

## 📋 Passos para Deploy

### 1. Configurar Serviços no Railway

No seu projeto Railway, adicione os seguintes serviços:

1. **PostgreSQL** - Adicione como novo serviço
2. **Redis** - Adicione como novo serviço  
3. **Sentry Web** - Este repositório (será configurado automaticamente)

### 2. Configurar Variáveis de Ambiente

No serviço Sentry Web, configure as seguintes variáveis:

```bash
# Obrigatório: Gere uma chave secreta com pelo menos 32 caracteres
SENTRY_SECRET_KEY=your_generated_32_character_secret_key_here

# Database - Use as variáveis do PostgreSQL Railway
SENTRY_POSTGRES_HOST=${{Postgres.PGHOST}}
SENTRY_POSTGRES_PORT=${{Postgres.PGPORT}}
SENTRY_DB_NAME=${{Postgres.PGDATABASE}}
SENTRY_DB_USER=${{Postgres.PGUSER}}
SENTRY_DB_PASSWORD=${{Postgres.PGPASSWORD}}

# Redis - Use as variáveis do Redis Railway
SENTRY_REDIS_HOST=${{Redis.REDIS_PRIVATE_URL}}
SENTRY_REDIS_PORT=6379
SENTRY_REDIS_DB=0

# Configurações Web
SENTRY_WEB_HOST=0.0.0.0
SENTRY_WEB_PORT=$PORT
SENTRY_USE_SSL=1
SENTRY_SINGLE_ORGANIZATION=1

# Configurações de Proxy para Railway
SENTRY_SECURE_PROXY_SSL_HEADER=HTTP_X_FORWARDED_PROTO,https
SENTRY_USE_X_FORWARDED_HOST=true

# Email (Opcional)
SENTRY_EMAIL_HOST=smtp.gmail.com
SENTRY_EMAIL_PORT=587
SENTRY_EMAIL_USER=your_email@gmail.com
SENTRY_EMAIL_PASSWORD=your_app_password
SENTRY_SERVER_EMAIL=noreply@yourdomain.com
```

### 3. Deploy

1. Conecte este repositório ao Railway
2. O Railway detectará automaticamente o `Dockerfile` e fará o build
3. Configure as variáveis de ambiente conforme acima
4. Faça o deploy

### 4. Inicialização Pós-Deploy

Após o deploy, você precisa inicializar o Sentry:

1. Acesse a URL do seu aplicativo Railway
2. Siga o assistente de configuração inicial
3. Crie o usuário administrador
4. Configure sua organização

## 🔧 Configurações Adicionais

### Gerar Secret Key

Use este comando para gerar uma chave secreta:

```bash
python3 -c "import secrets; print(secrets.token_urlsafe(32))"
```

### Variáveis Específicas do Railway

O Railway fornece automaticamente:
- `$PORT` - Porta onde o aplicativo deve escutar
- `${{Postgres.PGHOST}}` - Host do PostgreSQL
- `${{Redis.REDIS_PRIVATE_URL}}` - URL do Redis

### Logs e Monitoramento

- Use `railway logs` para ver os logs
- Configure alertas no Railway para monitorar a saúde da aplicação

## 🐛 Solução de Problemas

### Build Failed no Railway

Se o build falhar:
1. Verifique se o `Dockerfile` está presente
2. Verifique os logs de build no Railway
3. Certifique-se que todas as dependências estão corretas

### Sentry não Inicia

1. Verifique se `SENTRY_SECRET_KEY` tem pelo menos 32 caracteres
2. Verifique se PostgreSQL e Redis estão configurados corretamente
3. Verifique os logs de aplicação no Railway

### Problemas de Conectividade com Banco

1. Certifique-se que as variáveis do PostgreSQL estão corretas
2. Verifique se o serviço PostgreSQL está rodando
3. Teste a conectividade usando Railway CLI

## 📚 Recursos Adicionais

- [Documentação Railway](https://docs.railway.app/)
- [Documentação Sentry Self-Hosted](https://docs.sentry.io/self-hosted/)
- [Railway Templates](https://railway.app/templates)