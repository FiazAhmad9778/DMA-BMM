<%@ Page Language="C#" MasterPageFile="../Master.Master" AutoEventWireup="true" CodeBehind="TotalTestsAndSurgeriesByAttorney.aspx.cs" Inherits="BMM.ReportPages.TotalTestsAndSurgeriesByAttorney" %>







<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1>
        Total Tests and Procedures by Attorney
    </h1>
    <br/>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
        <div style="margin-left: 15px; font-family: Arial !important;">
            <div>
                <table>
                    <tr>
                        <td>
                            <div style="float: left; margin-top: 3px; margin-right: 5px; font-size: 14px; font-family: Arial !important;">Year:</div>
                        </td>
                        <td>
                            <Telerik:RadComboBox runat="server" ID="ddlYears" Width="125px"></Telerik:RadComboBox>
                        </td>
                        <td>
                            <asp:Button ID="btnGenerate" runat="server" Text="Generate" CausesValidation="true" OnClick="btnGenerate_OnClick" />
                        </td>
                    </tr>
                    <tr>
                        <td>Attorney Criteria</td>
                        <td><asp:RadioButtonList ID="rblAttorneys" runat="server" RepeatColumns="2" RepeatDirection="Vertical" RepeatLayout="Table" CellPadding="5" CellSpacing="2" AutoPostBack="true" OnSelectedIndexChanged="rblAttorneys_SelectedIndexChanged">
                            <asp:ListItem Text="All Attorneys" Selected="True" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Specific Attorney" Value="1"></asp:ListItem>
                        </asp:RadioButtonList></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td><telerik:RadComboBox ID="rcbAttorney" runat="server" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true"
                            EnableLoadOnDemand="true" EnableItemCaching="true" Visible="false" OnItemsRequested="rcbAttorney_ItemsRequested" />
                        <asp:RequiredFieldValidator ID="rfvAttorney" runat="server" ControlToValidate="rcbAttorney" Enabled="false" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" /></td>
                    </tr>
                </table>
            </div>
            <div style="clear: both;"></div>
        </div>
        <br />
        <telerik:ReportViewer runat="server" ID="rptTotals" Width="100%" Height="900px" ViewMode="PrintPreview" ParametersAreaVisible="False" ShowParametersButton="False" ShowPrintPreviewButton="False"></telerik:ReportViewer>
    </telerik:RadAjaxPanel>

</asp:Content>
