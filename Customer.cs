using System;

namespace BankSystem
{
    class Customer
    {
        public string FullName { get; set; }
        public string NationalId { get; set; }
        public DateTime DateOfBirth { get; set; }
        public List<Account> Accounts = new List<Account>();

        public Customer(string name, string nationalId, DateTime dob)
        {
            FullName = name;
            NationalId = nationalId;
            DateOfBirth = dob;
        }

        public override string ToString()
        {
            return $"Customer: {FullName}, National ID: {NationalId}, DOB: {DateOfBirth.ToShortDateString()}";
        }
    }
}