import argparse, shutil, sys
from pathlib import Path

NAME_MAP = {
    "bea_trade_detail.csv": "bea_trade_detail_by_state.csv",
    "export_competitiveness.csv": "state_export_competitiveness.csv",
    "state_trade_flows.csv": "state_trade_flows_exiobase_bridge.csv",
    "trade_factor_bea.csv": "bea_trade_factors_by_sector.csv",
    "flow.csv": "exiobase_trade_flows.csv",
    "reference/state_codes.csv": "reference/state_codes.csv",
    "reference/naics_mapping.csv": "reference/naics_to_exiobase_mapping.csv",
    "reference/bea_sectors.csv": "reference/bea_sectors.csv",
}

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    base = Path(__file__).parent
    for src_rel, dst_rel in NAME_MAP.items():
        src = base / src_rel
        dst = base / dst_rel
        dst.parent.mkdir(parents=True, exist_ok=True)

        if not src.exists():
            if dst.exists():
                print(f"✓ already renamed: {dst_rel}")
            else:
                print(f"⚠ missing: {src_rel}")
            continue

        if dst.exists():
            print(f"• keeping: {dst_rel}, removing old {src_rel}")
            if not args.dry_run:
                src.unlink()
            continue

        print(f"→ renaming {src_rel} → {dst_rel}")
        if not args.dry_run:
            shutil.move(str(src), str(dst))

    print("Done.")

if __name__ == "__main__":
    main()


