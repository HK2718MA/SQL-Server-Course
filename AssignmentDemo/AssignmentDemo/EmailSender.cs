using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class EmailSender
    {
        public async Task Send(string email) { await Task.Delay(500); Console.WriteLine($"Sent {email}"); }
    }

}
