import sys
from bank import Ledger


def main():
    if len(sys.argv) != 3:
        print("Usage: python3 process.py <input_csv> <output_report>")
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2]

    ledger = Ledger()
    deposit_amounts = []

    with open(input_path, "r") as f:
        lines = f.readlines()

    # skip the header row
    for line in lines[1:]:                       
        line = line.strip()
        if not line:  # skip any blank lines
            continue

        account_id, tx_type, amount_str = line.split(",")
        amount = float(amount_str)               

        ledger.apply(account_id, tx_type, amount)

        if tx_type == "deposit":
            deposit_amounts.append(amount)

    total_deposits = sum(deposit_amounts)
    average_deposit = total_deposits / len(deposit_amounts) if deposit_amounts else 0.0

    summary = ledger.summary()

    with open(output_path, "w") as report:
        report.write("TartanBank Daily Report\n")
        report.write("=======================\n\n")

        report.write("Final account balances:\n")
        for account_id, account in ledger.accounts.items():
            report.write(f"  {account_id}: {account.balance:.2f}\n")

        report.write(f"\nTotal transactions processed: {summary['total_transactions']}\n")

        report.write(f"\nTotal deposits: {total_deposits:.2f}\n")
        report.write(f"Average deposit: {average_deposit:.2f}\n")

        report.write(f"\nFlagged (declined) withdrawals: {len(ledger.flagged)}\n")
        for account_id, amount in ledger.flagged:
            report.write(f"  {account_id} declined withdrawal of {amount:.2f}\n")

    print(f"Report written to {output_path}")


if __name__ == "__main__":
    main()