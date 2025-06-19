<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ReportsHome.aspx.cs" Inherits="BMM.ReportsHome" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Reports.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="ReportsHomeDiv">
        <h1>Reports</h1>
        <div style="float: left; width:49%;">
            <div class="Report_DivHeader">
                <h2>Attorney Reports</h2>
            </div>
            <div class="Report_DivContent">
                <div>
                    <a href="/ReportPages/AttorneyStatementsReports.aspx">Attorney Statements</a>
                    View a breakdown of what each Attorney owes. Views include All Invoices For Attorney and Past Due Invoices.
                </div>
                
                <div>
                    <a href="/ReportPages/AttorneyLettersReport.aspx">Attorney Letters</a>
                    Create the Attorney Letters to accompany the statements to be mailed out.
                </div>
                <div>
                    <a href="/ReportPages/AttorneyListReports.aspx">Attorney List</a>
                    View a list of all active attorneys and their corresponding loan terms.
                </div>
                <div>
                    <a href="/ReportPages/ClientPayoffQuotationReport.aspx">Client Payoff Quotation Report</a>
                    View a patient's current payoff quotation.
                </div>
            </div>
            <div class="Report_DivHeader">
                <h2>Collection Reports</h2>
            </div>
            <div class="Report_DivContent">
                <div>
                    <a href="/ReportPages/DiscountReport.aspx">Reduction Report</a>
                    View a breakdown of the reductions attorneys have received during a specified time period. Views include a Summary View or Per Attorney View.
                </div>
                <div>
                    <a href="/ReportPages/AccountsReceivableReport.aspx">Accounts Receivables Report</a>
                    View a listing of all the Receivables breakdowns for attorneys with open invoices. Viewing options include: Receivables, Receivables by Date and Past Due Receivables.
                </div>
                <div>
                    <a href="/ReportPages/PercentCash-LossCollected_ByDays.aspx">Percent Loss/Cash Collected by Days Report</a>
                    View a percentage breakdown of both payments and losses by attorney over a period of time.
                </div>                
            </div>
            <div class="Report_DivHeader">
                <h2>Patient Reports</h2>
            </div>
            <div class="Report_DivContent">
                <div>
                    <a href="/ReportPages/PatientReport.aspx">Patient Report</a>
                    View a summary of patients.
                </div>
            </div>
        </div>
        <div style="float: left; width:2%;">&nbsp;</div>
        <div style="float: right; width:48%;">
            <div class="Report_DivHeader">
                <h2>Sales Reports</h2>
            </div>
            <div class="Report_DivContent">
                <div>
                    <a href="/ReportPages/TotalRevenueReport.aspx">Total Revenue Report</a>
                    View a yearly total revenue breakdown by attorney.
                </div>
                <div>
                    <a href="/ReportPages/TotalTestsAndSurgeriesByAttorney.aspx">Total Tests and Surgeries by Attorney Report</a>
                    A 12-month snapshot of all tests and surgeries obtained by attorney, by provider/physician.
                </div>
            </div>
            <div class="Report_DivHeader">
                <h2>ICD / CPT Reports</h2>
            </div>
            <div class="Report_DivContent">
                <div>
                    <a href="/ReportPages/ICDCodeReport.aspx">ICD Code Report</a>
                    View a listing of all surgeries for a selected ICD Code and provider costs.
                </div>
                <div>
                    <a href="/ReportPages/CPTReport.aspx">CPT Report</a>
                    View a list of all tests or surgeries with the selected CPT Code along with associated costs from providers.
                </div>
            </div>
            <div class="Report_DivHeader">
                <h2>System Reports</h2>
            </div>
            <div class="Report_DivContent">
                <div>
                    <a href="/ReportPages/AccountsPayableReport.aspx">Accounts Payables Report</a>
                    View a listing of all the Payables due during a specified time period.
                </div>
                <div>
                    <a href="/ReportPages/AttorneyCashReport.aspx">Cash Report</a>
                    View a listing of Cash Collected during a specified time period. Viewing options include per attorney or all attorneys together.
                </div>
                <div>
                    <a href="/ReportPages/ProviderPaymentsReport.aspx">Provider Payment Report</a>
                    View a listing of all payments made to providers during the specified time period.
                </div>
                <div>
                    <a href="/ReportPages/ProviderInvoiceReport.aspx">Provider Invoice Report</a>
                    View a listing of Invoices for providers during the specified time period.
                </div>
            </div>
        </div>
    </div>

</asp:Content>
