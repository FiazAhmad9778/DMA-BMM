<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="TotalRevenueReport.aspx.cs" Inherits="BMM.ReportPages.TotalRevenueReport" %>






<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function CheckStartEndDates(sender, args) {
            var startDatePicker = $find("<%= rdpStartDate.ClientID %>");
        var startDate = startDatePicker.get_selectedDate();

        var endDatePicker = $find("<%= rdpEndDate.ClientID %>");
        var endDate = endDatePicker.get_selectedDate();

        if (endDate != null && startDate != null) {
            if (endDate < startDate) {
                args.IsValid = false;
            }
            else {
                args.IsValid = true;
            }
        }
        }

        function CheckDateDiff(sender, args) {
            var startDatePicker = $find("<%= rdpStartDate.ClientID %>");
            var startDate = startDatePicker.get_selectedDate();

            var endDatePicker = $find("<%= rdpEndDate.ClientID %>");
            var endDate = endDatePicker.get_selectedDate();

            var timeDiff = Math.abs(endDate.getTime() - startDate.getTime());
            var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
            if (diffDays > (365 * 10)) {
                args.IsValid = false;
            }
            else {
                args.IsValid = true;
            }
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1>Revenue Report</h1>
    
    <div>
        <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="rdpStartDate" Display="Dynamic" Text="* Start Date Required <br />" CssClass="ErrorText"></asp:RequiredFieldValidator>
        <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="rdpEndDate" Display="Dynamic" Text="* End Date Required" CssClass="ErrorText"></asp:RequiredFieldValidator>
        <asp:CompareValidator runat="server" ID="cvStartEndDate" ControlToCompare="rdpStartDate" ControlToValidate="rdpEndDate" Operator="GreaterThanEqual" CssClass="ErrorText" ErrorMessage="* End date must be greater or equal to Start Date"></asp:CompareValidator><br />
        
    </div>
    <div style="margin-left:15px;font-family:Arial !important;">                                         
        <span>
            Start Date:
        </span>
        <span>
             
            <telerik:RadDatePicker runat="server" Width="100px" ID="rdpStartDate" />          
        </span>
        <span style="margin-left: 35px">
            End Date:
        </span> 
        <span>
            
            <telerik:RadDatePicker runat="server" Width="100px" ID="rdpEndDate" />              
        </span>
        <span style="margin-left: 35px">
            <asp:Button ID="btnGenerate" runat="server" Text="Generate" CausesValidation="true" OnClick="btnGenerate_Click" />    
        </span>                                             
    </div>
    <br />
    <br/>
    <Telerik:ReportViewer runat="server" ID="rvTotalRevenue" Width="100%" Height="900px" ShowPrintPreviewButton="False" ViewMode="PrintPreview"></Telerik:ReportViewer>
    
</asp:Content>
