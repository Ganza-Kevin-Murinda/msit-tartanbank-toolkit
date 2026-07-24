class Account:
    def __init__(self, account_id, balance=0.0):
        # variable initialization
        self.account_id = account_id
        self.balance = balance
        self.transaction_count = 0

    def deposit(self, amount):
        self.balance += amount
        self.transaction_count +=1

    def withdraw(self, amount):
        if amount <= self.balance:
            self.balance -= amount
            self.transaction_count +=1
            return True

        return False

class Ledger:
    def __init__(self):
        self.accounts = {}
        self.flagged = []

    def get_or_create(self, account_id):
        if account_id not in self.accounts:
            self.accounts[account_id] = Account(account_id)
        return self.accounts[account_id]

    def apply(self, account_id, t_type, amount):
        account = self.get_or_create(account_id)

        if t_type == "deposit":
            account.deposit(amount)
        elif t_type == "withdraw":
            succeeded = account.withdraw(amount)
            if not succeeded:
                self.flagged.append((account_id, amount))
        else:
            raise ValueError(f"Unknown transaction type: {t_type}")

    def summary(self):
        total_transactions = sum(
            account.transaction_count for account in self.accounts.values()
            )
        return {
            "total_accounts": len(self.accounts),
            "total_transactions": total_transactions,
            "flagged_count": len(self.flagged),
        }

