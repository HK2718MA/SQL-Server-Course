using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class PhoneBook
    {
        private Dictionary<string, string> contacts = new();
        public string this[string name]
        {
            get => contacts.ContainsKey(name) ? contacts[name] : "Not Found";
            set => contacts[name] = value;
        }
    }
}
