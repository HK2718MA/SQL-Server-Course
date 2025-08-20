using System;

namespace BankSystem
{
    class CurrentAccount : Account
    {
        public double OverdraftLimit { get; set; }
        public CurrentAccount(int accNo, double balance, DateTime opened, double limit)
            : base(accNo, balance, opened)
        {
            OverdraftLimit = limit;
        }
    }
}