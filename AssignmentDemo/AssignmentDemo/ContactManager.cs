using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class ContactManager
    {
        private Dictionary<string, string> contacts = new();
        public void Add(string n, string p) => contacts[n] = p;
        public void Remove(string n) => contacts.Remove(n);
        public string Search(string n) => contacts.ContainsKey(n) ? contacts[n] : "Not Found";
    }

}
