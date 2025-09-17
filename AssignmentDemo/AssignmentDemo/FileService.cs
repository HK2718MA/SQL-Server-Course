using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class FileService
    {
        public async Task Write(string p, string c) => await File.WriteAllTextAsync(p, c);
        public async Task<string> Read(string p) => await File.ReadAllTextAsync(p);
    }
}
