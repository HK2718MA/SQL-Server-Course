using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AssignmentDemo
{
    class InvalidEmailException : Exception { public InvalidEmailException(string m) : base(m) { } }

}
