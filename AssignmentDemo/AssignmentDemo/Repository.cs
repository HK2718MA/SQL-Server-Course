using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    interface IEntity { int Id { get; set; } }
    class Repository<T> where T : IEntity
    {
        private List<T> items = new();
        public void Add(T i) => items.Add(i);
        public T Get(int id) => items.FirstOrDefault(x => x.Id == id);
    }

}
