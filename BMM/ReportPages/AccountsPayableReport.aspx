<%@ Page Language="C#" MasterPageFile="../Master.Master" AutoEventWireup="true" CodeBehind="AccountsPayableReport.aspx.cs" Inherits="BMM.ReportPages.AccountsPayableReport" %>







<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
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

    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
        <div style="margin-left: 15px; font-family: Arial !important;">
            <div>
                <div style="float: left;">
                    <div>
                        <div style="width: 220px; float: left;">
                            <div style="float: left; margin-top: 3px; margin-right: 5px;">Start Date:</div>
                            <div style="float: left; width: 140px;">
                                <telerik:RadDatePicker ID="rdpStartDate" Width="125px" runat="server"></telerik:RadDatePicker>
                            </div>
                        </div>
                        <div style="width: 220px; float: left;">
                            <div style="float: left; margin-top: 3px; margin-right: 5px;">End Date:</div>
                            <div style="float: left; width: 140px;">
                                <telerik:RadDatePicker ID="rdpEndDate" Width="125px" runat="server"></telerik:RadDatePicker>
                            </div>
                        </div><br /><br />
                        <div style="width: 440px; float: left;">
                            <div style="float: left; width: 300px;">
                                <asp:Literal runat="server" Text="Provider Criteria: " />
                                <asp:RadioButtonList runat="server" ID="rdoProviders" RepeatDirection="Horizontal" Enabled="true" OnSelectedIndexChanged="rdoProviders_SelectedIndexChanged" AutoPostBack="True">
                                        <asp:ListItem Text="All Providers" Value="0" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="Specific Provider" Value="1"></asp:ListItem>
                        </asp:RadioButtonList>
                                <telerik:RadComboBox runat="server" ID="rcbProviders" Visible="false" Filter="Contains" MinFilterLength="2" MarkFirstMatch="true"
                                    EnableLoadOnDemand="true" EnableItemCaching="true" OnItemsRequested="rcbProviders_ItemsRequested" />
                                <asp:RequiredFieldValidator ID="rfvProviders" runat="server" ControlToValidate="rcbProviders" Enabled="false" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                                
                            </div>
                             <div style="float: left; margin-left: 10px; margin-top: 5px;">
                                    <asp:Button ID="btnGenerate" runat="server" Text="Generate" CausesValidation="true" OnClick="btnGenerate_OnClick" />
                                </div>
                        </div>
                    </div>
                    <div style="margin-top: 5px;">
                        <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="rdpStartDate" Display="Dynamic" Text="* Start Date Required <br />" CssClass="ErrorText"></asp:RequiredFieldValidator>
                        <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="rdpEndDate" Display="Dynamic" Text="* End Date Required" CssClass="ErrorText"></asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="cvDateRange" runat="server" Display="Dynamic" ControlToValidate="" ClientValidationFunction="CheckStartEndDates" Text="* Start date must come before End date" CssClass="ErrorText"></asp:CustomValidator>
                    </div>
                </div>
               
            </div>
            <div style="clear: both;"></div>
        </div>
        <br />

        <telerik:ReportViewer runat="server" ID="rptAccountsPayable" Width="100%" Height="900px" ViewMode="PrintPreview" ParametersAreaVisible="False" ShowParametersButton="False" ShowPrintPreviewButton="False" ></telerik:ReportViewer>
    </telerik:RadAjaxPanel>
</asp:Content>
