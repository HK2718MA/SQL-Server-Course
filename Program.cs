using System;

namespace BankApp
{
    class BankAccount
    {

        public const string BankCode = "BNK001";
        public readonly DateTime CreatedDate;


        private int _accountNumber;
        private string _fullName;
        private string _nationalID;
        private string _phoneNumber;
        private string _address;
        private decimal _balance;


        public string FullName
        {
            get { return _fullName; }
            set
            {
                if (!string.IsNullOrWhiteSpace(value))
                    _fullName = value;
                else
                {

                    Console.WriteLine(" Full name cannot be empty.");

                }
            }
        }

        public string NationalID
        {
            get { return _nationalID; }
            set
            {
                if (value.Length == 14 && long.TryParse(value, out _))
                    _nationalID = value;
                else
                {

                    Console.WriteLine(" National ID must be exactly 14 digits.");

                }
            }
        }

        public string PhoneNumber
        {
            get { return _phoneNumber; }
            set
            {
                if (value.Length == 11 && value.StartsWith("01") && long.TryParse(value, out _))
                    _phoneNumber = value;
                else
                {

                    Console.WriteLine(" Phone number must start with '01' and be 11 digits.");

                }
            }
        }

        public string Address
        {
            get { return _address; }
            set { _address = value; }
        }

        public decimal Balance
        {
            get { return _balance; }
            set
            {
                if (value >= 0)
                    _balance = value;
                else
                {

                    Console.WriteLine(" Balance must be greater than or equal to 0.");

                }
            }
        }


        public BankAccount()
        {
            CreatedDate = DateTime.Now;
            _fullName = "Default Name";
            _nationalID = "00000000000000";
            _phoneNumber = "01000000000";
            _address = "Default Address";
            _balance = 0;
        }

        public BankAccount(string fullName, string nationalID, string phoneNumber, string address, decimal balance)
        {
            CreatedDate = DateTime.Now;
            FullName = fullName;
            NationalID = nationalID;
            PhoneNumber = phoneNumber;
            Address = address;
            Balance = balance;
        }

        public BankAccount(string fullName, string nationalID, string phoneNumber, string address)
        {
            CreatedDate = DateTime.Now;
            FullName = fullName;
            NationalID = nationalID;
            PhoneNumber = phoneNumber;
            Address = address;
            Balance = 0;
        }


        public void ShowAccountDetails()
        {

            Console.WriteLine($"Bank Code: {BankCode}");
            Console.WriteLine($"Full Name: {_fullName}");
            Console.WriteLine($"National ID: {_nationalID}");
            Console.WriteLine($"Phone Number: {_phoneNumber}");
            Console.WriteLine($"Address: {_address}");
            Console.WriteLine($"Balance: {_balance:C}");
            Console.WriteLine($"Created Date: {CreatedDate}");

        }

        public bool IsValidNationalID()
        {
            return _nationalID.Length == 14 && long.TryParse(_nationalID, out _);
        }

        public bool IsValidPhoneNumber()
        {
            return _phoneNumber.Length == 11 && _phoneNumber.StartsWith("01") && long.TryParse(_phoneNumber, out _);
        }
    }

    class Program
    {
        static void Main()
        {

            BankAccount account1 = new BankAccount();
            account1.ShowAccountDetails();


            BankAccount account2 = new BankAccount("Habiba Khaled", "12345678901234", "01012345678", "Cairo", 5000);
            account2.ShowAccountDetails();
        }
    }
}