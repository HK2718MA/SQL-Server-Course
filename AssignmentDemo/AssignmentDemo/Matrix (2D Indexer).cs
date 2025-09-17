using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class Matrix
    {
        private int[,] data;
        public Matrix(int rows, int cols) => data = new int[rows, cols];
        public int this[int r, int c]
        {
            get => data[r, c];
            set => data[r, c] = value;
        }
    }

}
