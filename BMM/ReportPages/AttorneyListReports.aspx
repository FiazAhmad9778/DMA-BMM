<%@ Page Language="C#" MasterPageFile="../Master.Master" AutoEventWireup="true" CodeBehind="AttorneyListReports.aspx.cs" Inherits="BMM.ReportPages.AttorneyListReports" %>






<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
        <telerik:RadCodeBlock runat="server" ID="rcbHeader">
            <h1>Attorney List Report</h1>
        </telerik:RadCodeBlock>
        <telerik:ReportViewer ID="rptvAttorneyList" runat="server" Width="100%" Height="900px" Visible="true" ViewMode="PrintPreview" ParametersAreaVisible="False" ShowParametersButton="False" ShowPrintPreviewButton="False"></telerik:ReportViewer>
    </telerik:RadAjaxPanel>
</asp:Content>
