using System;
namespace BankSystem
{
    class Transaction
    { 
    public int AccountNumber { get; set; }
    public string Type { get; set; }
    public double Amount { get; set; }
    public DateTime Date { get; set; }

    public Transaction(int accNo, string type, double amount)
    {
        AccountNumber = accNo;
        Type = type;
        Amount = amount;
        Date = DateTime.Now;
    }

    public override string ToString()
    {
        return $"[{Date}] {Type} of {Amount} on Account {AccountNumber}";
    }
}
}