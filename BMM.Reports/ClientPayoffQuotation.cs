using System;

namespace BMM.Reports
{
    /// <summary>
    /// Summary description for ClientPayoffQuotation.
    /// </summary>
    public partial class ClientPayoffQuotation : Telerik.Reporting.Report
    {
        public ClientPayoffQuotation()
        {
            //
            // Required for telerik Reporting designer support
            //
            InitializeComponent();

            //
            // Add any constructor code after InitializeComponent call
            //

            // Set parameters
            //ReportParameters["PatientId"].Value = patientID;
        }
    }
}