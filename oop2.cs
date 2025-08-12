using System;
using System.Collections.Generic;

namespace BankSystem
{
  
    class BankAccount
    {
        public const string BankCode = "BNK001";
        public readonly DateTime CreatedDate;

        private string _fullName;
        private string _nationalID;
        private decimal _balance;

        public string FullName
        {
            get { return _fullName; }
            set
            {
                if (string.IsNullOrWhiteSpace(value))
                    throw new ArgumentException("Full name cannot be empty!");
                _fullName = value;
            }
        }

        public string NationalID
        {
            get { return _nationalID; }
            set
            {
                if (value.Length != 14 || !long.TryParse(value, out _))
                    throw new ArgumentException("National ID must be exactly 14 digits.");
                _nationalID = value;
            }
        }

        public decimal Balance
        {
            get { return _balance; }
            set
            {
                if (value < 0)
                    throw new ArgumentException("Balance cannot be negative!");
                _balance = value;
            }
        }

        public BankAccount()
        {
            CreatedDate = DateTime.Now;
            FullName = "Unknown";
            NationalID = "00000000000000";
            Balance = 0;
        }

        public BankAccount(string fullName, string nationalID, decimal balance)
        {
            CreatedDate = DateTime.Now;
            FullName = fullName;
            NationalID = nationalID;
            Balance = balance;
        }

        public virtual decimal CalculateInterest()
        {
            return 0; 
        }


        public virtual void ShowAccountDetails()
        {
            Console.WriteLine($"--- {GetType().Name} ---");
            Console.WriteLine($"Full Name: {FullName}");
            Console.WriteLine($"National ID: {NationalID}");
            Console.WriteLine($"Balance: {Balance:C}");
            Console.WriteLine($"Created Date: {CreatedDate}");
            Console.WriteLine($"Bank Code: {BankCode}");
        }
    }

    
    class SavingAccount : BankAccount
    {
        public decimal InterestRate { get; set; }

        public SavingAccount(string fullName, string nationalID, decimal balance, decimal interestRate)
            : base(fullName, nationalID, balance)
        {
            InterestRate = interestRate;
        }

        public override decimal CalculateInterest()
        {
            return Balance * InterestRate / 100;
        }

        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Interest Rate: {InterestRate}%");
        }
    }

    
    class CurrentAccount : BankAccount
    {
        public decimal OverdraftLimit { get; set; }

        public CurrentAccount(string fullName, string nationalID, decimal balance, decimal overdraftLimit)
            : base(fullName, nationalID, balance)
        {
            OverdraftLimit = overdraftLimit;
        }

        public override decimal CalculateInterest()
        {
            return 0; 
        }

        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Overdraft Limit: {OverdraftLimit:C}");
        }
    }

    
    internal class Program
    {
        static void Main(string[] args)
        {
            SavingAccount saving = new SavingAccount("Ali Ahmed", "12345678901234", 10000, 5);
            CurrentAccount current = new CurrentAccount("Sara Mohamed", "98765432109876", 5000, 2000);

            List<BankAccount> accounts = new List<BankAccount> { saving, current };

            foreach (var acc in accounts)
            {
                acc.ShowAccountDetails();
                Console.WriteLine($"Calculated Interest: {acc.CalculateInterest():C}");
                Console.WriteLine();
            }
        }
    }
}
