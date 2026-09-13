<h1 class="card-title">PartnerTools Webroot 2.0</h1>

Install steps: [model.earth/webroot](https://model.earth/webroot)


### Start Local Server

From the webroot folder, run:
python -m http.server 8887


Then view at:

[localhost:8887](http://localhost:8887)  
[localhost:8887/team](http://localhost:8887/team/)  
[localhost:8887/projects](http://localhost:8887/projects/)

## Current TradeFlow Setup

### 1. Prerequisites

For the current TradeFlow Rust/API workflow:

- **Rust 1.70+ and Cargo** 
- **Azure PostgreSQL access** 

- A local clone of `ModelEarth/trade-data` is **not required** by the Rust import endpoint. The API fetches published CSV files directly from the ModelEarth `trade-data` repository over GitHub raw-content URLs.
- A simple local static web server is needed to view the TradeFlow UI locally. The repository documentation supports options such as Python's HTTP server or `npx serve`; Node itself is not otherwise required by the Rust TradeFlow path.

If regenerating TradeFlow CSV data:

- **Python 3**, a virtual environment, and the packages listed in `exiobase/tradeflow/requirements.txt` are required.
- `BEA_API_KEY` is required for pipeline steps that retrieve BEA data.
- The Python pipeline expects access to a local `trade-data` directory because generated CSV files are written into the `trade-data/year/{year}` structure.

### 2. Setup

1. **Clone the repository**
```bash
git clone https://github.com/ModelEarth/webroot.git
cd webroot
git submodule update --init --recursive team
```

2. **Create .env file**
```bash
cp docker/.env.example docker/.env
```

3. **Edit .env with your settings**
```env
- Configure the EXIOBASE database connection using:
  - `EXIOBASE_HOST=modelearth-postgres-server.postgres.database.azure.com`
  - `EXIOBASE_PORT=5432`
  - `EXIOBASE_NAME=industrydb`
  - `EXIOBASE_USER=postgresadmin`
  - `EXIOBASE_PASSWORD=your_password`

```

4. **Initialize the database schema**

No manual SQL migration scripts are required for the current Rust TradeFlow path.

The Rust backend creates the six TradeFlow tables automatically using `CREATE TABLE IF NOT EXISTS`:

- `industry`
- `factor`
- `trade`
- `trade_factor`
- `interstate`
- `interstate_factor`

Schema initialization happens automatically when TradeFlow data is inserted through:

```text
POST /api/db/insert-trade-data
```

5. **Run the application**

Start the Rust API/backend from the `team` directory:

```bash
cd team
cargo run -- serve
```

The Rust API/backend is available at:

http://localhost:8081

Keep the Rust server running and open a second terminal. From the `webroot` directory, start the local web server:

```bash
python -m http.server 8887
```

Open the TradeFlow UI:

http://localhost:8887/exiobase/tradeflow/

Open the Admin SQL Panel:

http://localhost:8887/team/admin/sql/panel/

To import TradeFlow data:

1. Select a year (2019–2022).
2. Select a country from the map.
3. Click **Insert Data**.
4. The UI sends the selected `year` and `country` to `/api/db/insert-trade-data`.
5. The Rust API processes the `domestic`, `imports`, and `exports` flow types for the selected year and country.
6. Import status is displayed in the UI, and the schema diagram is refreshed after the request.


## Architecture

### Data Flow

The current TradeFlow data path is:

```text
ModelEarth/exiobase/tradeflow Python pipeline
        ↓
CSV/data transformation
        ↓
Local trade-data/year/{year}/{country}/{tradeflow}/ output
        ↓
ModelEarth/trade-data GitHub repository
        ↓
Rust Team API
        ↕
Azure PostgreSQL
        ↓
TradeFlow UI
        ↓
JS static schema fallback if the live Rust/DB schema request fails
```

### Database Tables

The current TradeFlow database uses six main tables:

| Table | Purpose |
| --- | --- |
| `industry` | Stores industry reference data used by TradeFlow records. |
| `factor` | Stores factor reference data used for impact/factor calculations. |
| `trade` | Stores the core trade-flow records for a year, country, and flow type. |
| `trade_factor` | Stores factor-level data associated with trade records. |
| `interstate` | Stores U.S. interstate trade-flow records. |
| `interstate_factor` | Stores factor-level data associated with interstate trade records. |

The Rust backend initializes these tables when required by the TradeFlow import process. The deployed Azure schema may differ from the Rust DDL or JavaScript fallback schema where schema drift exists; the live Azure database represents the current deployed database state.

## API Endpoints

### Import Data

`POST /api/db/insert-trade-data`

Imports TradeFlow data for a selected year and country.

The request sends:

- `year`
- `country`

The Rust backend processes the supported TradeFlow types (`domestic`, `imports`, and `exports`), initializes the required database tables if needed, fetches the published CSV files from the `ModelEarth/trade-data` repository, and inserts the data into PostgreSQL.

### Get Schema

`GET /api/db/industry-schema`

Returns live database schema metadata used by the TradeFlow UI, including table and column information.

The UI uses this endpoint to render the live schema diagram. If the request fails, the frontend falls back to a static JavaScript schema definition.

### Get Table Data

`POST /api/db/table-rows`

Returns live row data from a selected database table.

Request fields include:

- `table` — required table name
- `connection` — optional database connection selector; use `EXIOBASE` for the TradeFlow database
- `page` — requested page
- `size` — number of rows per page, with a maximum of 1000
- `sort_field` — optional column to sort by
- `sort_dir` — optional sort direction

The endpoint first retrieves the total row count, then returns the requested page of table data.

Example response structure:

```json
{
  "data": [],
  "total": 0,
  "page": 1,
  "size": 200,
  "last_page": 1
}
```

### Primary Keys and Constraints

The current live Azure PostgreSQL schema uses the following primary-key structure:

| Table | Current Primary Key | Notes |
| --- | --- | --- |
| `industry` | `industry_id` | Meaningful identifier from the data. |
| `factor` | `factor_id` | Meaningful identifier from the data. |
| `trade` | None | No primary key currently exists in the live Azure table. |
| `trade_factor` | None | No primary key currently exists in the live Azure table. |
| `interstate` | `id` | Sequence-generated `BIGINT` surrogate primary key. |
| `interstate_factor` | `id` | Sequence-generated `BIGINT` surrogate primary key. |

No separately declared `UNIQUE` constraints are currently present on these six live Azure tables.

The Rust schema initialization contains additional intended constraints, including `trade_dedup` on (`trade_id`, `year`, `country`, `flow_type`). However, this constraint is not currently present in the live Azure database. This difference is documented as schema drift rather than treated as an active live constraint.

### Indexes

The Rust schema initialization creates several indexes to support TradeFlow lookups and filtering, including indexes on the `trade`, `trade_factor`, `interstate`, and `interstate_factor` tables.

The live Azure database also contains indexes for these tables, but the deployed index set is not identical to the Rust DDL. Some live interstate indexes appear to overlap in purpose, which indicates historical schema drift.

Indexes should therefore be treated as part of the live deployed schema rather than assumed solely from the Rust initialization code.

### Import and Conflict Behavior

The current Rust importer does not handle repeated imports the same way for every table.

| Table | Current Import Behavior |
| --- | --- |
| `industry` | `ON CONFLICT (industry_id) DO NOTHING` |
| `factor` | `ON CONFLICT (factor_id) DO NOTHING` |
| `trade` | `ON CONFLICT (trade_id, year, country, flow_type) DO NOTHING` |
| `trade_factor` | Plain `INSERT` |
| `interstate` | Plain `INSERT` |
| `interstate_factor` | Plain `INSERT` |

For `industry`, `factor`, and `trade`, rows that conflict with the configured key are skipped rather than updated.

For `trade_factor`, `interstate`, and `interstate_factor`, repeated imports can insert additional copies because the current insert path does not use `ON CONFLICT`.

The CSV-generation side behaves differently: generated CSV files are overwritten on regeneration rather than appended. As a result, the published CSV data and Azure database contents can diverge if the same dataset is imported repeatedly or if regenerated values change.

> **Current interstate import limitation:** For U.S. domestic data, the Rust importer still requests the older `bea_trade_detail.csv` and `state_trade_flows.csv` filenames, while the current pipeline produces `interstate.csv` and `interstate_factor.csv`.

> **Current trade-factor mapping limitation:** The generated `trade_factor.csv` contains `trade_id`, `factor_id`, and `level`, while the Rust importer currently reads four positional values as `trade_id`, `factor_id`, `coefficient`, and `level`. This mapping should be aligned before treating the current import as correct.

### Schema Drift

The TradeFlow schema and data structure are represented across several layers that are not currently fully synchronized:

1. **Python-generated CSV files** — define the fields produced by the TradeFlow and BEA pipelines.
2. **Rust database DDL and importer** — define table initialization and map CSV fields into PostgreSQL inserts.
3. **Rust static schema fallback** — provides schema metadata when PostgreSQL schema retrieval is unavailable.
4. **Azure PostgreSQL** — represents the currently deployed database tables, constraints, indexes, and imported data.
5. **JavaScript UI fallback** — provides a client-side static schema when live schema retrieval is unavailable.

One important difference is how identifiers are defined and used across these layers.

| Layer | Generic `id` / Identifier Behavior | Notable Difference |
| --- | --- | --- |
| **Python-generated CSVs** | No generic `BIGSERIAL id` is generated. Domain identifiers such as `trade_id`, `interstate_id`, `industry_id`, and `factor_id` are used. | `interstate.csv` includes `interstate_id`. |
| **Rust DDL / Importer** | Rust DDL declares generic `BIGSERIAL id` primary keys for `trade`, `trade_factor`, `interstate`, and `interstate_factor`, alongside domain identifiers used during import. | The Rust `interstate` table definition does not align with the Python-generated `interstate_id` structure. |
| **Rust Static Fallback** | Maintains a separate static representation of the schema when PostgreSQL schema retrieval is unavailable. | This representation must be kept synchronized with both the Rust DDL and deployed database schema. |
| **Azure PostgreSQL** | `industry` uses `industry_id` as PK; `factor` uses `factor_id` as PK; `trade` and `trade_factor` currently have no PK or generic `id`; `interstate` and `interstate_factor` use sequence-generated generic `id` PKs. | The live `interstate` table does not contain `interstate_id`, although that identifier exists in the generated interstate data. |
| **JavaScript UI Fallback** | Maintains a static representation of table identifiers and relationships. | The UI represents `interstate_id`, even though the live Azure `interstate` table currently does not contain that column. |

The live Azure PostgreSQL schema represents the current deployed database state. Identifier and schema changes should be checked across all five layers to prevent additional schema drift.