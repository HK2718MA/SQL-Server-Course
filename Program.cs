using System;
using System.Collections.Generic;

namespace BankSystem
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("=== Welcome to Bank System ===");
            Console.Write("Enter Bank Name: ");
            string bankName = Console.ReadLine();
            Console.Write("Enter Branch Code: ");
            string branchCode = Console.ReadLine();

            Bank bank = new Bank(bankName, branchCode);

            while (true)
            {
                Console.WriteLine("\n=== Main Menu ===");
                Console.WriteLine("1. Add Customer");
                Console.WriteLine("2. Update Customer");
                Console.WriteLine("3. Search Customer");
                Console.WriteLine("4. Remove Customer");
                Console.WriteLine("5. Create Account");
                Console.WriteLine("6. Deposit");
                Console.WriteLine("7. Withdraw");
                Console.WriteLine("8. Transfer");
                Console.WriteLine("9. Show Transactions");
                Console.WriteLine("10. Exit");

                Console.Write("Choose an option: ");
                string choice = Console.ReadLine();

                switch (choice)
                {
                    case "1": // Add Customer
                        Console.Write("Enter Full Name: ");
                        string name = Console.ReadLine();
                        Console.Write("Enter National ID: ");
                        string nationalId = Console.ReadLine();
                        Console.Write("Enter Date of Birth (yyyy-mm-dd): ");
                        DateTime dob = DateTime.Parse(Console.ReadLine());

                        bank.AddCustomer(name, nationalId, dob);
                        break;

                    case "2": // Update
                        Console.Write("Enter National ID to update: ");
                        string nidUpdate = Console.ReadLine();
                        Console.Write("Enter new Name: ");
                        string newName = Console.ReadLine();
                        Console.Write("Enter new Date of Birth (yyyy-mm-dd): ");
                        DateTime newDob = DateTime.Parse(Console.ReadLine());

                        bank.UpdateCustomer(nidUpdate, newName, newDob);
                        break;

                    case "3": // Search
                        Console.Write("Enter National ID to search: ");
                        string nidSearch = Console.ReadLine();
                        bank.SearchCustomer(nidSearch);
                        break;

                    case "4": // Remove
                        Console.Write("Enter National ID to remove: ");
                        string nidRemove = Console.ReadLine();
                        bank.RemoveCustomer(nidRemove);
                        break;

                    case "5": // Create Account
                        Console.Write("Enter National ID: ");
                        string nidAcc = Console.ReadLine();
                        Console.Write("Choose Account Type (1. Savings, 2. Current): ");
                        string accType = Console.ReadLine();
                        bank.CreateAccount(nidAcc, accType);
                        break;

                    case "6": // Deposit
                        Console.Write("Enter Account Number: ");
                        int accNoDep = int.Parse(Console.ReadLine());
                        Console.Write("Enter Amount: ");
                        double amountDep = double.Parse(Console.ReadLine());
                        bank.Deposit(accNoDep, amountDep);
                        break;

                    case "7": // Withdraw
                        Console.Write("Enter Account Number: ");
                        int accNoW = int.Parse(Console.ReadLine());
                        Console.Write("Enter Amount: ");
                        double amountW = double.Parse(Console.ReadLine());
                        bank.Withdraw(accNoW, amountW);
                        break;

                    case "8": // Transfer
                        Console.Write("Enter From Account Number: ");
                        int fromAcc = int.Parse(Console.ReadLine());
                        Console.Write("Enter To Account Number: ");
                        int toAcc = int.Parse(Console.ReadLine());
                        Console.Write("Enter Amount: ");
                        double amountT = double.Parse(Console.ReadLine());
                        bank.Transfer(fromAcc, toAcc, amountT);
                        break;

                    case "9": // Transactions
                        Console.Write("Enter Account Number: ");
                        int accNoTx = int.Parse(Console.ReadLine());
                        bank.ShowTransactions(accNoTx);
                        break;

                    case "10":
                        Console.WriteLine("Exiting system... Goodbye!");
                        return;

                    default:
                        Console.WriteLine("Invalid choice. Try again.");
                        break;
                }
            }
        }
    }
}