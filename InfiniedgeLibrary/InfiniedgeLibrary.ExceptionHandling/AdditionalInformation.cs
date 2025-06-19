using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace InfiniedgeLibrary.ExceptionHandling
{
    public class AdditionalInformation
    {
        public string FieldName { get; set; }
        public string FieldValue { get; set; }

        public AdditionalInformation(string Name, string Value)
        {
            FieldName = Name;
            FieldValue = Value;
        }
    }
}
