using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class PluginManager
    {
        private List<Action> rules = new();
        public void Register(Action r) => rules.Add(r);
        public void Execute() { foreach (var r in rules) r(); }
    }

}
