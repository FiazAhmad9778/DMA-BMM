<%@ Page Title="" Language="C#" MasterPageFile="../Master.Master" AutoEventWireup="true" CodeBehind="ProviderInvoiceReport.aspx.cs" Inherits="BMM.ReportPages.ProviderInvoiceReport" %>






<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <script>
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
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1>
        Provider Invoice Report
    </h1>
    <br />
    <Telerik:RadAjaxPanel runat="server" ID="RadAjaxPanel1">
         <div style="margin-left: 15px; font-family: Arial !important;">
            <div>
                <div style="float: left;">
                    <div>
                        <div style="width: 275px; float: left;">
                            <div style="float: left; margin-top: 3px; margin-right: 5px;">Date of Service <br/> Start Date:</div>
                            <div style="float: left; width: 140px;">
                                <telerik:RadDatePicker ID="rdpStartDate" Width="125px" runat="server"></telerik:RadDatePicker>
                            </div>
                        </div>
                        <div style="width: 275px; float: left;">
                            <div style="float: left; margin-top: 3px; margin-right: 5px;">Date of Service <br/> End Date:</div>
                            <div style="float: left; width: 140px;">
                                <telerik:RadDatePicker ID="rdpEndDate" Width="125px" runat="server"></telerik:RadDatePicker>
                            </div>
                        </div>
                    </div>
                    <div style="margin-top: 5px;">
                        <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="rdpStartDate" Display="Dynamic" Text="* Start Date Required <br />" CssClass="ErrorText"></asp:RequiredFieldValidator>
                        <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="rdpEndDate" Display="Dynamic" Text="* End Date Required" CssClass="ErrorText"></asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="cvDateRange" runat="server" Display="Dynamic" ControlToValidate="" ClientValidationFunction="CheckStartEndDates" Text="* Start date must come before End date" CssClass="ErrorText"></asp:CustomValidator>
                    </div>
                </div>   
                <div style="clear: both"></div>
                <div style="margin-top: 15px">
                    <div>
                        Report Views:
                    </div>
                    <div style="margin-top: 5px">
                        <div style="float: left; padding-top: 3px">
                            <asp:RadioButtonList runat="server" ID="rblReportView" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblReportView_OnSelectedIndexChanged" AutoPostBack="True">
                               <asp:ListItem Text="All Providers" Value="1" Selected="True"></asp:ListItem>
                               <asp:ListItem Text="Specific Provider" Value="2"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <span style="margin-left: 15px">
                            <Telerik:RadComboBox runat="server" ID="rcbProviders" Enabled="False" Filter="Contains"></Telerik:RadComboBox>
                        </span>
                        <span style="margin-left: 50px">
                            <asp:Button ID="btnGenerate" runat="server" Text="Generate" CausesValidation="true" OnClick="btnGenerate_OnClick" />
                        </span>
                    </div>                    
                </div>
            </div>
            <div style="clear: both;"></div>
        </div>
        <br/>
        <Telerik:ReportViewer runat="server" ID="rptProviderInvoiceReport" Width="100%" Height="1150px" ViewMode="PrintPreview" ParametersAreaVisible="False" ShowParametersButton="False" ShowPrintPreviewButton="False"></Telerik:ReportViewer>
    </Telerik:RadAjaxPanel>
</asp:Content>
