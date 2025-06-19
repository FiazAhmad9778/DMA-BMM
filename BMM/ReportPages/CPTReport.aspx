<%@ Page Language="C#" MasterPageFile="../Master.Master" AutoEventWireup="true" CodeBehind="CPTReport.aspx.cs" Inherits="BMM.ReportPages.CPTReport" %>






<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
        <telerik:RadCodeBlock runat="server" ID="rcbHeader">
            <h1>CPT Report</h1>
        </telerik:RadCodeBlock>
        <asp:Panel runat="server" ID="pnlReport">
               <div style="margin-left: 15px; margin-top:10px; font-family: Arial !important">
                <div style="clear: both;"></div>
                <div>
                    <div id="divICD" runat="server" visible="true" style="float: left; margin-top: 10px; margin-left: 5px; margin-right: 5px; font-size: 14px;">Select CPT Code:</div>
                    <div style="float: left; margin-top: 7px;">
                        <telerik:RadComboBox ID="rcbCPTCode" runat="server" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true"
                            EnableLoadOnDemand="true" EnableItemCaching="true" Visible="true" OnItemsRequested="rcbCPTCode_ItemsRequested" />
                        <asp:RequiredFieldValidator ID="rfvCPT" runat="server" ControlToValidate="rcbCPTCode" Enabled="true" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                        <asp:Literal ID="litError" runat="server" />
                    </div>
                </div>
                 <div style="clear: both;"></div>   
            </div>
             <div style="margin-left: 15px; margin-top: 10px; font-family: Arial !important">
                
                    <div id="divSDate" runat="server" visible="true" style="float: left; margin-top: 10px; margin-left: 5px; margin-right: 5px; font-size: 14px;">Service Start Date:</div>
                    <div style="float: left; width: 140px; margin-top: 5px;">
                        <Telerik:RadDatePicker runat="server" Visible="true" ID="rdpStartDate" Width="125px"></Telerik:RadDatePicker>
                        <asp:RequiredFieldValidator ID="rfvStart" runat="server" ControlToValidate="rdpStartDate" Enabled="false" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                    </div>
                    <div id="divEDate" runat="server" visible="true" style="float: left; margin-top: 10px; margin-left: 5px; font-size: 14px;">End Date:</div>
                    <div style="float: left; width: 140px; margin-top: 5px;">
                        <Telerik:RadDatePicker runat="server" Visible="true" ID="rdpEndDate" Width="125px"></Telerik:RadDatePicker>
                        <asp:RequiredFieldValidator ID="rfvEnd" runat="server" ControlToValidate="rdpEndDate" Enabled="true" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                    </div>
                 </div>
                    <div style="float: left; margin-left: 20px;">
                        <asp:Button ID="btnGenerate" runat="server" Text="Generate" CausesValidation="true" OnClick="btnGenerate_Click" />
                    </div>
                 <div style="clear: both;"></div>
        </asp:Panel>
        <br/>
        <telerik:ReportViewer ID="rptvCPT" runat="server" Visible="false" Width="100%" Height="900px" ViewMode="PrintPreview" ParametersAreaVisible="False" ShowParametersButton="False" ShowPrintPreviewButton="False"></telerik:ReportViewer>
    </telerik:RadAjaxPanel>
</asp:Content>