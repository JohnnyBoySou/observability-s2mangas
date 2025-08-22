#!/bin/bash

# Sentry Observability Setup Script
# Este script ajuda a configurar e iniciar o ambiente Sentry

set -e

echo "🚀 Iniciando configuração do Sentry Observability para S2Mangas..."

# Verificar se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker não está rodando. Por favor, inicie o Docker primeiro."
    exit 1
fi

# Verificar se Docker Compose está disponível
if ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose não encontrado. Por favor, instale o Docker Compose."
    exit 1
fi

# Verificar se o arquivo .env existe
if [ ! -f ".env" ]; then
    echo "⚠️ Arquivo .env não encontrado. Copiando .env.example..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "✅ Arquivo .env criado. Por favor, edite-o com suas configurações antes de continuar."
        echo "📝 Lembre-se de configurar principalmente o SENTRY_SECRET_KEY."
        echo "💡 Use este comando para gerar uma chave segura:"
        echo "   python3 -c \"import secrets; print(secrets.token_urlsafe(32))\""
        exit 0
    else
        echo "❌ Arquivo .env.example não encontrado."
        exit 1
    fi
fi

# Verificar se a SENTRY_SECRET_KEY foi configurada
source .env
if [ "$SENTRY_SECRET_KEY" = "your_32_character_minimum_secret_key_here" ] || [ "$SENTRY_SECRET_KEY" = "coloque_sua_secret_key_gerada_com_32_caracteres_minimo" ]; then
    echo "⚠️ SENTRY_SECRET_KEY ainda não foi configurada."
    echo "💡 Gere uma chave segura com:"
    echo "   python3 -c \"import secrets; print(secrets.token_urlsafe(32))\""
    echo "📝 Edite o arquivo .env e configure a SENTRY_SECRET_KEY antes de continuar."
    exit 1
fi

echo "✅ Verificações de pré-requisitos concluídas."

# Parar serviços existentes se estiverem rodando
echo "🛑 Parando serviços existentes..."
docker compose down

# Construir e iniciar os serviços
echo "🔨 Iniciando serviços do Sentry..."
docker compose up -d

echo "⏳ Aguardando serviços ficarem saudáveis..."
echo "   Isso pode levar alguns minutos na primeira execução..."

# Aguardar serviços ficarem saudáveis
timeout=300
elapsed=0
while [ $elapsed -lt $timeout ]; do
    if docker compose ps --format json | jq -e '.[] | select(.State == "running") | select(.Health == "healthy" or .Health == "")' > /dev/null 2>&1; then
        healthy_services=$(docker compose ps --format json | jq -r '.[] | select(.State == "running") | select(.Health == "healthy" or .Health == "") | .Name' | wc -l)
        total_services=$(docker compose ps --format json | jq -r '.[] | .Name' | wc -l)
        
        if [ "$healthy_services" -eq "$total_services" ]; then
            echo "✅ Todos os serviços estão saudáveis!"
            break
        fi
    fi
    
    echo "   Aguardando... ($elapsed/$timeout segundos)"
    sleep 10
    elapsed=$((elapsed + 10))
done

if [ $elapsed -ge $timeout ]; then
    echo "⚠️ Timeout aguardando serviços ficarem saudáveis."
    echo "🔍 Verifique os logs com: docker compose logs"
fi

# Mostrar status dos serviços
echo ""
echo "📊 Status dos serviços:"
docker compose ps

echo ""
echo "🎉 Sentry configurado com sucesso!"
echo ""
echo "📝 Próximos passos:"
echo "   1. Acesse http://localhost:9000"
echo "   2. Crie o usuário administrador"
echo "   3. Configure sua organização"
echo "   4. Crie seu primeiro projeto"
echo ""
echo "🔍 Comandos úteis:"
echo "   Ver logs: docker compose logs -f"
echo "   Parar: docker compose down"
echo "   Reiniciar: docker compose restart"
echo ""
echo "📚 Consulte o README.md para mais informações."