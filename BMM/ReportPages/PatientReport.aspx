<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="PatientReport.aspx.cs" Inherits="BMM.ReportPages.PatientReport" %>






<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1>
        Patient Report
    </h1>
    <br/>
    <Telerik:ReportViewer runat="server" ID="rvPatientReport" Width="100%" Height="1150px" ShowPrintPreviewButton="False" ViewMode="PrintPreview"></Telerik:ReportViewer>

</asp:Content>
