from __future__ import annotations

import argparse
from pathlib import Path

import papermill as pm

REPO_ROOT = Path(__file__).resolve().parents[1]
CASE_NOTEBOOKS = {
    "simdata01": REPO_ROOT / "paramGUI/simData01/fit_simData01.ipynb",
    "simdata02": REPO_ROOT / "paramGUI/simData02/fit_simData02.ipynb",
    "simdata03": REPO_ROOT / "paramGUI/simData03/fit_simData03.ipynb",
    "simdata04": REPO_ROOT / "paramGUI/simData04/fit_simData04.ipynb",
    "simdata05": REPO_ROOT / "paramGUI/simData05/fit_simData05.ipynb",
}


def run_case_notebook(case_name: str) -> Path:
    if case_name not in CASE_NOTEBOOKS:
        available = ", ".join(sorted(CASE_NOTEBOOKS))
        msg = f"Unknown case '{case_name}'. Expected one of: {available}"
        raise SystemExit(msg)

    source = CASE_NOTEBOOKS[case_name]
    pm.execute_notebook(source, source, cwd=source.parent)
    print(f"Executed {case_name} -> {source}")
    return source


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="run_notebooks.py",
        description="Execute paramGUI validation notebooks.",
    )
    subparsers = parser.add_subparsers(
        dest="command", required=True, description="Studies to execute"
    )

    for case_name in sorted(CASE_NOTEBOOKS):
        subparser = subparsers.add_parser(case_name)
        subparser.set_defaults(action="case", case_name=case_name)

    run_all_parser = subparsers.add_parser("run-all")
    run_all_parser.set_defaults(action="run-all")
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    if args.action == "case":
        run_case_notebook(args.case_name)
        return 0

    for case_name in sorted(CASE_NOTEBOOKS):
        run_case_notebook(case_name)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
