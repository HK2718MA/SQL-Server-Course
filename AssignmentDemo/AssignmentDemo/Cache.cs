using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class Cache<TKey, TValue>
    {
        private Dictionary<TKey, (TValue val, DateTime exp)> store = new();
        public void Add(TKey key, TValue val, int seconds)
            => store[key] = (val, DateTime.Now.AddSeconds(seconds));
        public TValue Get(TKey key)
            => store.ContainsKey(key) && store[key].exp > DateTime.Now ? store[key].val : default;
    }
}
