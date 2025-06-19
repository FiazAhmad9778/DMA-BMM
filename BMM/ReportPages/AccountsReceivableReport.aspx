<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AccountsReceivableReport.aspx.cs" Inherits="BMM.ReportPages.AccountsReceivableReport" %>






<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
<%--    <script>
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
    </script>--%>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1>
        Accounts Receivable
    </h1>
    <div style="margin-left: 15px;">
        <div style="margin-bottom: 1em;">
            <div style="margin-top: 20px; margin-bottom: 10px;">
                <span style="font-size: 14px;">
                    Report Views:
                </span>
            </div>
            <div style="float: left">
                <asp:RadioButtonList runat="server" ID="rblReportSelector" RepeatColumns="2" RepeatDirection="Vertical" RepeatLayout="Table" CellPadding="5" CellSpacing="2" AutoPostBack="True" OnSelectedIndexChanged="rblReportSelector_OnSelectedIndexChanged"/>
            </div><br /><br />
            
            <div style="float: left; margin-left: 20px;">
                <asp:Button runat="server" ID="btnGenerate" Text="Generate" CausesValidation="True" OnClick="btnGenerate_OnClick"/>
            </div>
            <div style="clear:both;"></div>
        </div>
        <div style="float: left;">
            <span style="font-size: 14px;">
                    Attorney Criteria:
                </span>
                    <div>
                        <asp:RadioButtonList ID="rblAttorneys" runat="server" RepeatColumns="2" RepeatDirection="Vertical" RepeatLayout="Table" CellPadding="5" CellSpacing="2" AutoPostBack="true" OnSelectedIndexChanged="rblAttorneys_SelectedIndexChanged">
                            <asp:ListItem Text="All Attorneys" Selected="True" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Specific Attorney" Value="1"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div>
                        <telerik:RadComboBox ID="rcbAttorney" runat="server" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true"
                            EnableLoadOnDemand="true" EnableItemCaching="true" Visible="false" OnItemsRequested="rcbAttorney_ItemsRequested" />
                        <asp:RequiredFieldValidator ID="rfvAttorney" runat="server" ControlToValidate="rcbAttorney" Enabled="false" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                    </div>
                </div>
        <div style="margin-bottom: 1em;">
            <asp:Panel runat="server" ID="pnlDates">
<%--                <div style="width: 220px; float: left;">
                    <div style="float: left; margin-top: 3px; margin-right: 5px; font-size: 14px;">Start Date:</div>
                    <div style="float: left; width: 140px;">
                        <Telerik:RadDatePicker runat="server" ID="rdpStartDate" Width="125px"></Telerik:RadDatePicker>
                    </div>
                </div>--%>
                <div style="width: 220px; float:left; margin-left: 15px;">
                    <div style="float: left; margin-top: 3px; margin-right: 5px; font-size: 14px;">End Date:</div>
                    <div style="float: left; width: 140px;">
                        <Telerik:RadDatePicker runat="server" ID="rdpEndDate" Width="125px"></Telerik:RadDatePicker>
                    </div>
                </div>

                <div style="float: left; margin-bottom: 5px;">
<%--                    <div>
                        <asp:RequiredFieldValidator runat="server" ID="rfvStartDate" ControlToValidate="rdpStartDate" Display="Dynamic" Text="* Start Date Required" CssClass="ErrorText"></asp:RequiredFieldValidator>
                    </div>--%>
                    <div>
                        <asp:RequiredFieldValidator runat="server" ID="rfvEndDate" ControlToValidate="rdpEndDate" Display="Dynamic" Text="* End Date Required" CssClass="ErrorText"></asp:RequiredFieldValidator>
                    </div>
<%--                    <div>
                        <asp:CustomValidator runat="server" ID="cvDateRange" Display="Dynamic" ControlToValidate="" ClientValidationFunction="CheckStartEndDates" Text="* Start date must come before End date" CssClass="ErrorText"></asp:CustomValidator>
                    </div>--%>
                </div>
                
            </asp:Panel>
            <div style="clear: both;"></div>
        </div>    
    </div>
    
    <Telerik:ReportViewer runat="server" ID="rvAccountsReceivables" Width="100%" Height="900px" ShowPrintPreviewButton="False" ViewMode="PrintPreview"></Telerik:ReportViewer>
    
    <Telerik:RadAjaxManager runat="server">
        <AjaxSettings>
            <Telerik:AjaxSetting AjaxControlID="btnGenerate">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="rvAccountsReceivables"/>
                </UpdatedControls>
            </Telerik:AjaxSetting>
        </AjaxSettings>
    </Telerik:RadAjaxManager>

</asp:Content>