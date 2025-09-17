using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class Notifier
    {
        public Action<string> Notify;
        public void Send(string msg) => Notify?.Invoke(msg);
    }
}
