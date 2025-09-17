using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class ApiService
    {
        public async Task<string> GetAll() => await Task.WhenAll(Task.FromResult("A"), Task.FromResult("B")).ContinueWith(t => string.Join(",", t.Result));
    }
}
