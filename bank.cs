using System;
namespace BankSystem
{

    class Bank
    {
        public string Name { get; set; }
        public string BranchCode { get; set; }
        private List<Customer> Customers = new List<Customer>();
        private List<Transaction> Transactions = new List<Transaction>();
        private int accountCounter = 1000;

        public Bank(string name, string branchCode)
        {
            Name = name;
            BranchCode = branchCode;
        }

        public void AddCustomer(string name, string nationalId, DateTime dob)
        {
            Customers.Add(new Customer(name, nationalId, dob));
            Console.WriteLine($"Customer {name} added successfully!");
        }

        public void UpdateCustomer(string nationalId, string newName, DateTime newDob)
        {
            var customer = Customers.Find(c => c.NationalId == nationalId);
            if (customer != null)
            {
                customer.FullName = newName;
                customer.DateOfBirth = newDob;
                Console.WriteLine("Customer updated successfully!");
            }
            else
            {
                Console.WriteLine("Customer not found!");
            }
        }

        public void SearchCustomer(string nationalId)
        {
            var customer = Customers.Find(c => c.NationalId == nationalId);
            if (customer != null)
                Console.WriteLine(customer);
            else
                Console.WriteLine("Customer not found!");
        }

        public void RemoveCustomer(string nationalId)
        {
            var customer = Customers.Find(c => c.NationalId == nationalId);
            if (customer != null)
            {
                if (customer.Accounts.TrueForAll(a => a.Balance == 0))
                {
                    Customers.Remove(customer);
                    Console.WriteLine("Customer removed successfully!");
                }
                else Console.WriteLine("Cannot remove customer: Accounts not empty.");
            }
        }

        public void CreateAccount(string nationalId, string type)
        {
            var customer = Customers.Find(c => c.NationalId == nationalId);
            if (customer != null)
            {
                int accNo = ++accountCounter;
                Account account = (type == "1")
                    ? new SavingsAccount(accNo, 0, DateTime.Now, 0.05)
                    : new CurrentAccount(accNo, 0, DateTime.Now, 1000);

                customer.Accounts.Add(account);
                Console.WriteLine($"{type} account created with number {accNo}");
            }
            else Console.WriteLine("Customer not found!");
        }

        public void Deposit(int accountNumber, double amount)
        {
            var acc = FindAccount(accountNumber);
            if (acc != null)
            {
                acc.Balance += amount;
                Transactions.Add(new Transaction(accountNumber, "Deposit", amount));
                Console.WriteLine("Deposit successful!");
            }
        }

        public void Withdraw(int accountNumber, double amount)
        {
            var acc = FindAccount(accountNumber);
            if (acc != null && acc.Balance >= amount)
            {
                acc.Balance -= amount;
                Transactions.Add(new Transaction(accountNumber, "Withdraw", amount));
                Console.WriteLine("Withdraw successful!");
            }
            else Console.WriteLine("Insufficient balance!");
        }

        public void Transfer(int fromAcc, int toAcc, double amount)
        {
            var from = FindAccount(fromAcc);
            var to = FindAccount(toAcc);
            if (from != null && to != null && from.Balance >= amount)
            {
                from.Balance -= amount;
                to.Balance += amount;
                Transactions.Add(new Transaction(fromAcc, "Transfer Out", amount));
                Transactions.Add(new Transaction(toAcc, "Transfer In", amount));
                Console.WriteLine("Transfer successful!");
            }
            else Console.WriteLine("Transfer failed!");
        }

        public void ShowTransactions(int accountNumber)
        {
            foreach (var tx in Transactions.FindAll(t => t.AccountNumber == accountNumber))
                Console.WriteLine(tx);
        }

        private Account FindAccount(int accountNumber)
        {
            foreach (var c in Customers)
            {
                var acc = c.Accounts.Find(a => a.AccountNumber == accountNumber);
                if (acc != null) return acc;
            }
            return null;
        }
    }
}
