# 🔥 Fire Incidents – Data Engineering Challenge

Este projeto utiliza o dbt (Data Build Tool) para processar e transformar dados de incidentes de incêndio na cidade de São Francisco.

## 📁 Estrutura do Projeto

Utilizamos a arquitetura em camadas no estilo **Medalhão (Bronze, Silver, Gold)**:

```
models/
├── silver/                 ← limpeza, deduplicação, enriquecimento
│   └── stg_fire_incidents.sql
│   └── schema.yml
└── gold/                   ← agregações e métricas finais
    └── fire_incidents_summary.sql
    └── schema.yml
```

## 🧱 Modelos

### 🔹 Silver – `stg_fire_incidents`
- Remove nulos em colunas críticas (`incident_date`, `neighborhood_district`)
- Deduplica `incident_number` com `row_number()`
- Cria colunas derivadas: `incident_year`, `incident_month`, `incident_day`

### 🥇 Gold – `fire_incidents_summary`
- Agrega o número de incidentes por ano, mês, batalhão e distrito

---

## ✅ Testes Automatizados (dbt tests)

Testes aplicados nas camadas Silver e Gold:

- `not_null` em colunas críticas
- `unique` para `incident_number`
- Validação do `total_incidents` no summary

---

## 🚀 Como executar

### 1. Suba um PostgreSQL com Docker

```bash
docker run --name postgres-fire \
  -e POSTGRES_PASSWORD=fire123 \
  -e POSTGRES_DB=fire_incidents \
  -p 5433:5432 \
  -d postgres
```

### 2. Instale dependências

```bash
pip install dbt-postgres
```

### 3. Configure o `profiles.yml`:

```yaml
fire_incidents_project:
  outputs:
    dev:
      type: postgres
      host: 127.0.0.1
      user: postgres
      password: fire123
      port: 5433
      dbname: fire_incidents
      schema: public
      threads: 1
  target: dev
```

### 4. Rode os modelos

```bash
dbt run
```

### 5. Valide os testes

```bash
dbt test
```

---

## 🛠️ Tecnologias Utilizadas

- Python (pandas + sqlalchemy)
- PostgreSQL (Docker)
- dbt (Data Build Tool)
- Arquitetura Silver & Gold
- Data Quality (testes automatizados)

---

## 📌 Observações

- Dados com valores nulos e duplicados são tratados logo na camada Silver.
- O projeto está pronto para expansão com camadas bronze (ex: ingestão via dbt seeds ou snapshots).

---
