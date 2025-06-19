using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BMM_Reports.Classes
{
    public class MyObject
    {
        public int InvoiceNumber { get; set; }
        public string InvoiceTypeID { get; set; }
        public DateTime ServiceDate { get; set; }
        public string ProviderName { get; set; }
        public decimal Cost { get; set; }
        public string CompanyName { get; set; }
    }
}
