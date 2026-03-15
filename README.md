# Nginx para Laravel

Este projeto fornece uma imagem Docker do Nginx configurada especificamente para servir aplicações Laravel de forma eficiente e segura.

## Descrição

A configuração do Nginx inclui otimizações para aplicações Laravel, como roteamento SPA, cache de assets estáticos, headers de segurança e integração com PHP-FPM.

### Características

- **Servidor Nginx Alpine**: Imagem leve baseada em Alpine Linux
- **Configuração Laravel**: Otimizada para aplicações Laravel com roteamento SPA
- **PHP-FPM**: Integração com serviço PHP-FPM na porta 9000
- **Cache de Assets**: Cache longo para arquivos estáticos (JS, CSS, imagens)
- **Segurança**: Headers de segurança (X-Frame-Options, X-Content-Type-Options, etc.)
- **Logs**: Redirecionamento de logs para stdout/stderr do Docker

## Pré-requisitos

- Docker
- Uma aplicação Laravel com PHP-FPM

## Como Usar

### 1. Construir a Imagem

Execute o script de build:

```bash
./build
```

Ou construa manualmente:

```bash
docker build -t nginx-laravel .
```

### 2. Executar em um Docker Compose

Exemplo de `docker-compose.yml` para uma aplicação Laravel completa:

```yaml
version: '3.8'
services:
  nginx:
    image: nginx-laravel
    ports:
      - "80:80"
    volumes:
      - ./laravel-app:/var/www/html
    depends_on:
      - app
    networks:
      - laravel

  app:
    image: php:8.4-fpm-alpine
    volumes:
      - ./laravel-app:/var/www/html
    networks:
      - laravel

  db:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: laravel
      MYSQL_USER: user
      MYSQL_PASSWORD: password
      MYSQL_ROOT_PASSWORD: rootpassword
    networks:
      - laravel

networks:
  laravel:
    driver: bridge
```

### 3. Acessar a Aplicação

Após iniciar os serviços:

```bash
docker-compose up -d
```

A aplicação estará disponível em `http://localhost`.

## Configuração

### Arquivos de Configuração

- `nginx.conf`: Configuração global do Nginx
- `nginx-laravel.conf`: Configuração específica para Laravel

### Personalização

Para personalizar a configuração, monte volumes adicionais ou crie uma imagem derivada.

## Contribuição

Contribuições são bem-vindas! Abra uma issue ou envie um pull request.

## Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.
