<%@ Page Language="C#" MasterPageFile="../Master.Master" AutoEventWireup="true" CodeBehind="AttorneyLettersReport.aspx.cs" Inherits="BMM.ReportPages.AttorneyLettersReport" %>







<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head"></asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
         <h1>Attorney Letters</h1>
        <div style="margin-left:15px;font-family:Arial !important;">
            <div style="margin-bottom:10px;font-size:14px;">Report Views:</div>
            <div style="clear:both;"></div>
            <div>
                <div style="float:left;">
                    <asp:RadioButtonList ID="rblAttorneyLetter" OnSelectedIndexChanged="rblAttorneyLetter_SelectedIndexChanged" AutoPostBack="true" runat="server" RepeatColumns="2" RepeatDirection="Horizontal" RepeatLayout="Table" CellPadding="5" CellSpacing="2">
                        <asp:ListItem Text="All Invoices For Attorneys" Selected="True" Value="0"></asp:ListItem>
                        <asp:ListItem Text="Specific Attorney" Value="1"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>
                <div style="float:left;margin-left:20px;">
                    <asp:Button ID="btnGenerate" runat="server" Text="Generate" CausesValidation="true" OnClick="btnGenerate_Click" />
                </div>
            </div>
            <div style="clear:both;"></div>
            <div style="float:left">
                        <telerik:RadComboBox ID="rcbAttorney" runat="server" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true"
                            EnableLoadOnDemand="true" EnableItemCaching="true" Visible="false" OnItemsRequested="rcbAttorney_ItemsRequested" />
                        <asp:RequiredFieldValidator ID="rfvAttorney" runat="server" ControlToValidate="rcbAttorney" Enabled="false" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
            </div>
        </div>
    <br/>
    <br/>
    
    <telerik:ReportViewer ID="rvAttorneyLetter" runat="server" Width="100%" Height="1150px" ShowPrintPreviewButton="False" ViewMode="PrintPreview"></telerik:ReportViewer>
           

</asp:Content>