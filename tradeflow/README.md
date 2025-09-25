# Tradeflow BEA Outputs

### Output files (canonical names)

- bea_trade_detail_by_state.csv — Detailed BEA trade by state and sector
- state_export_competitiveness.csv — Export competitiveness metrics by state
- state_trade_flows_exiobase_bridge.csv — State flows mapped to EXIOBASE schema
- bea_trade_factors_by_sector.csv — Trade factors per BEA sector
- exiobase_trade_flows.csv — Core EXIOBASE trade flows
- reference/state_codes.csv — State codes
- reference/naics_to_exiobase_mapping.csv — NAICS → EXIOBASE mapping
- reference/bea_sectors.csv — BEA sectors

---

**Post-processing rename:**

```bash
python tradeflow/rename_tables.py --dry-run

Save & exit (`CTRL+O`, `ENTER`, `CTRL+X` in nano).

---

### Step 4: (Optional) Also update `profile/trade/`
Check if that folder exists:
```bash
ls profile/trade

