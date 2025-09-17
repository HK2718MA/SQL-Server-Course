using System;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    public class QueueService<T>
    {
        private readonly Queue<T> _queue = new Queue<T>();

        public void Enqueue(T item)
        {
            _queue.Enqueue(item);
            Console.WriteLine($"Enqueued: {item}");
        }

        public async Task Process()
        {
            while (_queue.Count > 0)
            {
                var item = _queue.Dequeue();
                Console.WriteLine($"Processing: {item}");
                await Task.Delay(500); 
            }
        }
    }
}
