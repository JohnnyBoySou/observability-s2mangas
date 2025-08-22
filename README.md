# Observability S2Mangas - Sentry Configuration

Este repositório contém a configuração do Sentry para monitoramento e observabilidade do projeto S2Mangas.

## 🚀 Sobre o Sentry

O Sentry é uma plataforma de monitoramento de erros que ajuda desenvolvedores a identificar, corrigir e otimizar o desempenho de suas aplicações em tempo real.

## 📋 Pré-requisitos

- Docker Engine 20.10+
- Docker Compose v2.0+
- Pelo menos 4GB de RAM disponível
- Pelo menos 10GB de espaço em disco

## ⚙️ Configuração

### 1. Clone o repositório

```bash
git clone https://github.com/JohnnyBoySou/observability-s2mangas.git
cd observability-s2mangas
```

### 2. Configure as variáveis de ambiente

Edite o arquivo `.env` e configure as seguintes variáveis:

```bash
# Gere uma chave secreta com pelo menos 32 caracteres
SENTRY_SECRET_KEY=sua_chave_secreta_de_32_caracteres_minimo

# Configuração de email para notificações
SENTRY_EMAIL_HOST=smtp.seudominio.com
SENTRY_EMAIL_PORT=587
SENTRY_EMAIL_USER=usuario_email
SENTRY_EMAIL_PASSWORD=senha_email
SENTRY_SERVER_EMAIL=seu_email@dominio.com
```

**⚠️ Importante:** Para gerar uma chave secreta segura, você pode usar:

```bash
python3 -c "import secrets; print(secrets.token_urlsafe(32))"
```

### 3. Inicie os serviços

```bash
docker compose up -d
```

### 4. Aguarde a inicialização

Os serviços podem levar alguns minutos para inicializar completamente. Você pode acompanhar o status com:

```bash
docker compose ps
docker compose logs -f sentry-web
```

### 5. Configure o Sentry

Acesse `http://localhost:9000` e:

1. Crie o usuário administrador
2. Configure sua organização
3. Crie seu primeiro projeto

## 🏗️ Arquitetura

O ambiente é composto por:

- **sentry-web**: Interface web do Sentry (porta 9000)
- **sentry-worker**: Processamento de tarefas em background
- **sentry-cron**: Tarefas agendadas e limpeza
- **postgres**: Banco de dados principal (porta 5432)
- **redis**: Cache e filas de mensagens (porta 6379)

## 🔍 Monitoramento

### Verificar saúde dos serviços

```bash
docker compose ps
```

### Ver logs dos serviços

```bash
# Logs de todos os serviços
docker compose logs

# Logs específicos do Sentry web
docker compose logs sentry-web

# Logs em tempo real
docker compose logs -f
```

### Health Checks

Todos os serviços possuem health checks configurados:

- **PostgreSQL**: Verifica conectividade com `pg_isready`
- **Redis**: Verifica conectividade com `redis-cli ping`
- **Sentry Web**: Verifica API endpoint `/api/0/`
- **Sentry Worker/Cron**: Verifica execução básica

## 🛠️ Comandos Úteis

### Parar os serviços

```bash
docker compose down
```

### Parar e remover volumes (⚠️ apaga dados)

```bash
docker compose down -v
```

### Atualizar configurações

```bash
docker compose down
docker compose up -d
```

### Backup do banco de dados

```bash
docker compose exec postgres pg_dump -U sentry sentry > backup_sentry.sql
```

### Restaurar backup

```bash
docker compose exec -T postgres psql -U sentry sentry < backup_sentry.sql
```

## 🔧 Configurações Avançadas

### Configuração de Proxy Reverso

Para usar com nginx ou outro proxy reverso, adicione no `.env`:

```bash
SENTRY_SECURE_PROXY_SSL_HEADER=HTTP_X_FORWARDED_PROTO,https
SENTRY_USE_X_FORWARDED_HOST=true
```

### Configuração de SSL

Para habilitar SSL, modifique no `.env`:

```bash
SENTRY_USE_SSL=1
```

### Configuração de Rate Limiting

Para configurar rate limiting com Redis, adicione no `.env`:

```bash
SENTRY_RATELIMITER=sentry.ratelimits.redis.RedisRateLimiter
SENTRY_RATELIMITER_OPTIONS={"hosts": {"default": {"host": "redis", "port": 6379, "db": 1}}}
```

## 🐛 Solução de Problemas

### Sentry não inicia

1. Verifique se as portas 9000, 5432 e 6379 estão disponíveis
2. Verifique os logs: `docker compose logs sentry-web`
3. Verifique se o PostgreSQL e Redis estão saudáveis

### Erro de chave secreta

Certifique-se que `SENTRY_SECRET_KEY` tem pelo menos 32 caracteres.

### Problemas de memória

O Sentry requer pelo menos 4GB de RAM. Configure mais memória para o Docker se necessário.

### Limpeza de dados antigos

O Sentry possui limpeza automática via sentry-cron, mas você pode executar manualmente:

```bash
docker compose exec sentry-web sentry cleanup --days=30
```

## 📚 Documentação Adicional

- [Documentação oficial do Sentry](https://docs.sentry.io/)
- [Sentry Self-Hosted](https://docs.sentry.io/platforms/python/guides/django/configuration/self-hosted/)
- [Docker Compose para Sentry](https://docs.sentry.io/platforms/python/guides/django/configuration/self-hosted/#docker)

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.