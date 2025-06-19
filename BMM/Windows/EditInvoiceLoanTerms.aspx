<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditInvoiceLoanTerms.aspx.cs" Inherits="BMM.Windows.EditInvoiceLoanTerms" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <script type="text/javascript">
            function Close(args) {
                var window = GetRadWindow();
                if (window != null) { window.Close(args); }
           }
           function GetRadWindow() {
               var oWindow = null;
               if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
               else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz az well)
               return oWindow;
           }
    </script>
    <link href="../CSS/Modals.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .Content .ErrorText
        {
            font-size: 14px;
            font-weight: normal;
            color: #ed1c24;
        }
        
        
        .Content table.FormTable 
        {
            margin: 0 0 10px 0;
        }
        .Content table.FormTable > tbody > tr > th,
        .Content table.FormTable > tbody > tr > td
        {
            text-align: left;
            vertical-align: middle;
        }
        .Content table.FormTable > tbody > tr > th
        {
            font-size: 14px;
            font-weight: bold;
            padding: 0 0 5px 0;
        }
        .Content table.FormTable > tbody > tr > td
        {
            padding: 0;
            width: 170px;
        }
        .Content table.FormTable > tbody > tr > td + td
        {
            width: auto;
        }
        .Content table.FormTable > tbody > tr + tr > th 
        {
            padding-top: 10px;
        }
        
        .Content table.FormTable .Textbox
        {
            width: 150px;
        }
        
        .RadInput > input
        {
            text-align: right;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="scriptman1" runat="server" />
        <telerik:RadFormDecorator ID="RadFormDecorator2" runat="server" EnableEmbeddedSkins="false" DecoratedControls="Buttons" />
        <div class="Header">
            <div class="Title"><asp:Literal ID="litTitle" runat="server" /></div>
            <asp:Image class="CloseButton" ID="imgCloseButton" onclick="Close(false)" runat="server" SkinID="imgCloseButton" AlternateText="Test Image" />
        </div>
        <div class="Content">
            <table class="FormTable">
                <tbody>
                    <tr>
                        <th colspan="2">Yearly Interest:</th>
                    </tr>
                    <tr>
                        <td><telerik:RadNumericTextBox ID="txtYearlyInterest" runat="server" Type="Percent" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="2" NumberFormat-KeepTrailingZerosOnFocus="false" /></td>
                        <td><asp:RequiredFieldValidator ID="rfvYearlyInterest" runat="server" ControlToValidate="txtYearlyInterest" Text="Required" CssClass="ErrorText" Display="Dynamic" /></td>
                    </tr>
                    <tr>
                        <th colspan="2">Loan Term (in months):</th>
                    </tr>
                    <tr>
                        <td><telerik:RadNumericTextBox ID="txtLoanTermMonths" runat="server" Type="Number" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="0" NumberFormat-KeepTrailingZerosOnFocus="false" /></td>
                        <td><asp:RequiredFieldValidator ID="rfvLoanTermMonths" runat="server" ControlToValidate="txtLoanTermMonths" Text="Required" CssClass="ErrorText" Display="Dynamic" /></td>
                    </tr>
                    <tr>
                        <th colspan="2">Interest Waived Time Period (in months):</th>
                    </tr>
                    <tr>
                        <td><telerik:RadNumericTextBox ID="txtServiceFeeWaivedMonths" runat="server" Type="Number" MinValue="0" EnableSingleInputRendering="false" NumberFormat-DecimalDigits="0" NumberFormat-KeepTrailingZerosOnFocus="false" /></td>
                        <td><asp:RequiredFieldValidator ID="rfvServiceFeeWaivedMonths" runat="server" ControlToValidate="txtServiceFeeWaivedMonths" Text="Required" CssClass="ErrorText" Display="Dynamic" /></td>
                    </tr>
                </tbody>
            </table>
            <div class="Modal_Buttons">
                <asp:Button ID="bytNo" runat="server" OnClientClick="Close(false)" Text="Cancel" CausesValidation="false" />
                <asp:Button ID="btnYes" runat="server" OnClick="btnYes_Click" Text="Save" />
            </div>
        </div>
    </form>
</body>
</html>
