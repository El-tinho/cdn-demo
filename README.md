Projeto de demonstracao de CDN para a disciplina de Sistemas Distribuidos.

## Topologia

```
Cliente (Chrome) --> MikroTik --> Ubuntu Server
                                      |
                               Docker Compose
                               |             |
                           Origem          CDN
                        (172.20.0.10)  (172.20.0.20)
```

## Estrutura

```
cdn-demo/
├── docker-compose.yml
├── origem/
│   ├── index.html
│   └── nginx.conf
└── cdn/
    └── nginx.conf
```

## Como executar

### 1. Subir os containers
```bash
docker compose up -d
```

### 2. Verificar se estao rodando
```bash
docker ps
```

### 3. Aplicar latencia artificial na origem
```bash
docker exec origem tc qdisc add dev eth0 root netem delay 200ms
```

### 4. Testar acesso direto a origem
```bash
curl -o /dev/null -s -w "TTFB: %{time_starttransfer}s\n" http://localhost:8081
```

### 5. Testar acesso via CDN
```bash
# Primeiro acesso (MISS)
curl -I http://localhost:8080

# Segundo acesso (HIT)
curl -I http://localhost:8080
```

### 6. Ver status do cache
```bash
curl -I http://localhost:8080 | grep X-Cache
```

## Resultado esperado

| Acesso | X-Cache | TTFB |
|--------|---------|------|
| Origem direta | - | ~200ms |
| CDN (1o acesso) | MISS | ~200ms |
| CDN (2o acesso) | HIT | ~2ms |

## Parar os containers
```bash
docker compose down
```
