<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="DiscountReport.aspx.cs" Inherits="BMM.DiscountReport" %>






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
    <h1>
        Reduction Report
    </h1>
    
    <asp:Panel ID="pnlReportParameters" runat="server">
        <div style="margin-left: 15px; margin-bottom: 1em;">
            <div>
                <div style="width: 220px; float: left;">
                    <div style="float: left; margin-top: 3px; margin-right: 5px; font-size: 14px;">Start Date:</div>
                    <div style="float: left; width: 140px;">
                        <Telerik:RadDatePicker runat="server" ID="rdpStartDate" Width="125px"></Telerik:RadDatePicker>
                    </div>
                </div>
                <div style="width: 220px; float: left; margin-left: 15px;">
                    <div style="float: left; margin-top: 3px; margin-right: 5px; font-size: 14px;">End Date:</div>
                    <div style="float: left; width: 140px;">
                        <Telerik:RadDatePicker runat="server" ID="rdpEndDate" Width="125px"></Telerik:RadDatePicker>
                    </div>
                </div>
                <div style="float: left; margin-bottom: 5px;">
                    <div>
                        <asp:RequiredFieldValidator runat="server" ID="rfvStartDate" ControlToValidate="rdpStartDate" Display="Dynamic" Text="* Start Date Required" CssClass="ErrorText"></asp:RequiredFieldValidator>
                    </div>
                    <div>
                        <asp:RequiredFieldValidator runat="server" ID="rfvEndDate" ControlToValidate="rdpEndDate" Display="Dynamic" Text="* End Date Required" CssClass="ErrorText"></asp:RequiredFieldValidator>
                    </div>
                    <div>
                        <asp:CustomValidator runat="server" ID="cvDateRange" Display="Dynamic" ControlToValidate="" ClientValidationFunction="CheckStartEndDates" Text="* Start date must come before End date" CssClass="ErrorText"></asp:CustomValidator>
                    </div>
                </div>
                <div style="clear: both;"></div>
            </div>
            <div style="margin-top: 20px;">
                <div style="margin-bottom: 10px; font-size: 14px;">
                    Report Views:
                </div>
                <div>
                    <div style="float: left;">
                        <div>
                            <asp:RadioButtonList runat="server" ID="rblReportViews" RepeatDirection="Horizontal" RepeatLayout="Table" CellPadding="5" CellSpacing="2" OnSelectedIndexChanged="rblReportViews_OnSelectedIndexChanged" AutoPostBack="True">
                                <asp:ListItem Text="All Attorneys" Value="all" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Specific Attorney" Value="one"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div>
                            <Telerik:RadComboBox runat="server" ID="rcbAttorney" AllowCustomText="False" Filter="Contains" MinFilterLength="3" MarkFirstMatch="True"
                                EnableLoadOnDemand="True" EnableItemCaching="True" OnItemsRequested="rcbAttorney_OnItemsRequested"></Telerik:RadComboBox>
                            <div style="margin-top: 1em;">
                                <asp:RequiredFieldValidator runat="server" ID="rfvAttorney" Enabled="False" ControlToValidate="rcbAttorney" ErrorMessage="Required" CssClass="ErrorText" Display="Dynamic"></asp:RequiredFieldValidator>
                                
                                <%--Added custom validator to catch when an invalid entry is inserted in the combo box.--%>
                                <asp:CustomValidator runat="server" ID="cvAttorney" Enabled="False" ControlToValidate="rcbAttorney" ErrorMessage="Required" CssClass="ErrorText" Display="Dynamic" OnServerValidate="cvAttorney_OnServerValidate"></asp:CustomValidator>
                            </div>
                        </div>
                    </div>
                    <div style="float: left; margin-left: 20px;">
                        <asp:Button runat="server" ID="btnGenerate" Text="Generate" CausesValidation="True" OnClick="btnGenerate_OnClick"/>
                    </div>
                    <div style="clear: both;"></div>
                </div>
            </div>
        </div>
    </asp:Panel>
    
    
    
    <Telerik:ReportViewer runat="server" ID="rvDiscount" Width="100%" Height="900px" ViewMode="PrintPreview" ShowPrintPreviewButton="False"></Telerik:ReportViewer>
    
    <Telerik:RadAjaxManager runat="server">
        <AjaxSettings>
            <Telerik:AjaxSetting AjaxControlID="pnlReportParameters">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="pnlReportParameters"/>
                </UpdatedControls>
            </Telerik:AjaxSetting>
            <Telerik:AjaxSetting AjaxControlID="btnGenerate">
                <UpdatedControls>
                    <Telerik:AjaxUpdatedControl ControlID="rvDiscount"/>
                </UpdatedControls>
            </Telerik:AjaxSetting>
        </AjaxSettings>
    </Telerik:RadAjaxManager>
</asp:Content>
