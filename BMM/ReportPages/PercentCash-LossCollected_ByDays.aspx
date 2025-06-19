<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="PercentCash-LossCollected_ByDays.aspx.cs" Inherits="BMM.ReportPages.PercentCash_LossCollected_ByDays" %>






<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1>Percent Cash / Loss Collected by Days
    </h1>
    <div style="margin-left: 15px; font-family: Arial !important;">
        <div>
            <div style="float: left;">
                <div>
                    <div style="width: 220px; float: left;">
                        <div style="float: left; margin-top: 3px; margin-right: 5px; font-size: 14px; font-family: Arial !important;">End Date:</div>
                        <div style="float: left; width: 140px;">
                            <telerik:RadDatePicker ID="rdpEndDate" Width="125px" runat="server"></telerik:RadDatePicker>
                        </div>
                    </div>
                </div>
            </div>
            <div style="margin-bottom: 5px;">
                <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="rdpEndDate" Display="Dynamic" Text="* End Date Required" CssClass="ErrorText"></asp:RequiredFieldValidator>
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
                    <asp:RadioButtonList ID="rblAttorney" runat="server" RepeatColumns="2" RepeatDirection="Vertical" RepeatLayout="Table" CellPadding="5" CellSpacing="2" AutoPostBack="true" OnSelectedIndexChanged="rblAttorney_OnSelectedIndexChanged">
                        <asp:ListItem Text="All Attorneys" Selected="True" Value="All"></asp:ListItem>
                        <asp:ListItem Text="Specific Attorney" Value="Single"></asp:ListItem>
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

    <telerik:ReportViewer runat="server" ID="rvPercentCash_LossCollected_ByDays" Width="100%" Height="900px" ShowPrintPreviewButton="False" ViewMode="PrintPreview"></telerik:ReportViewer>

    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="btnGenerate">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="rvPercentCash_LossCollected_ByDays" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="rblAttorney">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="rcbAttorney" />
                    <telerik:AjaxUpdatedControl ControlID="rblAttorney" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
</asp:Content>
