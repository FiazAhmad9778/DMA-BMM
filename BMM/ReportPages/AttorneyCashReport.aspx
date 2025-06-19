<%@ Page Language="C#" MasterPageFile="../Master.Master" AutoEventWireup="true" CodeBehind="AttorneyCashReport.aspx.cs" Inherits="BMM.ReportPages.AttorneyCashReport" %>







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
    <telerik:RadAjaxPanel runat="server">
        <div style="margin-left: 15px; font-family: Arial !important;">
            <div>
                <div style="float: left;">
                    <div>
                        <div style="width: 220px; float: left;">
                            <div style="float: left; margin-top: 3px; margin-right: 5px; font-size: 14px; font-family: Arial !important;">Start Date:</div>
                            <div style="float: left; width: 140px;">
                                <telerik:RadDatePicker ID="rdpStartDate" Width="125px" runat="server"></telerik:RadDatePicker>
                            </div>
                        </div>
                        <div style="width: 220px; float: left; padding-left: 15px;">
                            <div style="float: left; margin-top: 3px; margin-right: 5px; font-size: 14px; font-family: Arial !important;">End Date:</div>
                            <div style="float: left; width: 140px;">
                                <telerik:RadDatePicker ID="rdpEndDate" Width="125px" runat="server"></telerik:RadDatePicker>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="margin-bottom: 5px;">
                    <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="rdpStartDate" Display="Dynamic" Text="* Start Date Required <br />" CssClass="ErrorText"></asp:RequiredFieldValidator>
                    <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="rdpEndDate" Display="Dynamic" Text="* End Date Required" CssClass="ErrorText"></asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="cvDateRange" runat="server" Display="Dynamic" ControlToValidate="" ClientValidationFunction="CheckStartEndDates" Text="* Start date must come before End date" CssClass="ErrorText"></asp:CustomValidator>
                </div>
            </div>
            <div style="clear: both;"></div>
        </div>
        <div style="margin-left: 15px; font-family: Arial !important; padding-top: 20px;">
            <div style="margin-bottom: 10px; font-size: 14px;">Report Views:</div>
            <div style="clear: both;"></div>
            <div>
                <div style="float: left;">
                    <div>
                        <asp:RadioButtonList ID="rblCashReport" runat="server" RepeatColumns="2" RepeatDirection="Vertical" RepeatLayout="Table" CellPadding="5" CellSpacing="2" AutoPostBack="true" OnSelectedIndexChanged="rblCashReport_OnSelectedIndexChanged">
                            <asp:ListItem Text="All Attorneys" Selected="True" Value="CashReport.rdlc"></asp:ListItem>
                            <asp:ListItem Text="Specific Attorney" Value="CashReportAttorneyView.rdlc"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div>
                        <telerik:RadComboBox ID="rcbAttorney" runat="server" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true"
                            EnableLoadOnDemand="true" EnableItemCaching="true" OnItemsRequested="rcbAttorney_OnItemsRequested" />
                        <asp:RequiredFieldValidator ID="rfvAttorney" runat="server" ControlToValidate="rcbAttorney" Enabled="false" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                    </div>
                </div>
                <div style="float: left; margin-left: 20px;">
                    <asp:Button ID="btnGenerate" runat="server" Text="Generate" CausesValidation="true" OnClick="btnGenerate_OnClick" />
                </div>
            </div>
            <div style="clear: both;"></div>
        </div>

        <br />
        <telerik:ReportViewer runat="server" ID="rptAttorneyCash" Width="100%" Height="900px" ViewMode="PrintPreview" ParametersAreaVisible="False" ShowParametersButton="False" ShowPrintPreviewButton="False"></telerik:ReportViewer>
    </telerik:RadAjaxPanel>

</asp:Content>
