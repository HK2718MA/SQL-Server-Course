using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class MyStack<T>
    {
        private List<T> items = new();
        public void Push(T item) => items.Add(item);
        public T Pop() { var i = items[^1]; items.RemoveAt(items.Count - 1); return i; }
        public T Peek() => items[^1];
    }

}
