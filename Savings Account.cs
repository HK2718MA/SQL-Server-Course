using System;

namespace BankSystem
{

    class SavingsAccount : Account
    {
        public double InterestRate { get; set; }
        public SavingsAccount(int accNo, double balance, DateTime opened, double rate)
            : base(accNo, balance, opened)
        {
            InterestRate = rate;
        }
    }

}