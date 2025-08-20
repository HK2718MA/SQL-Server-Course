using System;

namespace BankSystem
{
    abstract class Account
    {
        public int AccountNumber { get; set; }
        public double Balance { get; set; }
        public DateTime DateOpened { get; set; }

        protected Account(int accNo, double balance, DateTime dateOpened)
        {
            AccountNumber = accNo;
            Balance = balance;
            DateOpened = dateOpened;
        }
    }
}