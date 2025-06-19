<%@ Page Language="C#" MasterPageFile="../Master.Master" AutoEventWireup="true" CodeBehind="AttorneyStatementsReports.aspx.cs" Inherits="BMM.ReportPages.AttorneyStatementsReports" %>







<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=17.2.23.1114, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head"></asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <telerik:RadAjaxPanel runat="server">
        <telerik:RadCodeBlock runat="server" ID="rcbHeader">
            <h1>Attorney Statements</h1>
        </telerik:RadCodeBlock>
        <asp:Panel runat="server" ID="pnlReport">
             <div style="margin-left: 15px; margin-top: 10px; font-family: Arial !important">
                <span style="font-size: 14px; margin-bottom: 10px;">
                    Service Date Criteria:
                </span>
                 <div style="clear: both;"></div>
                 <div>
                     <div style="float: left;">
                         <asp:RadioButtonList ID="rblServiceDate" runat="server" RepeatColumns="2" RepeatDirection="Vertical" RepeatLayout="Table" CellPadding="5" CellSpacing="2" AutoPostBack="true" OnSelectedIndexChanged="rblServiceDate_SelectedIndexChanged">
                            <asp:ListItem Text="All Dates" Selected="True" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Service Date Range" Value="1"></asp:ListItem>
                        </asp:RadioButtonList>
                     </div>
                        

                    <div id="divSDate" runat="server" visible="false" style="float: left; margin-top: 10px; margin-left: 5px; margin-right: 5px; font-size: 14px;">Start Date:</div>
                    <div style="float: left; width: 140px; margin-top: 10px;">
                        <Telerik:RadDatePicker runat="server" Visible="false" ID="rdpStartDate" Width="125px"></Telerik:RadDatePicker>
                        <asp:RequiredFieldValidator ID="rfvStart" runat="server" ControlToValidate="rdpStartDate" Enabled="false" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                    </div>
                    <div id="divEDate" runat="server" visible="false" style="float: left; margin-top: 10px; margin-left: 5px; font-size: 14px;">End Date:</div>
                    <div style="float: left; width: 140px; margin-top: 10px;">
                        <Telerik:RadDatePicker runat="server" Visible="false" ID="rdpEndDate" Width="125px"></Telerik:RadDatePicker>
                        <asp:RequiredFieldValidator ID="rfvEnd" runat="server" ControlToValidate="rdpEndDate" Enabled="false" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                    </div>
                 </div>
                    
                 <div style="clear: both;"></div>
             </div>
            <div style="margin-left: 15px; margin-top:10px; font-family: Arial !important">
                <div style=" font-size: 14px;">Attorney Criteria:</div>
                <div style="clear: both;"></div>
                <div>
                    <div style="float: left;">
                        <asp:RadioButtonList ID="rblAttorneys" runat="server" RepeatColumns="2" RepeatDirection="Vertical" RepeatLayout="Table" CellPadding="5" CellSpacing="2" AutoPostBack="true" OnSelectedIndexChanged="rblAttorneys_SelectedIndexChanged">
                            <asp:ListItem Text="All Attorneys" Selected="True" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Specific Attorney" Value="1"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div style="float: left; margin-left: 5px; margin-top: 7px;">
                        <telerik:RadComboBox ID="rcbAttorney" runat="server" AllowCustomText="true" Filter="Contains" MinFilterLength="3" MarkFirstMatch="true"
                            EnableLoadOnDemand="true" EnableItemCaching="true" Visible="false" OnItemsRequested="rcbAttorney_ItemsRequested" />
                        <asp:RequiredFieldValidator ID="rfvAttorney" runat="server" ControlToValidate="rcbAttorney" Enabled="false" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                    </div>
                </div>
                 <div style="clear: both;"></div>   
            </div>

            <div style="margin-left: 15px; font-family: Arial !important">
                <div style="clear: both;"></div>
                <div id="divStatement" runat="server" style="float: left; margin-top: 10px;margin-right: 5px; font-size: 14px;">Statement Date:</div>
                    <div style="float: left; width: 140px; margin-top: 7px;">
                        <Telerik:RadDatePicker runat="server" ID="rdpStatementDate" Width="125px"></Telerik:RadDatePicker>
                        <asp:RequiredFieldValidator ID="rfvStatement" runat="server" ControlToValidate="rdpStatementDate" Enabled="true" ErrorMessage="<br/>Required" CssClass="ErrorText" Display="Dynamic" />
                    </div>
                <div style="clear: both;"></div> 
            </div>
            <div style="margin-left: 15px; margin-top: 10px; font-family: Arial !important">
                <div style=" font-size: 14px;">Report Views:</div>
                <div style="clear: both;"></div>
                <div>
                    <div style="float: left;">
                        <asp:RadioButtonList ID="rblAttorneyStatement" runat="server" RepeatColumns="2" RepeatDirection="Vertical" RepeatLayout="Table" CellPadding="5" CellSpacing="2">
                            <asp:ListItem Text="All Invoices For Attorneys" Selected="True" Value="All"></asp:ListItem>
                            <asp:ListItem Text="Past Due Invoices" Value="Past"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    
                    <div style="float: left; margin-left: 20px;">
                        <asp:Button ID="btnGenerate" runat="server" Text="Generate" CausesValidation="true" OnClick="btnGenerate_OnClick" />
                    </div>
                </div>
               
                <div style="clear: both"></div>
            </div>
             
        </asp:Panel>
        <br/>
        <telerik:ReportViewer ID="rptvAttorneyStatement" runat="server" Width="100%" Height="900px" ViewMode="PrintPreview" ParametersAreaVisible="False" ShowParametersButton="False" ShowPrintPreviewButton="False"></telerik:ReportViewer>
    </telerik:RadAjaxPanel>
</asp:Content>
