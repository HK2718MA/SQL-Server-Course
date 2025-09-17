using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class MyTimer
    {
        public event Action Tick;
        public event Action Done;
        public async void Start(int sec)
        {
            for (int i = 0; i < sec; i++) { await Task.Delay(1000); Tick?.Invoke(); }
            Done?.Invoke();
        }
    }
}
