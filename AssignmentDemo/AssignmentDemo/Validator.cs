using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class Validator<T>
    {
        private List<Func<T, bool>> rules = new();
        public void AddRule(Func<T, bool> r) => rules.Add(r);
        public bool Validate(T item) => rules.All(r => r(item));
    }
}
